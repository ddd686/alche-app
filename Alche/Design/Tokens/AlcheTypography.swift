import SwiftUI

// MARK: - Font Names

private enum AlcheFontName {
    // Display — Newsreader Italic family (serifs, editorial feel)
    static let displayExtraLight = "Newsreader-ExtraLightItalic"
    static let displayLight = "Newsreader-LightItalic"
    static let displayRegular = "Newsreader-Italic"
    static let displayMedium = "Newsreader-MediumItalic"
    static let displaySemiBold = "Newsreader-SemiBoldItalic"
    static let displayBold = "Newsreader-BoldItalic"

    // Heading + Body — Noto Sans family (clean, readable)
    static let heading = "NotoSans-Bold"
    static let body = "NotoSans-Regular"
    static let bodyMedium = "NotoSans-Medium"
    static let bodyBold = "NotoSans-Bold"

    // Mono — Space Mono (technical, editorial grid feel)
    static let mono = "SpaceMono-Regular"
    static let monoBold = "SpaceMono-Bold"
}

// MARK: - Type Scale

extension Font {
    /// 60pt Newsreader ExtraLight Italic — hero text, splash, brand moments
    static let alcheDisplayHero = customOrSystem(AlcheFontName.displayExtraLight, size: 60, fallback: .largeTitle)

    /// 48pt Newsreader Light Italic — large display headings
    static let alcheDisplayXL = customOrSystem(AlcheFontName.displayLight, size: 48, fallback: .largeTitle)

    /// 34pt Newsreader Regular Italic — section heroes
    static let alcheDisplayL = customOrSystem(AlcheFontName.displayRegular, size: 34, fallback: .title)

    /// 28pt Newsreader Medium Italic — feature headings
    static let alcheDisplayM = customOrSystem(AlcheFontName.displayMedium, size: 28, fallback: .title)

    /// 22pt Newsreader SemiBold Italic — card display titles
    static let alcheDisplayS = customOrSystem(AlcheFontName.displaySemiBold, size: 22, fallback: .title2)

    /// 20pt Noto Sans Bold — screen titles
    static let alcheHeading = customOrSystem(AlcheFontName.heading, size: 20, fallback: .title2)

    /// 17pt Noto Sans Medium — card headers, nav items
    static let alcheSubheading = customOrSystem(AlcheFontName.bodyMedium, size: 17, fallback: .headline)

    /// 15pt Noto Sans Regular — body text
    static let alcheBody = customOrSystem(AlcheFontName.body, size: 15, fallback: .body)

    /// 15pt Noto Sans Medium — emphasized body text
    static let alcheBodyMedium = customOrSystem(AlcheFontName.bodyMedium, size: 15, fallback: .body)

    /// 15pt Noto Sans Bold — strong body text
    static let alcheBodyBold = customOrSystem(AlcheFontName.bodyBold, size: 15, fallback: .body)

    /// 13pt Noto Sans Regular — secondary info
    static let alcheCaption = customOrSystem(AlcheFontName.body, size: 13, fallback: .caption)

    /// 10pt Space Mono Regular, uppercase — labels, tags, overlines
    static let alcheOverline = customOrSystem(AlcheFontName.mono, size: 10, fallback: .caption2)

    /// 9pt Space Mono Regular — tiny overlines, timestamps
    static let alcheOverlineTiny = customOrSystem(AlcheFontName.mono, size: 9, fallback: .caption2)

    /// 10pt Space Mono Bold — bold labels, data tags
    static let alcheMonoBold = customOrSystem(AlcheFontName.monoBold, size: 10, fallback: .caption2)

    /// 13pt Space Mono Regular — data, numbers, codes
    static let alcheMono = customOrSystem(AlcheFontName.mono, size: 13, fallback: .body.monospaced())

    /// 48pt Space Mono Regular — hero numbers (e.g., biological age)
    static let alcheMonoLarge = customOrSystem(AlcheFontName.mono, size: 48, fallback: .system(size: 48, weight: .regular, design: .monospaced))

    /// 36pt Newsreader Light Italic — featured data values, scores
    static let alcheDataValue = customOrSystem(AlcheFontName.displayLight, size: 36, fallback: .title)
}

// MARK: - Short Aliases

extension Font {
    static let displayHero = alcheDisplayHero
    static let displayXL = alcheDisplayXL
    static let displayL = alcheDisplayL
    static let displayM = alcheDisplayM
    static let displayS = alcheDisplayS
    static let heading = alcheHeading
    static let subheading = alcheSubheading
    static let overline = alcheOverline
}

// MARK: - Helper

extension Font {
    /// Attempts to use a custom font, falls back to system if not available.
    /// Custom fonts require .ttf/.otf files added to the project and registered in Info.plist.
    static func customOrSystem(_ name: String, size: CGFloat, fallback: Font) -> Font {
        .custom(name, size: size, relativeTo: textStyleForSize(size))
    }

    private static func textStyleForSize(_ size: CGFloat) -> Font.TextStyle {
        switch size {
        case 48...: return .largeTitle
        case 34..<48: return .largeTitle
        case 28..<34: return .title
        case 22..<28: return .title2
        case 17..<22: return .headline
        case 15..<17: return .body
        case 13..<15: return .footnote
        default: return .caption
        }
    }
}

// MARK: - Preview

#Preview("Typography Scale") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Text("Display Hero (60pt)")
                .font(.alcheDisplayHero)
            Text("Display XL (48pt)")
                .font(.alcheDisplayXL)
            Text("Display L (34pt)")
                .font(.alcheDisplayL)
            Text("Display M (28pt)")
                .font(.alcheDisplayM)
            Text("Display S (22pt)")
                .font(.alcheDisplayS)
            Text("Heading (20pt)")
                .font(.alcheHeading)
            Text("Subheading (17pt)")
                .font(.alcheSubheading)
            Text("Body (15pt)")
                .font(.alcheBody)
            Text("Body Medium (15pt)")
                .font(.alcheBodyMedium)
            Text("Body Bold (15pt)")
                .font(.alcheBodyBold)
            Text("Caption (13pt)")
                .font(.alcheCaption)
            Text("OVERLINE (10PT)")
                .font(.alcheOverline)
            Text("OVERLINE TINY (9PT)")
                .font(.alcheOverlineTiny)
            Text("MONO BOLD (10PT)")
                .font(.alcheMonoBold)
            Text("Mono 1234567890")
                .font(.alcheMono)
            Text("48")
                .font(.alcheMonoLarge)
            Text("36")
                .font(.alcheDataValue)
        }
        .padding()
    }
}
