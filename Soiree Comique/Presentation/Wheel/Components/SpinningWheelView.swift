//
//  SpinningWheelView.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import SwiftUI

struct SpinningWheelView: View {

    let title: String
    let options: [WheelOption]
    let rotation: Double // en degrés

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let radius = size / 2

            ZStack {
                // roue
                ZStack {
                    ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                        let start = startAngleDeg(for: index)
                        let end   = endAngleDeg(for: index)
                        let mid   = (start + end) / 2.0

                        WheelSlice(startAngle: .degrees(start), endAngle: .degrees(end))
                            .fill(colorForSlice(index).opacity(scheme == .dark ? 0.95 : 0.9))
                            .overlay(
                                WheelSlice(startAngle: .degrees(start), endAngle: .degrees(end))
                                    .stroke(Color.black.opacity(scheme == .dark ? 0.55 : 0.15), lineWidth: 2)
                            )

                        // Label
                        Text(option.title)
                            .font(.system(size: labelFontSize(for: options.count), weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .shadow(radius: 2)
                            // position dans la slice
                            .offset(y: -radius * 0.8)
                            .rotationEffect(.degrees(mid))  // <- positionnement
                            // légère orientation tangentielle pour qu'on sente "dans la part"
                            .rotationEffect(.degrees(90))
                            .allowsHitTesting(false)
                            .zIndex(10)
                    }

                    // centre
                    Circle()
                        .fill(AppColors.backgroundPrimary(for: scheme))
                        .frame(width: radius * 0.22, height: radius * 0.22)
                        .overlay(
                            Circle()
                                .stroke(AppColors.brandPrimary, lineWidth: 3)
                        )
                        .shadow(radius: 6)
                }
                .frame(width: size, height: size)
                .rotationEffect(.degrees(rotation))

                // flèche
                Triangle()
                    .fill(AppColors.textPrimary(for: scheme))
                    .frame(width: radius * 0.14, height: radius * 0.14)
                    .rotationEffect(.degrees(180))
                    .offset(y: -(radius + radius * 0.05))
                    .shadow(color: Color.black.opacity(scheme == .dark ? 0.6 : 0.2),
                            radius: 8,
                            x: 0,
                            y: 3)
                    .zIndex(50)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    // MARK: - Angles
    
    private func stepDeg() -> Double {
        360.0 / Double(max(options.count, 1))
    }

    private func baseStartDeg() -> Double {
        // Centre de la slice 0 à -90° (midi)
        -90.0 - stepDeg() / 2.0
    }

    private func startAngleDeg(for index: Int) -> Double {
        baseStartDeg() + stepDeg() * Double(index)
    }

    private func endAngleDeg(for index: Int) -> Double {
        startAngleDeg(for: index) + stepDeg()
    }

    // MARK: - Label positioning

    private func labelFontSize(for count: Int) -> CGFloat {
        switch count {
        case 0...3: return 20
        case 4...6: return 16
        case 7...10: return 12
        default: return 10
        }
    }

    // MARK: - Colors

    private func colorForSlice(_ index: Int) -> Color {
        // On recycle une palette cohérente (tu peux aussi créer AppColors.wheelColors)
        let palette = AppColors.chooserPlayerColors
        return palette[index % palette.count]
    }
}

// MARK: - Shapes

private struct WheelSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var p = Path()
        p.move(to: center)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: false)
        p.closeSubpath()
        return p
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
