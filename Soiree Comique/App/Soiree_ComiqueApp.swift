//
//  Soiree_ComiqueApp.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//

import SwiftUI

@main
struct Soiree_ComiqueApp: App {

    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.theme.colorScheme)
                .tint(AppColors.brandPrimary)
        }
    }
}
