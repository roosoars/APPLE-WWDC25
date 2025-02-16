//
//  QuizQuestionView.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI

struct QuizQuestionView: View {
    @ObservedObject var viewModel: QuizViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
                .font(.headline)
                .padding(.top, 20)
                .accessibilityLabel("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
            
            if let question = viewModel.currentQuestion {
                Image(question.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .shadow(radius: 5)
                    .accessibilityLabel("Quiz image for question \(viewModel.currentQuestionIndex + 1)")
                
                Text("What emotion is being expressed?")
                    .font(.title2)
                    .padding(.bottom, 4)
                    .accessibilityLabel("What emotion is being expressed?")
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(question.options, id: \.self) { option in
                        Button {
                            viewModel.selectOption(option)
                        } label: {
                            Text(option)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.buttonBackground(for: option))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(viewModel.selectedOption != nil)
                        .accessibilityLabel("Option \(option)")
                        .accessibilityHint("Double tap to select option \(option)")
                    }
                }
                .padding(.horizontal, 16)
                
                let minutes = viewModel.remainingTime / 60
                let seconds = viewModel.remainingTime % 60
                let timeString = String(format: "%02d:%02d", minutes, seconds)
                
                Text("Remaining time: \(timeString)")
                    .font(.headline)
                    .foregroundColor((minutes == 0 && seconds < 5) ? .red : .primary)
                    .padding(.horizontal, 0)
                    .accessibilityLabel("Remaining time \(timeString)")
            }
            
            Spacer()
        }
        .padding()
    }
}
