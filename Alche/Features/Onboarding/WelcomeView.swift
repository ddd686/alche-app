import SwiftUI

struct WelcomeView: View {
    var onBegin: () -> Void = {}
    var onSignIn: () -> Void = {}

    var body: some View {
        ZStack {
            Color.alcheBackground
                .ignoresSafeArea()

            // Right-side surface panel (editorial depth)
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Spacer()
                    Color.alcheSurface.opacity(0.4)
                        .frame(width: geo.size.width * 0.3)
                }
            }
            .ignoresSafeArea()

            // Main content
            VStack(alignment: .leading, spacing: 0) {
                // Overline
                Text("WELCOME TO ALCHE")
                    .font(.alcheOverline)
                    .tracking(3)
                    .foregroundStyle(Color.alcheSecondaryText)

                Spacer()

                // Hero headline
                Text("Your\nlongevity,\ncurated.")
                    .font(.alcheDisplayXL)
                    .foregroundStyle(Color.alchePrimaryText)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)

                // Divider accent
                Rectangle()
                    .fill(Color.alchePrimary)
                    .frame(width: 64, height: 1)
                    .padding(.top, AlcheSpacing.lg)

                // Subtitle
                Text("The operating system for living longer.\nTreatments. Nutrition. Science. Community.")
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, AlcheSpacing.lg)

                // Decorative grid
                HStack(spacing: 1) {
                    Rectangle()
                        .fill(Color.alchePrimaryText.opacity(0.10))
                    Rectangle()
                        .fill(Color.alchePrimaryText.opacity(0.05))
                    Rectangle()
                        .fill(Color.alchePrimaryText.opacity(0.02))
                }
                .frame(height: 80)
                .padding(.top, AlcheSpacing.xl)

                Spacer()

                // CTA section
                VStack(spacing: AlcheSpacing.md) {
                    // BEGIN button — filled primary
                    Button(action: onBegin) {
                        Text("BEGIN")
                            .font(.alcheOverline)
                            .tracking(2.5)
                            .foregroundStyle(Color.alcheWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.alchePrimary)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                            .alcheShadow(.medium)
                    }
                    .buttonStyle(.plain)

                    // Sign in link
                    Button(action: onSignIn) {
                        HStack(spacing: 4) {
                            Text("Already a member?")
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)

                            Text("Sign in")
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimaryText)
                                .underline(color: Color.alcheEditorialAccent)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                }

                // Footer
                HStack {
                    Text("V.1.04 \u{2014} PRIVATE RELEASE")
                        .font(.alcheOverlineTiny)
                        .foregroundStyle(Color.alcheSecondaryText.opacity(0.6))
                        .tracking(2)

                    Spacer()

                    Image(systemName: "lock")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.alcheSecondaryText.opacity(0.6))
                }
                .padding(.top, AlcheSpacing.lg)
                .padding(.bottom, AlcheSpacing.sm)
            }
            .padding(.horizontal, AlcheSpacing.xl)
            .padding(.top, AlcheSpacing.xxl)
        }
    }
}

// MARK: - Preview

#Preview {
    WelcomeView(
        onBegin: {},
        onSignIn: {}
    )
}
