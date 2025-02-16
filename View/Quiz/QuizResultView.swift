//
//  QuizResultView.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI

struct QuizResultView: View {
    @ObservedObject var viewModel: QuizViewModel
    let difficulty: Difficulty
    @Binding var homePath: NavigationPath
    @EnvironmentObject var progress: UserProgress
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Text("Quiz Completed!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityLabel("Quiz Completed")
            
            Text("Score: \(viewModel.score) / \(viewModel.questions.count)")
                .font(.title2)
                .accessibilityLabel("Score: \(viewModel.score) out of \(viewModel.questions.count)")
            
            if viewModel.score == viewModel.questions.count {
                Text("Perfect Score!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .onAppear {
                        progress.markCompleted(difficulty)
                        progress.awardMedal(for: difficulty)
                    }
                    .accessibilityLabel("Perfect Score")
            }
            
            Spacer()
            
            if difficulty == .final && viewModel.score == viewModel.questions.count {
                Button {
                    homePath.removeLast(homePath.count)
                } label: {
                    Text("Finish Game")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .accessibilityLabel("Finish Game")
                .accessibilityHint("Tap to finish the game")
            } else {
                HStack(spacing: 20) {
                    Button {
                        viewModel.restart()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .accessibilityHidden(true)
                            Text("Try Again")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .accessibilityLabel("Try Again")
                    .accessibilityHint("Tap to try the quiz again")
                    
                    Button {
                        homePath.removeLast(homePath.count)
                    } label: {
                        HStack {
                            Image(systemName: "house")
                                .accessibilityHidden(true)
                            Text("Home")
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .accessibilityLabel("Home")
                    .accessibilityHint("Tap to return to the home screen")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        .multilineTextAlignment(.center)
    }
}
