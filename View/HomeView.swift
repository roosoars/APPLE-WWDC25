//
//  HomeView.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var progress: UserProgress
    @Binding var homePath: NavigationPath
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("FaceQuiz")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Choose a challenge")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 30)
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("FaceQuiz, choose a challenge")
            
            ZStack {
                Color(UIColor.systemGray6)
                    .edgesIgnoringSafeArea(.bottom)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Difficulty.allCases) { diff in
                            NavigationLink(value: diff) {
                                DifficultyRow(difficulty: diff, isUnlocked: isUnlocked(diff))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            .disabled(!isUnlocked(diff))
                            .accessibilityHint(isUnlocked(diff)
                                ? "Double tap to start the challenge."
                                : "This challenge is locked. Complete previous challenges to unlock it.")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationDestination(for: Difficulty.self) { diff in
            if diff == .final {
                QuizView(difficulty: diff, homePath: $homePath)
                    .navigationBarBackButtonHidden(true)
            } else {
                TutorialView(difficulty: diff, homePath: $homePath)
            }
        }
    }
    
    func isUnlocked(_ difficulty: Difficulty) -> Bool {
        switch difficulty {
        case .easy:
            return true
        case .medium:
            return progress.completedDifficulties.contains(.easy)
        case .hard:
            return progress.completedDifficulties.contains(.easy)
                && progress.completedDifficulties.contains(.medium)
        case .final:
            return progress.completedDifficulties.contains(.easy)
                && progress.completedDifficulties.contains(.medium)
                && progress.completedDifficulties.contains(.hard)
        }
    }
}

struct DifficultyRow: View {
    let difficulty: Difficulty
    let isUnlocked: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(isUnlocked
                      ? AnyShapeStyle(gradient(for: difficulty))
                      : AnyShapeStyle(Color.gray))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: isUnlocked ? "flame.fill" : "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(25)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(difficulty.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(isUnlocked ? "Available" : "Locked")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .frame(height: 90)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(difficulty.rawValue) challenge, \(isUnlocked ? "available" : "locked")")
        .accessibilityHint(isUnlocked
            ? "Double tap to start the challenge."
            : "This challenge is locked. Complete previous challenges to unlock it.")
    }
    
    func gradient(for difficulty: Difficulty) -> LinearGradient {
        switch difficulty {
        case .easy:
            return LinearGradient(gradient: Gradient(colors: [.green, .blue]),
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .medium:
            return LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .hard:
            return LinearGradient(gradient: Gradient(colors: [.orange, .red]),
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .final:
            return LinearGradient(gradient: Gradient(colors: [.red, .black]),
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
