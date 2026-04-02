import SwiftUI

// MARK: - Loading View

struct AlcheLoadingView: View {
    var message: String? = nil

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: AlcheSpacing.lg) {
            ZStack {
                Circle()
                    .stroke(Color.alcheWarmGray, lineWidth: 3)
                    .frame(width: 44, height: 44)

                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(Color.alchePrimary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: 1.0).repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }

            if let message {
                Text(message)
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.alcheBackground)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview

#Preview("Loading") {
    AlcheLoadingView(message: "Preparing your session...")
}
