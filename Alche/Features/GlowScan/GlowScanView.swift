import SwiftUI
import PhotosUI

// MARK: - GlowScanView (Live Skin Analysis Camera)

struct GlowScanView: View {
    @State private var viewModel = GlowScanViewModel()
    @Environment(\.dismiss) private var dismiss

    // Animation state
    @State private var dashRotation: Double = 0
    @State private var scanLineOffset: CGFloat = 0
    @State private var isScanning = true
    @State private var breathingScale: CGFloat = 1.0
    @State private var progressPulse = false
    @State private var hydrationPulse = false
    @State private var collagenPulse = false
    @State private var selectedMode = 1 // 0=Texture, 1=Structural, 2=Thermal

    private let viewfinderSize: CGFloat = 280
    private let modes = ["Texture", "Structural", "Thermal"]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - Background layers
                backgroundLayers

                // MARK: - Content
                VStack(spacing: 0) {
                    headerBar
                        .padding(.top, geo.safeAreaInsets.top + AlcheSpacing.sm)

                    Spacer()

                    // Center viewfinder area
                    ZStack {
                        // Floating callouts
                        floatingCallouts

                        // Viewfinder
                        viewfinderFrame
                    }
                    .frame(width: viewfinderSize, height: viewfinderSize)

                    // Scanning status
                    scanningStatus
                        .padding(.top, AlcheSpacing.xxl)

                    Spacer()

                    // Mode tabs
                    modeTabs
                        .padding(.bottom, AlcheSpacing.lg)

                    // Capture button row
                    captureButtonRow
                        .padding(.bottom, geo.safeAreaInsets.bottom + AlcheSpacing.md)
                }
                .padding(.horizontal, AlcheSpacing.lg)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            startAnimations()
        }
        .task {
            await viewModel.loadHistory()
        }
        .navigationBarHidden(true)
    }

    // MARK: - Background

    private var backgroundLayers: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            // Moody teal-dark gradient overlay
            LinearGradient(
                colors: [
                    Color.black.opacity(0.6),
                    Color.alchePrimary.opacity(0.15),
                    Color.black.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Subtle grid overlay
            GridPattern()
                .stroke(Color.white.opacity(0.04), lineWidth: 0.5)
                .ignoresSafeArea()
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack(alignment: .top) {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.8))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                HStack(spacing: AlcheSpacing.sm) {
                    Circle()
                        .fill(Color.alcheError)
                        .frame(width: 6, height: 6)
                        .shadow(color: Color.alcheError.opacity(0.8), radius: 4)
                        .opacity(breathingScale)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: breathingScale)

                    Text("LIVE ANALYSIS")
                        .font(.alcheOverlineTiny)
                        .textCase(.uppercase)
                        .tracking(1.5)
                        .foregroundStyle(Color.white.opacity(0.8))
                }

                Text("S: 1/200   ISO 120")
                    .font(.alcheOverlineTiny)
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(Color.white.opacity(0.4))
            }
        }
    }

    // MARK: - Floating Callouts

    private var floatingCallouts: some View {
        ZStack {
            // Hydration callout — right side
            VStack(alignment: .trailing, spacing: 0) {
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 48, height: 1)
                    .padding(.bottom, AlcheSpacing.xs)

                HStack(spacing: 0) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("HYDRATION")
                            .font(.alcheOverline)
                            .textCase(.uppercase)
                            .tracking(1.5)
                            .foregroundStyle(Color.white)

                        Text("64%")
                            .font(.alcheMonoBold)
                            .foregroundStyle(Color.alchePrimary)
                    }
                    .padding(.leading, AlcheSpacing.sm)
                    .padding(.trailing, AlcheSpacing.xs)
                    .padding(.vertical, AlcheSpacing.xs)
                    .background(Color.alcheEditorialBlack.opacity(0.3))
                    .background(.ultraThinMaterial.opacity(0.3))

                    Rectangle()
                        .fill(Color.alchePrimary)
                        .frame(width: 2)
                        .frame(height: 36)
                }
            }
            .opacity(hydrationPulse ? 1.0 : 0.7)
            .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: hydrationPulse)
            .offset(x: viewfinderSize * 0.38, y: -viewfinderSize * 0.2)

            // Collagen callout — left side
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 36, height: 1)
                    .padding(.bottom, AlcheSpacing.xs)

                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 2)
                        .frame(height: 36)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("COLLAGEN INDEX")
                            .font(.alcheOverline)
                            .textCase(.uppercase)
                            .tracking(1.5)
                            .foregroundStyle(Color.white)

                        Text("0.8")
                            .font(.alcheMonoBold)
                            .foregroundStyle(Color.white)
                    }
                    .padding(.leading, AlcheSpacing.xs)
                    .padding(.trailing, AlcheSpacing.sm)
                    .padding(.vertical, AlcheSpacing.xs)
                    .background(Color.alcheEditorialBlack.opacity(0.3))
                    .background(.ultraThinMaterial.opacity(0.3))
                }
            }
            .opacity(collagenPulse ? 1.0 : 0.7)
            .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: collagenPulse)
            .offset(x: -viewfinderSize * 0.38, y: viewfinderSize * 0.15)
        }
    }

    // MARK: - Viewfinder Frame

    private var viewfinderFrame: some View {
        ZStack {
            // Corner brackets
            ViewfinderCorners()
                .stroke(Color.white.opacity(0.9), lineWidth: 1)
                .frame(width: viewfinderSize, height: viewfinderSize)

            // Crosshair center
            CrosshairShape()
                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                .frame(width: 24, height: 24)

            // Rotating dashed circle
            Circle()
                .stroke(
                    Color.white.opacity(0.2),
                    style: StrokeStyle(lineWidth: 1, dash: [6, 4])
                )
                .frame(width: 180, height: 180)
                .rotationEffect(.degrees(dashRotation))

            // Scan line sweeping vertically
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.alchePrimary,
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: viewfinderSize - 16, height: 1)
                .shadow(color: Color.alchePrimary, radius: 8)
                .offset(y: scanLineOffset)
                .opacity(isScanning ? 1 : 0)
        }
        .clipped()
    }

    // MARK: - Scanning Status

    private var scanningStatus: some View {
        VStack(spacing: AlcheSpacing.sm) {
            Text("SCANNING EPIDERMIS...")
                .font(.alcheOverline)
                .textCase(.uppercase)
                .tracking(3.0)
                .foregroundStyle(Color.white)
                .opacity(progressPulse ? 1.0 : 0.6)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: progressPulse)

            // Progress bar
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 2)

                Capsule()
                    .fill(Color.white)
                    .frame(width: 80, height: 2)
                    .opacity(progressPulse ? 1.0 : 0.4)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: progressPulse)
            }
        }
    }

    // MARK: - Mode Tabs

    private var modeTabs: some View {
        HStack(spacing: AlcheSpacing.xl) {
            ForEach(0..<modes.count, id: \.self) { index in
                Button {
                    withAnimation(.alcheDefault) {
                        selectedMode = index
                    }
                } label: {
                    VStack(spacing: AlcheSpacing.xs) {
                        Text(modes[index].uppercased())
                            .font(.alcheOverline)
                            .textCase(.uppercase)
                            .tracking(1.5)
                            .foregroundStyle(
                                index == selectedMode
                                    ? Color.white
                                    : Color.white.opacity(0.4)
                            )
                            .fontWeight(index == selectedMode ? .bold : .regular)

                        if index == selectedMode {
                            Rectangle()
                                .fill(Color.alchePrimary)
                                .frame(height: 1)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 1)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Capture Button Row

    private var captureButtonRow: some View {
        HStack(alignment: .center) {
            // LOCKED indicator
            HStack(spacing: AlcheSpacing.xs) {
                Image(systemName: "location.fill")
                    .font(.system(size: 12))
                Text("LOCKED")
                    .font(.alcheOverlineTiny)
            }
            .foregroundStyle(Color.white.opacity(0.5))
            .frame(maxWidth: .infinity, alignment: .leading)

            // Capture button
            Button {
                // Capture action placeholder
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: 64, height: 64)

                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: 48, height: 48)
                        .background(.ultraThinMaterial.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .buttonStyle(.plain)

            // FACE ID indicator
            HStack(spacing: AlcheSpacing.xs) {
                Text("FACE ID")
                    .font(.alcheOverlineTiny)
                Image(systemName: "faceid")
                    .font(.system(size: 12))
            }
            .foregroundStyle(Color.white.opacity(0.5))
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    // MARK: - Animations

    private func startAnimations() {
        // Rotating dashed circle: 10s full rotation
        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
            dashRotation = 360
        }

        // Scan line sweep: top to bottom in 3s
        withAnimation(.alcheScanLine) {
            scanLineOffset = viewfinderSize / 2
        }

        // Trigger repeating scan line
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            scanLineOffset = -viewfinderSize / 2
            withAnimation(.alcheScanLine) {
                scanLineOffset = viewfinderSize / 2
            }
        }

        // Pulse states
        breathingScale = 0.3
        progressPulse = true
        hydrationPulse = true
        collagenPulse = true
    }
}

// MARK: - Viewfinder Corner Brackets Shape

struct ViewfinderCorners: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerLength: CGFloat = 32
        var path = Path()

        // Top-left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.minY))

        // Top-right
        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerLength))

        // Bottom-left
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - cornerLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.maxY))

        // Bottom-right
        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))

        return path
    }
}

// MARK: - Crosshair Shape

struct CrosshairShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)

        // Horizontal line
        path.move(to: CGPoint(x: rect.minX, y: center.y))
        path.addLine(to: CGPoint(x: rect.maxX, y: center.y))

        // Vertical line
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY))

        return path
    }
}

// MARK: - Grid Pattern Shape

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 64

        // Vertical lines
        var x: CGFloat = 0
        while x < rect.width {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
            x += spacing
        }

        // Horizontal lines
        var y: CGFloat = 0
        while y < rect.height {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
            y += spacing
        }

        return path
    }
}

// MARK: - Preview

#Preview {
    GlowScanView()
        .preferredColorScheme(.dark)
}
