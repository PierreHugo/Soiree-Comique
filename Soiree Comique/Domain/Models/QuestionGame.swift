//
//  QuestionGame.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import Foundation

enum QuestionGame: String, CaseIterable, Identifiable, Codable {
    case pointeDuDoigt
    case jeNAiJamais
    case actionOuShot

    var id: String { rawValue }

    var title: String {
        switch self {
        case .pointeDuDoigt: return "Pointe du doigt 🫵"
        case .jeNAiJamais: return "Je n’ai jamais 🙈"
        case .actionOuShot: return "Action ou shot 🥂"
        }
    }
}

struct QuestionPrompt: Identifiable, Codable, Hashable {
    let id: UUID
    let game: QuestionGame
    let text: String

    /// Uniquement pour actionOuShot (ex: 1 facile, 2 moyen, 3 hard)
    let difficulty: Int?

    init(id: UUID = UUID(), game: QuestionGame, text: String, difficulty: Int? = nil) {
        self.id = id
        self.game = game
        self.text = text
        self.difficulty = difficulty
    }
}
