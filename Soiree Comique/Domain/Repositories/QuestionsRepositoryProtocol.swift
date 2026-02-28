//
//  QuestionsRepositoryProtocol.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import Foundation

protocol QuestionsRepositoryProtocol {
    func loadAll() throws -> [QuestionPrompt]
}

final class QuestionsRepository: QuestionsRepositoryProtocol {

    private let filename: String

    init(filename: String = "questions") {
        self.filename = filename
    }

    func loadAll() throws -> [QuestionPrompt] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "QuestionsRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "questions.json introuvable dans le bundle"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([QuestionPrompt].self, from: data)
    }
}
