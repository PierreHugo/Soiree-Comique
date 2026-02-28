//
//  QuestionsView.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import SwiftUI

struct QuestionsView: View {

    @StateObject private var vm = QuestionsViewModel()
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundPrimary(for: scheme).ignoresSafeArea()

                VStack(spacing: 16) {
                    
                    GameTabs(selected: $vm.selectedGame)

                    promptCard
                        .padding(.vertical, 32)
                    
                    Spacer()

                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.prepare()
                        impact.impactOccurred()

                        vm.draw()
                    } label: {
                        Text("Suivant")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppColors.brandPrimary)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                }
            }
            .navigationTitle("Questions")
            .onAppear { vm.load() }
            .onChange(of: vm.selectedGame) { _, _ in
                vm.draw()
            }
        }
    }
    
    private func sipCount(for difficulty: Int) -> Int {
        switch difficulty {
        case 1: return Int.random(in: 1...3)
        case 2: return Int.random(in: 4...5)
        case 3: return Int.random(in: 6...7)
        case 4: return Int.random(in: 8...10)
        default: return Int.random(in: 4...5)
        }
    }

    private func sipColor(for difficulty: Int) -> Color {
        let c = AppColors.chooserPlayerColors
        switch difficulty {
        case 1: return c[safe: 3] ?? .white
        case 2: return c[safe: 2] ?? .white
        case 3: return c[safe: 4] ?? .white
        case 4: return c[safe: 1] ?? .white
        default: return c.first ?? .white
        }
    }

    private func cardBackground() -> Color {
        AppColors.backgroundSecondary(for: scheme).opacity(0.55)
    }

    @ViewBuilder
    private var promptCard: some View {
        if let error = vm.errorMessage {
            Text(error)
                .foregroundStyle(.red)
                .padding()
        } else {
            let text = vm.current?.text ?? "…"

            if vm.selectedGame == .actionOuShot {
                let difficulty = vm.current?.difficulty ?? 2
                let sips = sipCount(for: difficulty)

                VStack(spacing: 14) {
                    // ACTION
                    VStack(spacing: 8) {
                        Text("Action")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppColors.textSecondary(for: scheme))

                        Text(text)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary(for: scheme))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(18)
                    .background(RoundedRectangle(cornerRadius: 26).fill(cardBackground()))

                    // OU
                    Text("OU")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundStyle(AppColors.textSecondary(for: scheme))
                        .padding(.vertical, 2)

                    // SHOT (gorgées)
                    VStack(spacing: 8) {
    
                        Text("\(sips)")
                            .font(.system(size: 75, weight: .heavy, design: .rounded))
                            .foregroundStyle(sipColor(for: sips))

                        Text("gorgées")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary(for: scheme).opacity(0.9))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(18)
                    .background(RoundedRectangle(cornerRadius: 26).fill(cardBackground()))
                }
                .padding(.horizontal)

            } else {
                // Pointe du doigt / Je n’ai jamais
                VStack(spacing: 10) {
                    Text(vm.selectedGame.title)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppColors.textSecondary(for: scheme))

                    Text(text)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.textPrimary(for: scheme))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(cardBackground())
                )
                .padding(.horizontal)
            }
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
