//
//  GameTabs.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//

import SwiftUI

struct GameTabs: View {
    @Binding var selected: QuestionGame
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 10) {
            ForEach(QuestionGame.allCases) { game in
                Button {
                    selected = game
                } label: {
                    Text(game.title)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(selected == game ? Color.white : AppColors.textPrimary(for: scheme))
                        .background(
                            Capsule()
                                .fill(selected == game ? AppColors.brandPrimary : AppColors.backgroundSecondary(for: scheme).opacity(0.55))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}
