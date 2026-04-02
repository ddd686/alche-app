import SwiftUI

struct SkinCategoryCard: View {
    let category: GlowCategory

    var body: some View {
        AlcheCard {
            HStack(spacing: AlcheSpacing.md) {
                // Score circle
                ZStack {
                    Circle()
                        .stroke(Color.alcheWarmGray, lineWidth: 4)
                        .frame(width: 56, height: 56)

                    Circle()
                        .trim(from: 0, to: CGFloat(category.score) / 100)
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 56, height: 56)
                        .rotationEffect(.degrees(-90))

                    Text("\(category.score)")
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alchePrimaryText)
                }

                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(category.name)
                        .font(.alcheSubheading)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Text(category.status)
                        .font(.alcheCaption)
                        .foregroundStyle(statusColor)

                    Text(category.description)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .lineLimit(2)
                }

                Spacer()
            }
        }
    }

    private var scoreColor: Color {
        switch category.score {
        case 80...100: .alcheSage
        case 65..<80: .alcheAmber
        case 50..<65: .alchePrimary
        default: .alcheError
        }
    }

    private var statusColor: Color {
        switch category.score {
        case 80...100: .alcheSage
        case 65..<80: .alcheAmber
        default: .alchePrimary
        }
    }
}

#Preview {
    VStack(spacing: AlcheSpacing.md) {
        SkinCategoryCard(category: GlowCategory(name: "Hydration", score: 72, description: "How well-hydrated your skin looks"))
        SkinCategoryCard(category: GlowCategory(name: "Radiance", score: 85, description: "Your skin's natural luminosity"))
        SkinCategoryCard(category: GlowCategory(name: "Under-Eye", score: 58, description: "Under-eye area appearance"))
    }
    .padding()
    .background(Color.alcheBackground)
}
