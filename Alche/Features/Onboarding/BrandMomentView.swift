import SwiftUI

struct BrandMomentView: View {
    @Environment(AppState.self) private var appState

    @State private var textOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.alcheEditorialBlack
                .ignoresSafeArea()

            Text("Alche.")
                .font(.alcheDisplayHero)
                .foregroundStyle(Color.alcheWhite)
                .opacity(textOpacity)
        }
        .onAppear {
            // Fade in over 1s
            withAnimation(.easeIn(duration: 1.0)) {
                textOpacity = 1.0
            }

            // Hold 3s then auto-advance (total 4s after fade starts: 1s fade + 3s hold)
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(4.0))
                appState.onboardingStep = .quickScan
            }
        }
    }
}

#Preview {
    BrandMomentView()
        .environment(AppState())
}
