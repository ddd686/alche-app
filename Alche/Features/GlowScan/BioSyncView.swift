import SwiftUI

// MARK: - BioSyncView (Bio-Sync Protocol Screen)

struct BioSyncView: View {
    // Animation state
    @State private var outerDashRotation: Double = 0
    @State private var orbitRotation: Double = 0
    @State private var reverseOrbitRotation: Double = 0
    @State private var imageBreathing: CGFloat = 1.0
    @Environment(\.dismiss) private var dismiss
    @State private var processingPulse = false
    @State private var activeDotGlow = false

    private let circleSize: CGFloat = 280
    private let innerImageSize: CGFloat = 180

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerBar

            // Separator
            Rectangle()
                .fill(Color.alcheEditorialBlack.opacity(0.05))
                .frame(height: 1)
                .padding(.horizontal, AlcheSpacing.lg)

            // Main content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Orbital visualization
                    orbitalVisualization
                        .padding(.top, AlcheSpacing.xl)

                    // Title
                    titleSection
                        .padding(.top, AlcheSpacing.lg)

                    // Progress items
                    progressSection
                        .padding(.top, AlcheSpacing.xxl)
                        .padding(.horizontal, AlcheSpacing.xl)

                    Spacer(minLength: AlcheSpacing.xl)
                }
            }

        }
        .background(Color.alcheLightGray)
        .navigationBarHidden(true)
        .onAppear {
            startAnimations()
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.alcheEditorialBlack)
            }

            Spacer()

            Text("BIO-SYNC PROTOCOL")
                .font(.alcheOverline)
                .textCase(.uppercase)
                .tracking(2.0)
                .foregroundStyle(Color.alcheEditorialMuted)
                .fontWeight(.bold)

            Spacer()

            HStack(spacing: AlcheSpacing.sm) {
                Circle()
                    .fill(Color.alchePrimary)
                    .frame(width: 6, height: 6)
                    .shadow(color: Color.alchePrimary.opacity(0.6), radius: 3)
                    .opacity(processingPulse ? 1.0 : 0.5)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: processingPulse)

                Text("ACTIVE")
                    .font(.alcheOverline)
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(Color.alcheEditorialBlack)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.top, AlcheSpacing.lg)
        .padding(.bottom, AlcheSpacing.sm)
    }

    // MARK: - Orbital Visualization

    private var orbitalVisualization: some View {
        ZStack {
            // Outer dashed circle — slow spin
            Circle()
                .stroke(
                    Color.alchePrimary.opacity(0.2),
                    style: StrokeStyle(lineWidth: 1, dash: [6, 4])
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(outerDashRotation))

            // Inner ring
            Circle()
                .stroke(Color.alcheEditorialBlack.opacity(0.05), lineWidth: 1)
                .frame(width: circleSize - 56, height: circleSize - 56)

            // Orbit accent: top border spinning fast
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(Color.alchePrimary.opacity(0.6), lineWidth: 1)
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(orbitRotation))

            // Reverse orbit accent
            Circle()
                .trim(from: 0, to: 0.15)
                .stroke(Color.alchePrimary.opacity(0.3), lineWidth: 1)
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(reverseOrbitRotation))

            // Inner image circle
            ZStack {
                Circle()
                    .fill(Color.alcheWarmGray)
                    .frame(width: innerImageSize, height: innerImageSize)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)

                // Abstract teal-blue visual (simulated with gradient)
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.alchePrimary.opacity(0.8),
                                Color.alchePrimary.opacity(0.55),
                                Color.alchePrimary.opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: innerImageSize, height: innerImageSize)
                    .scaleEffect(imageBreathing)

                // Dot grid overlay
                DotGridPattern()
                    .fill(Color.alchePrimary.opacity(0.3))
                    .frame(width: innerImageSize, height: innerImageSize)
                    .clipShape(Circle())

                // Wave / organic shape overlay
                WaveShape()
                    .fill(Color.alchePrimary.opacity(0.3))
                    .frame(width: innerImageSize * 0.7, height: innerImageSize * 0.5)
                    .clipShape(Circle().size(width: innerImageSize, height: innerImageSize).offset(x: 0, y: 0))
            }
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.alcheEditorialBlack.opacity(0.1), lineWidth: 1)
                    .frame(width: innerImageSize, height: innerImageSize)
            )

            // "Scanning" badge — top right of circle
            scanningBadge
                .offset(x: circleSize * 0.3, y: -circleSize * 0.3)
        }
        .frame(width: circleSize + 20, height: circleSize + 20)
    }

    private var scanningBadge: some View {
        Text("SCANNING")
            .font(.custom("NotoSans-Bold", size: 8, relativeTo: .caption2))
            .textCase(.uppercase)
            .tracking(1.5)
            .foregroundStyle(Color.alchePrimary)
            .fontWeight(.bold)
            .padding(.horizontal, AlcheSpacing.sm)
            .padding(.vertical, AlcheSpacing.xs)
            .background(Color.alcheWhite.opacity(0.8))
            .background(.ultraThinMaterial)
            .overlay(
                Rectangle()
                    .stroke(Color.alcheEditorialBlack.opacity(0.1), lineWidth: 0.5)
            )
    }

    // MARK: - Title Section

    private var titleSection: some View {
        VStack(spacing: AlcheSpacing.sm) {
            VStack(spacing: 0) {
                Text("Synchronizing")
                    .font(.alcheDisplayXL)
                    .foregroundStyle(Color.alcheEditorialBlack)

                Text("Bio-Data")
                    .font(.custom("Newsreader16pt-Italic", size: 48, relativeTo: .largeTitle))
                    .foregroundStyle(Color.alcheEditorialBlack)
                    .tracking(-0.5)
            }

            Text("ESTABLISHING SECURE HANDSHAKE")
                .font(.alcheOverline)
                .textCase(.uppercase)
                .tracking(2.5)
                .foregroundStyle(Color.alcheEditorialMuted)
                .padding(.top, AlcheSpacing.xs)
        }
        .multilineTextAlignment(.center)
    }

    // MARK: - Progress Section

    private var progressSection: some View {
        VStack(spacing: AlcheSpacing.xl) {
            // Lipid Analysis — Complete
            SyncProgressItem(
                label: "LIPID ANALYSIS",
                status: "Complete",
                statusStyle: .complete,
                progress: 1.0,
                barColor: Color.alchePrimary,
                isActive: false
            )

            // Metabolic Mapping — Processing
            SyncProgressItem(
                label: "METABOLIC MAPPING",
                status: "Processing...",
                statusStyle: .processing,
                progress: 0.65,
                barColor: Color.alcheEditorialBlack,
                isActive: true,
                showPulsingDot: true,
                dotPulse: processingPulse
            )

            // Hormonal Baseline — Queued
            SyncProgressItem(
                label: "HORMONAL BASELINE",
                status: "Queued",
                statusStyle: .queued,
                progress: 0,
                barColor: Color.alcheEditorialBlack,
                isActive: false
            )
            .opacity(0.4)
        }
    }

    // MARK: - Animations

    private func startAnimations() {
        // Outer dashed circle: 10s full rotation
        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
            outerDashRotation = 360
        }

        // Fast orbit: 2s
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            orbitRotation = 360
        }

        // Reverse orbit: 3s
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: false)) {
            reverseOrbitRotation = -360
        }

        // Breathing image
        withAnimation(.alcheBreathing) {
            imageBreathing = 1.05
        }

        // Processing pulse
        processingPulse = true
        activeDotGlow = true
    }
}

// MARK: - SyncProgressItem

struct SyncProgressItem: View {
    let label: String
    let status: String
    let statusStyle: StatusStyle
    let progress: CGFloat
    let barColor: Color
    let isActive: Bool
    var showPulsingDot: Bool = false
    var dotPulse: Bool = false

    enum StatusStyle {
        case complete, processing, queued
    }

    var body: some View {
        VStack(spacing: AlcheSpacing.sm) {
            HStack {
                Text(label)
                    .font(.alcheOverline)
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(Color.alcheEditorialBlack)
                    .fontWeight(.bold)

                Spacer()

                Text(status)
                    .font(.custom("Newsreader16pt-Italic", size: 13, relativeTo: .footnote))
                    .foregroundStyle(
                        statusStyle == .complete
                            ? Color.alchePrimary
                            : Color.alcheEditorialMuted
                    )
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track
                    Rectangle()
                        .fill(Color.alcheEditorialBlack.opacity(0.05))
                        .frame(height: 2)

                    // Fill
                    Rectangle()
                        .fill(
                            statusStyle == .complete
                                ? barColor
                                : barColor
                        )
                        .frame(width: geo.size.width * progress, height: 2)
                        .shadow(
                            color: statusStyle == .complete
                                ? Color.alchePrimary.opacity(0.3)
                                : Color.clear,
                            radius: statusStyle == .complete ? 5 : 0
                        )
                        .overlay(alignment: .trailing) {
                            if showPulsingDot {
                                Circle()
                                    .fill(Color.alchePrimary)
                                    .frame(width: 5, height: 5)
                                    .shadow(color: Color.alchePrimary.opacity(0.8), radius: 4)
                                    .opacity(dotPulse ? 1.0 : 0.4)
                                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: dotPulse)
                            }
                        }
                }
            }
            .frame(height: 2)
        }
    }
}

// MARK: - Dot Grid Pattern

struct DotGridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 12
        let dotRadius: CGFloat = 1

        var x: CGFloat = spacing / 2
        while x < rect.width {
            var y: CGFloat = spacing / 2
            while y < rect.height {
                path.addEllipse(in: CGRect(
                    x: x - dotRadius,
                    y: y - dotRadius,
                    width: dotRadius * 2,
                    height: dotRadius * 2
                ))
                y += spacing
            }
            x += spacing
        }
        return path
    }
}

// MARK: - Wave Shape (organic overlay)

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.midY

        path.move(to: CGPoint(x: 0, y: midY))
        path.addCurve(
            to: CGPoint(x: rect.width, y: midY),
            control1: CGPoint(x: rect.width * 0.3, y: midY - rect.height * 0.4),
            control2: CGPoint(x: rect.width * 0.7, y: midY + rect.height * 0.4)
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

// MARK: - Preview

#Preview {
    BioSyncView()
        .preferredColorScheme(.light)
}
