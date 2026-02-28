//
//  ChooserView.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import SwiftUI
import UIKit
import Combine

struct ChooserView: View {

    @Environment(\.colorScheme) private var colorScheme
    
    @State private var touches: [TouchPoint] = []
    @State private var selectedId: Int? = nil
    @State private var isLocked: Bool = false

    @State private var lastCountChangeAt: Date = .now
    @State private var lastCount: Int = 0
    
    @State private var flashOpacity: Double = 0
    
    @State private var colorByTouchId: [Int: Int] = [:]   // touchId -> index couleur

    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var lastNoTouchAt: Date = .now // pour display le hint
    @State private var showHint: Bool = false

    private let hintDelay: TimeInterval = 1.2
    private let maxTouches = 5
    private let minTouchesToStart = 2
    private let stableDelay: TimeInterval = 3.0
    private let resetDelay: TimeInterval = 4.0
    private let circleSize: CGFloat = 90
    
    var body: some View {
        ZStack {
            
            AppColors.backgroundPrimary(for: colorScheme).ignoresSafeArea()
            
            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()

            MultiTouchSurface { incoming in

                // ✅ Si un winner est affiché : on suit uniquement SON doigt
                if isLocked, let winnerId = selectedId {
                    if let winnerTouch = incoming.first(where: { $0.id == winnerId }) {
                        // mettre à jour la position du cercle winner
                        touches = [winnerTouch]
                    }
                    return
                }

                // --- mode normal (pas locked) ---
                let limited = Array(incoming.prefix(maxTouches))
                touches = limited

                assignColorsIfNeeded(for: touches)

                if !touches.isEmpty {
                    showHint = false
                }

                if touches.count != lastCount {
                    lastCount = touches.count
                    lastCountChangeAt = Date()
                }

                if touches.isEmpty {
                    selectedId = nil
                    isLocked = false
                    lastCount = 0
                    lastCountChangeAt = Date()
                    lastNoTouchAt = Date()
                    colorByTouchId = [:]
                }
            }
            .ignoresSafeArea()
            
            if showHint {
                Text("À vos doigts !")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppColors.textSecondary(for: colorScheme))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .clipShape(Capsule())
                    .transition(.opacity.combined(with: .scale))
            }

            // Cercles
            ForEach(touches) { tp in
                circleView(for: tp)
                    .position(tp.location)
                    .animation(.easeOut(duration: 0.08), value: tp.location)
            }
        }
        .navigationTitle("Chooser")
        .onReceive(timer) { _ in
            checkStabilityAndChooseIfNeeded()
            updateHintVisibility()
        }
    }

    @ViewBuilder
    private func circleView(for tp: TouchPoint) -> some View {

        let baseColor = color(for: tp.id)
        let isWinner = (tp.id == selectedId)

        Circle()
            .fill(baseColor.opacity(isWinner ? 0.45 : 0.28))
            .overlay(
                Circle()
                    .stroke(baseColor.opacity(0.9), lineWidth: isWinner ? 6 : 3)
            )
            .frame(width: circleSize, height: circleSize)
            .scaleEffect(isWinner ? 1.25 : 1.0)
            .shadow(color: baseColor.opacity(isWinner ? 0.8 : 0.4),
                    radius: isWinner ? 30 : 10)
            .overlay(
                Circle()
                    .stroke(baseColor.opacity(isWinner ? 0.7 : 0),
                            lineWidth: 2)
                    .scaleEffect(isWinner ? 1.8 : 1.0)
                    .overlay(
                        Circle()
                            .stroke(baseColor.opacity(isWinner ? 0.7 : 0.0), lineWidth: 2)
                            .scaleEffect(isWinner ? 1.8 : 1.0)
                            .opacity(isWinner ? 0.0 : 0.0)
                    )
                    .animation(
                        isWinner ?
                        .easeOut(duration: 0.8).repeatForever(autoreverses: false)
                        : .default,
                        value: selectedId
                    )
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.6),
                       value: isWinner)
    }
    
    private func assignColorsIfNeeded(for currentTouches: [TouchPoint]) {
        let activeIds = Set(currentTouches.map(\.id))

        // 1) nettoyer les couleurs des doigts retirés
        colorByTouchId = colorByTouchId.filter { activeIds.contains($0.key) }

        // 2) quelles couleurs sont déjà prises ?
        let used = Set(colorByTouchId.values)

        // 3) pool de couleurs libres (dans l’ordre)
        var available = Array(0..<AppColors.chooserPlayerColors.count).filter { !used.contains($0) }

        // 4) attribuer une couleur aux nouveaux doigts (ordre stable)
        for id in activeIds.sorted() {
            if colorByTouchId[id] == nil {
                if available.isEmpty {
                    // si jamais (normalement non, vu maxTouches == nb couleurs)
                    colorByTouchId[id] = id % AppColors.chooserPlayerColors.count
                } else {
                    colorByTouchId[id] = available.removeFirst()
                }
            }
        }
    }

    private func color(for touchId: Int) -> Color {
        let idx = colorByTouchId[touchId] ?? 0
        return AppColors.chooserPlayerColors[idx]
    }
    
    private func updateHintVisibility() {
        // pas de hint pendant un round/winner
        guard !isLocked, selectedId == nil else {
            if showHint { withAnimation(.easeOut(duration: 0.15)) { showHint = false } }
            return
        }

        if touches.isEmpty {
            let now = Date()
            let shouldShow = now.timeIntervalSince(lastNoTouchAt) >= hintDelay
            if shouldShow != showHint {
                withAnimation(.easeOut(duration: 0.2)) {
                    showHint = shouldShow
                }
            }
        } else {
            if showHint {
                withAnimation(.easeOut(duration: 0.15)) {
                    showHint = false
                }
            }
        }
    }

    private func checkStabilityAndChooseIfNeeded() {
        guard !isLocked else { return }
        guard selectedId == nil else { return }

        let count = touches.count
        guard count >= minTouchesToStart && count <= maxTouches else { return }

        let now = Date()
        let isCountStable = now.timeIntervalSince(lastCountChangeAt) >= stableDelay
        guard isCountStable else { return }

        // Choix
        isLocked = true
        let winner = touches.randomElement()!
        let winnerId = winner.id

        // Haptics (prépare + déclenche)
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.prepare()
        impact.impactOccurred()

        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        notification.notificationOccurred(.success)

        // FLASH
        withAnimation(.easeOut(duration: 0.12)) {
            flashOpacity = 0.22
        }
        withAnimation(.easeOut(duration: 0.35).delay(0.12)) {
            flashOpacity = 0
        }

        // ✅ APPLIQUER LE WINNER (manquait)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            selectedId = winnerId
            touches = touches.filter { $0.id == winnerId }
        }

        // Reset automatique après quelques secondes
        DispatchQueue.main.asyncAfter(deadline: .now() + resetDelay) {
            withAnimation(.easeOut(duration: 0.25)) {
                selectedId = nil
                touches = []
                isLocked = false
                lastCount = 0
                lastCountChangeAt = Date()
            }
        }
    }
}
