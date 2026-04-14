import SwiftUI

@main
struct AlcheApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                if !appState.hasSeenWelcome {
                    WelcomeView(
                        onBegin: {
                            withAnimation(.alcheDefault) {
                                appState.hasSeenWelcome = true
                            }
                        },
                        onSignIn: {
                            withAnimation(.alcheDefault) {
                                appState.hasSeenWelcome = true
                            }
                        }
                    )
                    .transition(.opacity)
                } else if !appState.isAuthenticated {
                    AuthView()
                } else if !appState.hasCompletedOnboarding {
                    OnboardingContainerView()
                } else {
                    ContentView()
                }
            }
            .environment(appState)
            .preferredColorScheme(.light)
        }
    }
}
