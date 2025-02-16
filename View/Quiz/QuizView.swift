//
//  QuizView.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI

struct QuizView: View {
    let difficulty: Difficulty
    @Binding var homePath: NavigationPath
    @StateObject private var viewModel: QuizViewModel
    
    init(difficulty: Difficulty, homePath: Binding<NavigationPath>) {
        self.difficulty = difficulty
        self._homePath  = homePath
        _viewModel      = StateObject(wrappedValue: QuizViewModel(difficulty: difficulty))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("Quiz - \(difficulty.rawValue)")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityLabel("Quiz for \(difficulty.rawValue) challenge")
            }
            .padding(.top, 30)
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .accessibilityElement(children: .combine)
            
            ZStack {
                Color(UIColor.systemGray6)
                    .edgesIgnoringSafeArea(.bottom)
                
                if viewModel.isLoading {
                    ProgressView("Loading Quiz...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .accessibilityLabel("Loading Quiz")
                } else if viewModel.isQuizCompleted {
                    QuizResultView(viewModel: viewModel, difficulty: difficulty, homePath: $homePath)
                        .accessibilityElement(children: .contain)
                } else {
                    QuizQuestionView(viewModel: viewModel)
                        .accessibilityElement(children: .contain)
                }
            }
            .accessibilityElement(children: .contain)
        }
    }
}
