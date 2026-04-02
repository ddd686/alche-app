import SwiftUI

// MARK: - Tag Variant

enum AlcheTagVariant {
    /// 1px border, transparent background (default)
    case outline
    /// Filled background, contrasting text
    case filled
    /// Status indicator — small dot + label
    case status
}

// MARK: - Tag Component

struct AlcheTag: View {
    let text: String
    var color: Color = .alchePrimary
    var variant: AlcheTagVariant = .outline
    var isSelected: Bool = false

    var body: some View {
        switch variant {
        case .outline:
            outlineTag
        case .filled:
            filledTag
        case .status:
            statusTag
        }
    }

    // MARK: - Outline Variant

    private var outlineTag: some View {
        Text(text.uppercased())
            .font(.alcheMono)
            .tracking(0.8)
            .padding(.horizontal, AlcheSpacing.sm)
            .padding(.vertical, AlcheSpacing.xs)
            .foregroundStyle(isSelected ? Color.alcheWhite : color)
            .background(isSelected ? color : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.sm)
                    .stroke(color.opacity(isSelected ? 0 : 1), lineWidth: 1)
            )
    }

    // MARK: - Filled Variant

    private var filledTag: some View {
        Text(text.uppercased())
            .font(.alcheMono)
            .tracking(0.8)
            .padding(.horizontal, AlcheSpacing.sm)
            .padding(.vertical, AlcheSpacing.xs)
            .foregroundStyle(Color.alcheWhite)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }

    // MARK: - Status Variant

    private var statusTag: some View {
        HStack(spacing: AlcheSpacing.xs) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)

            Text(text.uppercased())
                .font(.alcheMono)
                .tracking(0.8)
        }
        .padding(.horizontal, AlcheSpacing.sm)
        .padding(.vertical, AlcheSpacing.xs)
        .foregroundStyle(Color.alcheEditorialMuted)
        .background(Color.alcheWarmGray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }
}

// MARK: - Preview

#Preview("Tags") {
    VStack(spacing: AlcheSpacing.lg) {
        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("OUTLINE")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            HStack(spacing: AlcheSpacing.sm) {
                AlcheTag(text: "Recovery", variant: .outline)
                AlcheTag(text: "Glow", color: .alcheEditorialAccent, variant: .outline)
                AlcheTag(text: "Energy", color: .alchePastelSage, variant: .outline)
                AlcheTag(text: "Sleep", color: .alcheInfo, variant: .outline)
            }
        }

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("OUTLINE SELECTED")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            HStack(spacing: AlcheSpacing.sm) {
                AlcheTag(text: "Recovery", variant: .outline, isSelected: true)
                AlcheTag(text: "Glow", color: .alcheEditorialAccent, variant: .outline, isSelected: true)
            }
        }

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("FILLED")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            HStack(spacing: AlcheSpacing.sm) {
                AlcheTag(text: "Active", color: .alchePrimary, variant: .filled)
                AlcheTag(text: "Complete", color: .alcheSuccess, variant: .filled)
            }
        }

        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("STATUS")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheEditorialMuted)
            HStack(spacing: AlcheSpacing.sm) {
                AlcheTag(text: "Online", color: .alcheSuccess, variant: .status)
                AlcheTag(text: "Pending", color: .alcheWarning, variant: .status)
            }
        }
    }
    .padding(AlcheSpacing.lg)
    .background(Color.alcheBackground)
}
