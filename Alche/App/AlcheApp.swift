import SwiftUI

@main
struct AlcheApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                if !appState.isAuthenticated {
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
