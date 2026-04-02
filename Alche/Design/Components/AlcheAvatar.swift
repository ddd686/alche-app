import SwiftUI

// MARK: - Avatar Component

struct AlcheAvatar: View {
    var imageURL: URL? = nil
    var initials: String = ""
    var size: CGFloat = 40
    var isFoundingMember: Bool = false

    var body: some View {
        ZStack {
            if let imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    initialsView
                }
            } else {
                initialsView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(
                    isFoundingMember ? Color.alchePrimary : Color.clear,
                    lineWidth: isFoundingMember ? 2 : 0
                )
        )
    }

    private var initialsView: some View {
        ZStack {
            Color.alcheWarmGray
            Text(initials.prefix(2).uppercased())
                .font(.system(size: size * 0.35, weight: .medium))
                .foregroundStyle(Color.alcheEditorialBlack)
        }
    }
}

// MARK: - Preview

#Preview("Avatars") {
    HStack(spacing: AlcheSpacing.md) {
        AlcheAvatar(initials: "LK", size: 40)
        AlcheAvatar(initials: "TM", size: 56, isFoundingMember: true)
        AlcheAvatar(initials: "AJ", size: 72)
    }
    .padding(AlcheSpacing.lg)
    .background(Color.alcheBackground)
}
