//
//  WheelCardView.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import SwiftUI
import UIKit

struct WheelCardView: View {

    let title: String
    let options: [WheelOption]
    let onEdit: () -> Void

    @Environment(\.colorScheme) private var scheme

    @State private var rotation: Double = 0
    @State private var isSpinning: Bool = false
    @State private var resultText: String? = nil

    // Tuning (tu pourras ajuster)
    private let spinDuration: TimeInterval = 2.6

    var body: some View {
        VStack(spacing: 14) {

            ZStack {
                // Titre centré
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary(for: scheme))

                // Bouton crayon à droite
                HStack {
                    Spacer()

                    Button(action: onEdit) {
                        Text("✏️")
                            .font(.system(size: 20))
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(AppColors.backgroundSecondary(for: scheme))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 6)

            if let resultText {
                Text("Résultat : \(resultText)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppColors.brandPrimary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                Text(" ")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.clear)
            }

            // ✅ Vraie roue
            SpinningWheelView(title: title, options: options, rotation: rotation)
                .frame(height: 260)
                .padding(.vertical, 6)
                .allowsHitTesting(false)

            Button(action: spin) {
                HStack(spacing: 10) {
                    Text(isSpinning ? "..." : "Tourner !")
                }
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppColors.brandPrimary)
            .disabled(isSpinning || options.count < 2)

        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(AppColors.backgroundSecondary(for: scheme).opacity(0.55))
        )
    }

    // MARK: - Spin logic (uniforme)

    private func spin() {
        guard !isSpinning else { return }
            guard options.count >= 2 else { return }

            isSpinning = true
            withAnimation(.easeOut(duration: 0.2)) { resultText = nil }

            let startImpact = UIImpactFeedbackGenerator(style: .light)
            startImpact.prepare()
            startImpact.impactOccurred()

            let extraTurns = Double(Int.random(in: 4...7)) * 360.0
            let stopAngle = Double.random(in: 0..<360.0)
            let target = rotation + extraTurns + stopAngle

            withAnimation(.timingCurve(0.10, 0.85, 0.20, 1.0, duration: spinDuration)) {
                rotation = target
            }

        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration + 0.05) {
            let n = options.count
            let step = 360.0 / Double(n)

            // On calcule sur la rotation FINALE visuelle (= target), pas sur rotation (state) pendant animation
            let r = positiveMod(target, 360.0)

            // Même base que SpinningWheelView (centre de slice 0 à midi)
            let baseStart = -90.0 - step / 2.0

            // Angle sous la flèche, dans le repère de la roue AVANT rotation
            // rotationEffect(.degrees(r)) = rotation CCW => angle source = pointer - r
            let pointerAngle = -90.0
            let angleUnderPointer = pointerAngle - r

            let rel = positiveMod(angleUnderPointer - baseStart, 360.0)
            let index = min(Int(rel / step), n - 1)

            // Haptics fin
            let heavy = UIImpactFeedbackGenerator(style: .heavy)
            heavy.prepare()
            heavy.impactOccurred()

            let notif = UINotificationFeedbackGenerator()
            notif.prepare()
            notif.notificationOccurred(.success)

            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                resultText = options[index].title
            }

            isSpinning = false   // ✅ CRITIQUE : sinon tu ne peux plus relancer
        }
    }

    private func positiveMod(_ x: Double, _ m: Double) -> Double {
        let r = x.truncatingRemainder(dividingBy: m)
        return r < 0 ? r + m : r
    }
}
