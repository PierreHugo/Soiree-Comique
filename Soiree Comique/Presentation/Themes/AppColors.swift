//
//  AppColors.swift
//  Soiree Comique
//
//  Created by Pierre-Hugo Herran on 28/02/2026.
//


import SwiftUI

enum AppColors {

    // MARK: - Backgrounds (Dark)
    private static let bgPrimaryDark = Color(hex: "#0F0F14")
    private static let bgSecondaryDark = Color(hex: "#1A1A22")

    // MARK: - Backgrounds (Light)
    private static let bgPrimaryLight = Color(hex: "#F6F6FA")
    private static let bgSecondaryLight = Color(hex: "#FFFFFF")

    // MARK: - Text (Dark)
    private static let textPrimaryDark = Color.white
    private static let textSecondaryDark = Color.white.opacity(0.70)

    // MARK: - Text (Light)
    private static let textPrimaryLight = Color(hex: "#0F0F14")
    private static let textSecondaryLight = Color(hex: "#0F0F14").opacity(0.65)

    // MARK: - Brand
    static let brandPrimary = Color(hex: "#D633FF")
    static let brandSecondary = Color(hex: "#9B5CFF")

    // MARK: - Chooser Player Colors
    static let chooserPlayerColors: [Color] = [
        Color(hex: "#D633FF"),
        Color(hex: "#9B5CFF"),
        Color(hex: "#FFD166"),
        Color(hex: "#4CC9F0"),
        Color(hex: "#F72585"),
    ]

    // MARK: - Public Themed API
    static func backgroundPrimary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? bgPrimaryDark : bgPrimaryLight
    }

    static func backgroundSecondary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? bgSecondaryDark : bgSecondaryLight
    }

    static func textPrimary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? textPrimaryDark : textPrimaryLight
    }

    static func textSecondary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? textSecondaryDark : textSecondaryLight
    }
}
