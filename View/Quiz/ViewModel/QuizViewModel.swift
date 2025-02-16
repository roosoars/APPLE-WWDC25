//
//  QuizViewModel.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI
import Combine
import CoreML

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var isQuizCompleted = false
    @Published var selectedOption: String? = nil
    @Published var remainingTime: Int = 0
    @Published var isLoading: Bool = true
    
    private var timer: AnyCancellable?
    let difficulty: Difficulty
    let totalTime: Int
    
    let emotions = ["HAPPY", "ANGRY", "SAD", "SHOCKED", "FEAR", "DISGUSTED", "NEUTRAL"]
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        self.totalTime  = QuizViewModel.timeLimit(for: difficulty)
        loadQuestions()
    }
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    static func timeLimit(for difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy:   return 20
        case .medium: return 15
        case .hard:   return 10
        case .final:  return 5
        }
    }
    
    func loadQuestions() {
        DispatchQueue.global(qos: .userInitiated).async {
            let mockQuestions = MockLoader.loadMockQuestions()
            let filtered = mockQuestions.filter {
                $0.difficulty.lowercased() == self.difficulty.rawValue.lowercased()
            }
            var tempQuestions: [QuizQuestion] = []
            let group = DispatchGroup()
            
            for mq in filtered {
                group.enter()
                guard let uiImage = UIImage(named: mq.imageName) else {
                    print("QuizViewModel: Image \(mq.imageName) not found.")
                    group.leave()
                    continue
                }
                guard let resized = uiImage.resized(to: CGSize(width: 360, height: 360)),
                      let pixelBuffer = resized.toCVPixelBuffer() else {
                    print("QuizViewModel: Error processing image \(mq.imageName).")
                    group.leave()
                    continue
                }
                do {
                    let config = MLModelConfiguration()
                    let model  = try EMOTION_ML(configuration: config)
                    let prediction = try model.prediction(image: pixelBuffer)
                    
                    let probabilities = prediction.targetProbability
                    if let (predictedEmotion, _) = probabilities.max(by: { $0.value < $1.value }) {
                        let correct = predictedEmotion.uppercased()
                        var optionsSet = Set<String>()
                        optionsSet.insert(correct)
                        while optionsSet.count < 4 {
                            if let randomOption = self.emotions.randomElement() {
                                optionsSet.insert(randomOption)
                            }
                        }
                        let options = Array(optionsSet).shuffled()
                        let question = QuizQuestion(imageName: mq.imageName,
                                                    correctEmotion: correct,
                                                    options: options,
                                                    difficulty: self.difficulty)
                        DispatchQueue.main.async {
                            tempQuestions.append(question)
                            group.leave()
                        }
                    } else {
                        DispatchQueue.main.async {
                            group.leave()
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("QuizViewModel: Prediction error for \(mq.imageName): \(error)")
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.questions = tempQuestions.shuffled()
                self.currentQuestionIndex = 0
                self.score = 0
                self.isQuizCompleted = false
                self.selectedOption = nil
                self.startTimer()
                self.isLoading = false
            }
        }
    }
    
    func startTimer() {
        remainingTime = totalTime
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                }
                if self.remainingTime == 0 {
                    self.processAnswer("")
                }
            }
    }
    
    func selectOption(_ option: String) {
        guard selectedOption == nil else { return }
        processAnswer(option)
    }
    
    func processAnswer(_ option: String) {
        timer?.cancel()
        selectedOption = option
        if let question = currentQuestion, option == question.correctEmotion {
            score += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.advance()
        }
    }
    
    func advance() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            selectedOption = nil
            startTimer()
        } else {
            isQuizCompleted = true
        }
    }
    
    func buttonBackground(for option: String) -> Color {
        guard let selected = selectedOption else { return .blue }
        if selected == option {
            return (option == currentQuestion?.correctEmotion) ? .green : .red
        } else if option == currentQuestion?.correctEmotion {
            return .green
        }
        return .gray
    }
    
    func restart() {
        timer?.cancel()
        loadQuestions()
    }
}
