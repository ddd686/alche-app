import SwiftUI

struct ContentCardView: View {
    let content: Content
    var isBookmarked: Bool = false
    var onToggleBookmark: (() -> Void)?

    var body: some View {
        AlcheCard {
            VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                // Hero placeholder
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: AlcheRadii.sm)
                        .fill(contentGradient)
                        .frame(height: 140)
                        .overlay(
                            Image(systemName: contentIcon)
                                .font(.alcheDisplayXL)
                                .foregroundStyle(.white.opacity(0.5))
                        )

                    if onToggleBookmark != nil {
                        Button {
                            onToggleBookmark?()
                        } label: {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.alcheBody)
                                .foregroundStyle(isBookmarked ? Color.alchePrimary : .white.opacity(0.8))
                                .padding(AlcheSpacing.sm)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(AlcheSpacing.sm)
                    }
                }

                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    // Type + reading time
                    HStack(spacing: AlcheSpacing.sm) {
                        if let type = content.contentType {
                            AlcheTag(
                                text: type.displayName,
                                color: type == .review ? .alchePrimary : .alcheEditorialMuted
                            )
                        }

                        Spacer()

                        if let minutes = content.readingTimeMinutes {
                            HStack(spacing: AlcheSpacing.xs) {
                                Image(systemName: "clock")
                                    .font(.alcheOverline)
                                Text("\(minutes) min")
                                    .font(.alcheCaption)
                            }
                            .foregroundStyle(Color.alcheSecondaryText)
                        }
                    }

                    Text(content.title)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)
                        .lineLimit(2)

                    if let body = content.body {
                        Text(body)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .lineLimit(2)
                    }

                    // Tags
                    if !content.tags.isEmpty {
                        HStack(spacing: AlcheSpacing.xs) {
                            ForEach(content.tags.prefix(3), id: \.self) { tag in
                                Text(tag)
                                    .font(.alcheOverline)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.alcheWarmGray.opacity(0.5))
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    // Tier lock
                    if let tier = content.tierRequired, tier != .free {
                        HStack(spacing: AlcheSpacing.xs) {
                            Image(systemName: "lock")
                                .font(.alcheOverline)
                            Text("\(tier.displayName) members")
                                .font(.alcheCaption)
                        }
                        .foregroundStyle(Color.alcheAmber)
                    }
                }
            }
        }
    }

    private var contentGradient: LinearGradient {
        let baseColor: Color = switch content.contentType {
        case .review: .alchePrimary
        case .video: .alcheInfo
        default: .alcheSage
        }
        return LinearGradient(
            colors: [baseColor.opacity(0.3), baseColor.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var contentIcon: String {
        switch content.contentType {
        case .review: "checkmark.seal"
        case .video: "play.circle"
        default: "doc.text"
        }
    }
}

#Preview {
    ContentCardView(content: .preview)
        .padding()
        .background(Color.alcheBackground)
}
