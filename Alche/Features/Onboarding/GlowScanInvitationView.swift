import SwiftUI

struct GlowScanInvitationView: View {
    @Environment(AppState.self) private var appState

    @State private var contentVisible = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: AlcheSpacing.xl) {
                // Icon
                Image(systemName: "faceid")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.alchePrimary)
                    .opacity(contentVisible ? 1 : 0)
                    .offset(y: contentVisible ? 0 : 10)

                // Headline + subhead
                VStack(spacing: AlcheSpacing.md) {
                    Text("See where your\nskin stands")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)
                        .multilineTextAlignment(.center)

                    Text("Take a 60-second GlowScan for skin-specific protocols.")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AlcheSpacing.xl)
                }
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 8)
            }

            Spacer()

            // Buttons
            VStack(spacing: AlcheSpacing.md) {
                AlcheButton("Start GlowScan", style: .primary, isFullWidth: true) {
                    // TODO: Navigate to GlowScan flow
                    // For now, complete onboarding
                    appState.hasCompletedOnboarding = true
                }

                AlcheButton("Skip for now", style: .ghost) {
                    appState.onboardingStep = .personalizedHome
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.xl)
            .opacity(contentVisible ? 1 : 0)
        }
        .background(Color.alcheBackground)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                contentVisible = true
            }
        }
    }
}

#Preview {
    GlowScanInvitationView()
        .environment(AppState())
}
