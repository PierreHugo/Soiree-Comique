//
//  WheelOption.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import Foundation

struct WheelOption: Identifiable, Hashable {
    let id: UUID
    var title: String

    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}
