//
//  WheelViewModel.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import Foundation
import Combine

@MainActor
final class WheelViewModel: ObservableObject {

    @Published private(set) var wheels: [WheelDefinition] = []

    init() {
        wheels = [
            WheelDefinition(
                id: .sips,
                options: (1...10).map { WheelOption(title: "\($0)") }
            ),
            WheelDefinition(
                id: .drink,
                options: [
                    WheelOption(title: "Soft"),
                    WheelOption(title: "Gin"),
                    WheelOption(title: "Bière"),
                    WheelOption(title: "Vodka")
                ]
            ),
            WheelDefinition(
                id: .peanuts,
                options: (0...2).map { WheelOption(title: "\($0)") }
            )
        ]
    }

    // MARK: - Edition API (on l’utilisera pour la sheet ensuite)

    func canAddOption(to kind: WheelKind) -> Bool {
        true
    }

    func canRemoveOption(from kind: WheelKind) -> Bool {
        // on évite juste une roue vide
        guard let wheel = wheels.first(where: { $0.id == kind }) else { return false }
        return wheel.options.count > 1
    }

    func addOption(to kind: WheelKind, title: String) {
        guard canAddOption(to: kind) else { return }
        guard let idx = wheels.firstIndex(where: { $0.id == kind }) else { return }
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        wheels[idx].options.append(WheelOption(title: trimmed))
    }

    func removeOption(from kind: WheelKind, optionId: UUID) {
        guard canRemoveOption(from: kind) else { return }
        guard let idx = wheels.firstIndex(where: { $0.id == kind }) else { return }
        wheels[idx].options.removeAll { $0.id == optionId }
    }

    func renameOption(in kind: WheelKind, optionId: UUID, newTitle: String) {
        guard let wIdx = wheels.firstIndex(where: { $0.id == kind }) else { return }
        guard let oIdx = wheels[wIdx].options.firstIndex(where: { $0.id == optionId }) else { return }
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        wheels[wIdx].options[oIdx].title = trimmed
    }
    
    func wheel(for kind: WheelKind) -> WheelDefinition? {
        wheels.first(where: { $0.id == kind })
    }

    func options(for kind: WheelKind) -> [WheelOption] {
        wheel(for: kind)?.options ?? []
    }
    
    func reset(kind: WheelKind) {
        guard let idx = wheels.firstIndex(where: { $0.id == kind }) else { return }

        switch kind {
        case .sips:
            wheels[idx].options = (1...10).map { WheelOption(title: "\($0)") }

        case .drink:
            wheels[idx].options = [
                WheelOption(title: "Soft"),
                WheelOption(title: "Gin"),
                WheelOption(title: "Bière"),
                WheelOption(title: "Vodka")
            ]

        case .peanuts:
            wheels[idx].options = (0...2).map { WheelOption(title: "\($0)") }
        }
    }
}
