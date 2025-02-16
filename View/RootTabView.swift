//
//  RootTabView.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI

struct RootTabView: View {
    @State private var homePath    = NavigationPath()
    @State private var rewardsPath = NavigationPath()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $homePath) {
                HomeView(homePath: $homePath)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Home tab")
            .accessibilityHint("Tap to view the home screen")
            
            NavigationStack(path: $rewardsPath) {
                RewardsView()
            }
            .tabItem {
                Image(systemName: "star.circle.fill")
                Text("Rewards")
            }
            .tag(1)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Rewards tab")
            .accessibilityHint("Tap to view the rewards screen")
        }
    }
}
