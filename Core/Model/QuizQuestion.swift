//
//  QuizQuestion.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let imageName: String
    let correctEmotion: String
    let options: [String]
    let difficulty: Difficulty
}
