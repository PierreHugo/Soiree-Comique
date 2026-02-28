//
//  SettingsView.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject private var themeManager: ThemeManager
    
    private var appVersionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
        return "Version \(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            VStack {
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

                Spacer()

                VStack(spacing: 4) {
                    Text("Made by @pierrehugo ❤️")
                    Text(appVersionString)
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)
            }
            .navigationTitle("Réglages")
        }
    }
}
