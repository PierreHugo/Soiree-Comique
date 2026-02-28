//
//  WheelDefinition.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import Foundation

struct WheelDefinition: Identifiable, Hashable {
    let id: WheelKind
    var options: [WheelOption]

    init(id: WheelKind, options: [WheelOption], minOptions: Int? = nil, maxOptions: Int? = nil) {
        self.id = id
        self.options = options
       
    }
}
