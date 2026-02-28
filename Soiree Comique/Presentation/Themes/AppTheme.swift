//
//  AppTheme.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//

import SwiftUI
import Combine

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case dark
    case light

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: return "Système"
        case .dark:   return "Sombre"
        case .light:  return "Clair"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .dark:   return .dark
        case .light:  return .light
        }
    }
}

@MainActor
final class ThemeManager: ObservableObject {

    @AppStorage("app_theme") private var storedThemeRaw: String = AppTheme.dark.rawValue

    /// Thème “source of truth” (persisté)
    var theme: AppTheme {
        get { AppTheme(rawValue: storedThemeRaw) ?? .dark }
        set {
            storedThemeRaw = newValue.rawValue
            objectWillChange.send() // <- notifie SwiftUI
        }
    }

    func setTheme(_ newTheme: AppTheme) {
        theme = newTheme
    }
}
