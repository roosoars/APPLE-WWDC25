//
//  RewardsView.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI

struct RewardsView: View {
    @EnvironmentObject var progress: UserProgress
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("My Medals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Earn medals by completing challenges")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("My Medals, Earn medals by completing challenges")
            
            ZStack {
                Color(UIColor.systemGray6)
                    .edgesIgnoringSafeArea(.bottom)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Medal.allCases) { medal in
                            MedalCard(medal: medal, earned: progress.earnedMedals.contains(medal))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct MedalCard: View {
    let medal: Medal
    let earned: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        earned
                        ? AnyShapeStyle(medalGradient(medal))
                        : AnyShapeStyle(Color.gray.opacity(0.3))
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "medal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(medal.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                if earned {
                    Text("Unlocked!")
                        .font(.title3)
                        .foregroundColor(.green)
                } else {
                    Text("Not unlocked yet")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .frame(height: 90)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(medal.rawValue) medal, \(earned ? "Unlocked" : "Not unlocked yet")")
    }
    
    func medalGradient(_ medal: Medal) -> LinearGradient {
        let color = medalColor(medal)
        return LinearGradient(gradient: Gradient(colors: [color.opacity(0.6), color]),
                              startPoint: .top,
                              endPoint: .bottom)
    }
    
    func medalColor(_ medal: Medal) -> Color {
        switch medal {
        case .easy:   return .green
        case .medium: return .blue
        case .hard:   return .orange
        case .final:  return .red
        }
    }
}
