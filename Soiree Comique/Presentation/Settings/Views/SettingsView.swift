//
//  SettingsView.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            Form {
                Section("Apparence") {
                    Picker("Thème", selection: Binding(
                        get: { themeManager.theme },
                        set: { themeManager.setTheme($0) }
                    )) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Réglages")
        }
    }
}
