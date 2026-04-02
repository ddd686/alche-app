import SwiftUI
import UIKit

// MARK: - Hex Color Initializer

extension Color {
    init(hex: UInt32, opacity: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}

// MARK: - Brand Colors (Editorial Longevity)

extension Color {
    // Primary
    static let alcheEditorialBlack = Color(hex: 0x0D121B)
    static let alchePrimary = Color(hex: 0x001D3D)
    static let alcheEditorialMuted = Color(hex: 0x8D96A6)
    static let alcheEditorialAccent = Color(hex: 0xC4CAD6)

    // Neutrals
    static let alcheWhite = Color(hex: 0xFFFFFF)
    static let alcheLightGray = Color(hex: 0xFCFCFD)
    static let alcheWarmGray = Color(hex: 0xF6F6F8)
    static let alcheSurfaceDark = Color(hex: 0x1A1F2E)

    // Legacy aliases — map old names to new tokens
    static let alcheDeep = alcheEditorialBlack
    static let alcheTerra = alchePrimary
    static let alcheAmber = alcheEditorialAccent
    static let alcheSage = Color(hex: 0xA7F3D0) // mapped to pastel sage
    static let alcheStone = alcheEditorialMuted
    static let alcheCream = alcheLightGray
    static let alcheSand = alcheWarmGray
    static let alcheLinen = alcheWhite

    // Semantic
    static let alcheError = Color(hex: 0xEF4444)
    static let alcheWarning = Color(hex: 0xF59E0B)
    static let alcheSuccess = Color(hex: 0x10B981)
    static let alcheInfo = Color(hex: 0x3B82F6)

    // Pastels (data viz)
    static let alchePastelRose = Color(hex: 0xFDA4AF)
    static let alchePastelIndigo = Color(hex: 0xA5B4FC)
    static let alchePastelSage = Color(hex: 0xA7F3D0)
    static let alchePastelLemon = Color(hex: 0xFEF08A)

    // Special Palettes — Blueprint
    static let alcheBlueprintPrimary = Color(hex: 0x2D3436)
    static let alcheBlueprintGray = Color(hex: 0x636E72)
    static let alcheBlueprintBg = Color(hex: 0xF0F0ED)

    // Special Palettes — Beauty
    static let alcheBeautyPrimary = Color(hex: 0xD4B0AC)
    static let alcheBeautyBg = Color(hex: 0xFDFBF9)
    static let alcheBeautyText = Color(hex: 0x1A1A1A)
    static let alcheBeautyMuted = Color(hex: 0x9E9E9E)
    static let alcheBeautyDivider = Color(hex: 0x1A1A1A, opacity: 0.05)
    static let alcheBeautyFooterBg = Color(hex: 0xFBF9F7)
}

// MARK: - Adaptive Colors (Light/Dark)

extension Color {
    static let alcheBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex: 0x101622)
            : UIColor(hex: 0xFCFCFD)
    })

    static let alcheSurface = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex: 0x1A1F2E)
            : UIColor(hex: 0xFFFFFF)
    })

    static let alcheCardBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex: 0x1A1F2E)
            : UIColor(hex: 0xFFFFFF)
    })

    static let alchePrimaryText = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex: 0xF6F6F8)
            : UIColor(hex: 0x0D121B)
    })

    static let alcheSecondaryText = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(hex: 0x8D96A6)
            : UIColor(hex: 0x8D96A6)
    })

    /// Text on light cards — always editorial black, regardless of color scheme
    static let alcheCardText = Color(hex: 0x0D121B)
}

// MARK: - Shadow Colors

extension Color {
    static let alcheShadow = Color(hex: 0x0D121B)
}

// MARK: - Short Aliases

extension Color {
    static let deep = alcheEditorialBlack
    static let terra = alchePrimary
    static let amber = alcheEditorialAccent
    static let sage = alchePastelSage
    static let cream = alcheLightGray
    static let stone = alcheEditorialMuted
    static let sand = alcheWarmGray
    static let linen = alcheWhite
    static let info = alcheInfo
    static let success = alcheSuccess
    static let warning = alcheWarning
    static let error = alcheError
}

// MARK: - Preview

#Preview("Color Palette") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Text("Brand")
                .font(.headline)
            HStack(spacing: 8) {
                colorSwatch("Ed. Black", .alcheEditorialBlack)
                colorSwatch("Primary", .alchePrimary)
                colorSwatch("Muted", .alcheEditorialMuted)
                colorSwatch("Accent", .alcheEditorialAccent)
            }

            Text("Neutrals")
                .font(.headline)
            HStack(spacing: 8) {
                colorSwatch("White", .alcheWhite)
                colorSwatch("LightGray", .alcheLightGray)
                colorSwatch("WarmGray", .alcheWarmGray)
                colorSwatch("SurfDark", .alcheSurfaceDark)
            }

            Text("Semantic")
                .font(.headline)
            HStack(spacing: 8) {
                colorSwatch("Error", .alcheError)
                colorSwatch("Warning", .alcheWarning)
                colorSwatch("Success", .alcheSuccess)
                colorSwatch("Info", .alcheInfo)
            }

            Text("Pastels")
                .font(.headline)
            HStack(spacing: 8) {
                colorSwatch("Rose", .alchePastelRose)
                colorSwatch("Indigo", .alchePastelIndigo)
                colorSwatch("Sage", .alchePastelSage)
                colorSwatch("Lemon", .alchePastelLemon)
            }

            Text("Special -- Blueprint")
                .font(.headline)
            HStack(spacing: 8) {
                colorSwatch("BPrimary", .alcheBlueprintPrimary)
                colorSwatch("BGray", .alcheBlueprintGray)
                colorSwatch("BBg", .alcheBlueprintBg)
            }

            Text("Special -- Beauty")
                .font(.headline)
            HStack(spacing: 8) {
                colorSwatch("Beauty", .alcheBeautyPrimary)
            }

            Text("Adaptive")
                .font(.headline)
            HStack(spacing: 8) {
                colorSwatch("BG", .alcheBackground)
                colorSwatch("Surface", .alcheSurface)
                colorSwatch("Card", .alcheCardBackground)
            }
        }
        .padding()
    }
}

@ViewBuilder
private func colorSwatch(_ name: String, _ color: Color) -> some View {
    VStack(spacing: 4) {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 60, height: 60)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
        Text(name)
            .font(.caption2)
    }
}
