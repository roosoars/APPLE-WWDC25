//
//  UserProgress.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import Foundation
import SwiftUI

class UserProgress: ObservableObject {
    static let shared = UserProgress()
    private let defaults = UserDefaults.standard
    private let keyCompleted = "completedDifficulties"
    private let keyMedals    = "earnedMedals"
    
    @Published var completedDifficulties: [Difficulty] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(completedDifficulties) {
                defaults.set(data, forKey: keyCompleted)
            }
        }
    }
    
    @Published var earnedMedals: [Medal] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(earnedMedals) {
                defaults.set(data, forKey: keyMedals)
            }
        }
    }
    
    private init() {
        if let data = defaults.data(forKey: keyCompleted),
           let list = try? JSONDecoder().decode([Difficulty].self, from: data) {
            completedDifficulties = list
        }
        
        if let data = defaults.data(forKey: keyMedals),
           let list = try? JSONDecoder().decode([Medal].self, from: data) {
            earnedMedals = list
        }
    }
    
    func markCompleted(_ difficulty: Difficulty) {
        if !completedDifficulties.contains(difficulty) {
            completedDifficulties.append(difficulty)
        }
    }
    
    func awardMedal(for difficulty: Difficulty) {
        let medal = Medal(for: difficulty)
        if !earnedMedals.contains(medal) {
            earnedMedals.append(medal)
        }
    }
    
    func reset() {
        completedDifficulties.removeAll()
        earnedMedals.removeAll()
    }
}
