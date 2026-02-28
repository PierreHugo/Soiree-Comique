//
//  QuestionsViewModel.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import Foundation
import Combine

@MainActor
final class QuestionsViewModel: ObservableObject {

    @Published var selectedGame: QuestionGame = .pointeDuDoigt
    @Published private(set) var current: QuestionPrompt? = nil
    @Published private(set) var isLoaded: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let repo: QuestionsRepositoryProtocol
    private var all: [QuestionPrompt] = []

    // anti-répétition par mode
    private var remainingByGame: [QuestionGame: [QuestionPrompt]] = [:]

    init(repo: QuestionsRepositoryProtocol? = nil) {
            self.repo = repo ?? QuestionsRepository()
        }

    func load() {
        do {
            all = try repo.loadAll()
            resetPools()
            isLoaded = true
            errorMessage = nil
            draw()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func draw() {
        guard isLoaded else { return }
        var pool = remainingByGame[selectedGame] ?? []

        if pool.isEmpty {
            // on a épuisé, on recharge pour ce mode
            pool = all.filter { $0.game == selectedGame }
        }

        guard !pool.isEmpty else {
            current = nil
            return
        }

        let pickIndex = Int.random(in: 0..<pool.count)
        let picked = pool.remove(at: pickIndex)

        remainingByGame[selectedGame] = pool
        current = picked
    }

    func resetCurrentMode() {
        remainingByGame[selectedGame] = all.filter { $0.game == selectedGame }
        current = nil
        draw()
    }

    private func resetPools() {
        var dict: [QuestionGame: [QuestionPrompt]] = [:]
        for game in QuestionGame.allCases {
            dict[game] = all.filter { $0.game == game }
        }
        remainingByGame = dict
    }
}
