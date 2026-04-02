import SwiftUI

/// Abstract data-art visualization for the Digital Twin.
/// Uses concentric arcs and radial segments to represent body regions.
/// Healthy areas pulse in sage, attention areas glow in amber.
struct BodyMapVisualization: View {
    let regionStates: [RegionState]
    let showFuture: Bool
    let futureProjections: [FutureProjection]
    var onRegionTap: (RegionState) -> Void = { _ in }

    @State private var animationPhase: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

            ZStack {
                // Background rings
                ForEach(0..<3) { ring in
                    Circle()
                        .stroke(Color.alcheWarmGray.opacity(0.3), lineWidth: 1)
                        .frame(width: size * ringScale(ring), height: size * ringScale(ring))
                        .position(center)
                }

                // Region segments
                ForEach(Array(regionStates.enumerated()), id: \.element.region) { index, region in
                    let angle = segmentAngle(index: index, total: regionStates.count)
                    let radius = size * 0.32
                    let position = CGPoint(
                        x: center.x + radius * cos(angle),
                        y: center.y + radius * sin(angle)
                    )

                    RegionNode(
                        region: region,
                        showFuture: showFuture,
                        projection: futureProjections.first { $0.region == region.region },
                        animationPhase: animationPhase
                    )
                    .position(position)
                    .onTapGesture {
                        onRegionTap(region)
                    }
                }

                // Center score
                VStack(spacing: 2) {
                    Text("\(overallScore)")
                        .font(.alcheMonoLarge)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text("OVERALL")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(1)
                }
                .position(center)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animationPhase = 1
            }
        }
    }

    private var overallScore: Int {
        guard !regionStates.isEmpty else { return 0 }
        return regionStates.reduce(0) { $0 + $1.score } / regionStates.count
    }

    private func ringScale(_ ring: Int) -> CGFloat {
        switch ring {
        case 0: return 0.3
        case 1: return 0.55
        default: return 0.85
        }
    }

    private func segmentAngle(index: Int, total: Int) -> CGFloat {
        let startAngle: CGFloat = -.pi / 2
        return startAngle + (2 * .pi * CGFloat(index) / CGFloat(total))
    }
}

// MARK: - Region Node

private struct RegionNode: View {
    let region: RegionState
    let showFuture: Bool
    let projection: FutureProjection?
    let animationPhase: CGFloat

    var body: some View {
        VStack(spacing: AlcheSpacing.xs) {
            ZStack {
                // Glow effect for healthy regions
                Circle()
                    .fill(regionColor.opacity(0.2 + (region.status == .thriving ? animationPhase * 0.15 : 0)))
                    .frame(width: 64, height: 64)

                Circle()
                    .fill(regionColor.opacity(0.6))
                    .frame(width: 44, height: 44)

                Text("\(displayScore)")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(.white)
            }

            Text(region.region.displayName)
                .font(.alcheOverline)
                .foregroundStyle(Color.alchePrimaryText)
                .lineLimit(1)
                .frame(width: 80)
                .multilineTextAlignment(.center)

            // Future improvement arrow
            if showFuture, let proj = projection {
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 8))
                    Text("+\(proj.improvement)")
                        .font(.alcheOverline)
                }
                .foregroundStyle(Color.alcheSage)
            }
        }
    }

    private var displayScore: Int {
        if showFuture, let proj = projection {
            return proj.projectedScore
        }
        return region.score
    }

    private var regionColor: Color {
        switch region.status {
        case .thriving: .alcheSage
        case .balanced: .alcheSage.opacity(0.7)
        case .attention: .alcheAmber
        case .concern: .alchePrimary
        }
    }
}

#Preview {
    BodyMapVisualization(
        regionStates: DigitalTwinState.preview.regionStates,
        showFuture: false,
        futureProjections: DigitalTwinState.preview.futureProjection ?? []
    )
    .padding()
    .background(Color.alcheBackground)
}
