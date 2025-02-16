//
//  FaceQuizApp.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import SwiftUI

@main
struct FaceQuizApp: App {
    init() {
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor.white
        navAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(UserProgress.shared)
        }
    }
}
