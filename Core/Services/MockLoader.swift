//
//  MockLoader.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import Foundation

struct MockLoader {
    static func loadMockQuestions() -> [MockQuestion] {
        guard let url = Bundle.main.url(forResource: "MockQuestions", withExtension: "json") else {
            print("MockLoader: File not found.")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([MockQuestion].self, from: data)
            print("MockLoader: Loaded \(questions.count) questions.")
            return questions
        } catch {
            print("MockLoader: Error loading questions: \(error)")
            return []
        }
    }
}
