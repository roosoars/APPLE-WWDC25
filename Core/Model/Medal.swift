//
//  Medal.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 10/02/25.
//

import Foundation

enum Medal: String, Codable, CaseIterable, Identifiable {
    case easy   = "Level 1"
    case medium = "Level 2"
    case hard   = "Level 3"
    case final  = "Level 4"
    
    var id: String { rawValue }
    
    init(for difficulty: Difficulty) {
        switch difficulty {
        case .easy:
            self = .easy
        case .medium:
            self = .medium
        case .hard:
            self = .hard
        case .final:
            self = .final
        }
    }
}
