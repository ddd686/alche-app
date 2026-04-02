import SwiftUI

struct OnboardingContainerView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            switch appState.onboardingStep {
            case .brandMoment:
                BrandMomentView()
                    .transition(.opacity)

            case .quickScan:
                QuickScanView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .focusAreaReveal:
                FocusAreaRevealView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .glowScanInvitation:
                GlowScanInvitationView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .personalizedHome:
                // Auto-complete onboarding when reaching this step
                Color.clear
                    .onAppear {
                        appState.hasCompletedOnboarding = true
                    }
            }
        }
        .animation(.alcheDefault, value: appState.onboardingStep)
    }
}

#Preview {
    OnboardingContainerView()
        .environment(AppState())
}
