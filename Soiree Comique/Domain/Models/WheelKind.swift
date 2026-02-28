//
//  WheelKind.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import Foundation

enum WheelKind: String, Identifiable, CaseIterable {
    case sips
    case drink
    case peanuts

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sips: return "Gorgées 🫗"
        case .drink: return "Boisson 🍹"
        case .peanuts: return "Cacahuètes 🥜"
        }
    }
}
