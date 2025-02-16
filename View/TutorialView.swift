//
//  TutorialView.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI

struct TutorialView: View {
    let difficulty: Difficulty
    @Binding var homePath: NavigationPath
    @State private var currentPage = 0
    @State private var showQuiz = false
    
    init(difficulty: Difficulty, homePath: Binding<NavigationPath>) {
        self.difficulty = difficulty
        self._homePath = homePath
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    var tutorials: [ExpressionTutorial] {
        switch difficulty {
        case .easy:
            return [
                ExpressionTutorial(
                    title: "Happy",
                    imageName: "HAPPY_3",
                    shortDescription: "Let's learn the expression 'HAPPY'",
                    detailedDescription: "To identify a happy expression, look for smiling eyes and widened lips."
                ),
                ExpressionTutorial(
                    title: "Angry",
                    imageName: "ANGRY_4",
                    shortDescription: "Let's learn the expression 'ANGRY'",
                    detailedDescription: "Observe furrowed eyebrows and pressed lips."
                )
            ]
        case .medium:
            return [
                ExpressionTutorial(
                    title: "Sad",
                    imageName: "SAD_4",
                    shortDescription: "Let's learn the expression 'SAD'",
                    detailedDescription: "Look for drooping eyes and a slight downward curve of the mouth."
                )
            ]
        case .hard:
            return [
                ExpressionTutorial(
                    title: "Shocked",
                    imageName: "SHOCKED_5",
                    shortDescription: "Let's learn the expression 'SHOCKED'",
                    detailedDescription: "Wide-open eyes and a slightly open mouth are strong indicators."
                )
            ]
        case .final:
            return []
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("Tutorial - \(difficulty.rawValue)")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 30)
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Tutorial for \(difficulty.rawValue) challenge")
            
            ZStack {
                Color(UIColor.systemGray6)
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack {
                    if !tutorials.isEmpty {
                        TabView(selection: $currentPage) {
                            ForEach(tutorials.indices, id: \.self) { index in
                                VStack(spacing: 16) {
                                    Image(tutorials[index].imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 170, height: 170)
                                        .cornerRadius(10)
                                        .accessibilityHidden(true)
                                    
                                    Text(tutorials[index].shortDescription)
                                        .font(.headline)
                                    
                                    Text(tutorials[index].detailedDescription)
                                        .font(.body)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                                .tag(index)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Tutorial \(index + 1): \(tutorials[index].title). \(tutorials[index].shortDescription)")
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .padding(.bottom, 30)
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("Tutorial pages")
                        
                        Button {
                            if currentPage < tutorials.count - 1 {
                                currentPage += 1
                            } else {
                                showQuiz = true
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text(currentPage < tutorials.count - 1 ? "Next" : "Start Quiz")
                                    .font(.headline)
                                Spacer()
                            }
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        .accessibilityLabel(currentPage < tutorials.count - 1 ? "Next tutorial" : "Start Quiz")
                        .accessibilityHint(currentPage < tutorials.count - 1 ? "Tap to view the next tutorial." : "Tap to start the quiz.")
                        .fullScreenCover(isPresented: $showQuiz) {
                            QuizView(difficulty: difficulty, homePath: $homePath)
                        }
                    } else {
                        Text("No tutorial available for this challenge.")
                            .font(.headline)
                            .padding()
                            .accessibilityLabel("No tutorial available for this challenge")
                        
                        Button("Start Quiz") {
                            showQuiz = true
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .accessibilityLabel("Start Quiz")
                        .accessibilityHint("Tap to start the quiz.")
                        .fullScreenCover(isPresented: $showQuiz) {
                            QuizView(difficulty: difficulty, homePath: $homePath)
                        }
                    }
                    
                    Spacer()
                }
                .accessibilityElement(children: .contain)
            }
        }
        .accessibilityElement(children: .contain)
    }
}
