import SwiftUI

// MARK: - Ritual Notification View

/// Full-screen dark cinematic modal for ritual notifications.
/// Matches the Stitch "variant-1-0b57" design: water-texture dark background,
/// subtle border frame, vertical line drop, editorial typography, footer actions.
struct RitualNotificationView: View {
    let ritualTitle: String
    let ritualSubtitle: String
    let variantLabel: String
    let sequenceLabel: String
    var onDismiss: () -> Void = {}
    var onBegin: () -> Void = {}

    @State private var headerVisible = false
    @State private var titleVisible = false
    @State private var metadataVisible = false
    @State private var footerVisible = false

    var body: some View {
        ZStack {
            // MARK: Background — dark cinematic gradient
            background

            // MARK: Border frame overlay
            borderFrame

            // MARK: Content
            VStack(spacing: 0) {
                headerSection
                Spacer()
                titleSection
                Spacer()
                footerSection
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animateEntrance()
        }
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            Color.black

            // Layered gradients to approximate the cinematic water-texture mood
            LinearGradient(
                colors: [
                    Color.white.opacity(0.06),
                    Color.white.opacity(0.02),
                    Color.clear,
                    Color.white.opacity(0.03),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Horizontal wave-like bands
            VStack(spacing: 0) {
                ForEach(0..<8, id: \.self) { i in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(Double.random(in: 0.01...0.04)),
                                    Color.white.opacity(Double.random(in: 0.00...0.02)),
                                    Color.white.opacity(Double.random(in: 0.02...0.05)),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: UIScreen.main.bounds.height / 8)
                }
            }

            // Top-to-bottom vignette
            LinearGradient(
                colors: [
                    Color.black.opacity(0.2),
                    Color.clear,
                    Color.black.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - Border Frame

    private var borderFrame: some View {
        GeometryReader { geo in
            let inset: CGFloat = AlcheSpacing.lg

            // Top border
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(height: 1)
                .offset(y: inset)
                .padding(.horizontal, inset)

            // Bottom border
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(height: 1)
                .offset(y: geo.size.height - inset)
                .padding(.horizontal, inset)

            // Left border
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 1)
                .offset(x: inset)
                .padding(.vertical, inset)

            // Right border
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 1)
                .offset(x: geo.size.width - inset)
                .padding(.vertical, inset)
        }
        .allowsHitTesting(false)
    }

    // MARK: - Header (vertical line + overline)

    private var headerSection: some View {
        VStack(spacing: AlcheSpacing.lg) {
            // Vertical drop line
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 1, height: 48)

            // "TIME FOR RITUAL" overline
            Text("Time for Ritual")
                .font(.alcheOverline)
                .textCase(.uppercase)
                .tracking(4)
                .foregroundStyle(Color.white)
                .shadow(color: .black.opacity(0.5), radius: 4, y: 2)
        }
        .padding(.top, 80)
        .opacity(headerVisible ? 1 : 0)
        .offset(y: headerVisible ? 0 : 20)
    }

    // MARK: - Title Section (display text + metadata)

    private var titleSection: some View {
        VStack(spacing: 0) {
            // Giant italic display text
            VStack(spacing: 2) {
                Text(ritualTitle)
                    .font(.alcheDisplayHero)
                    .foregroundStyle(Color.white)
                    .shadow(color: .black.opacity(0.6), radius: 8, y: 4)

                Text(ritualSubtitle)
                    .font(.alcheDisplayHero)
                    .foregroundStyle(Color.white)
                    .shadow(color: .black.opacity(0.6), radius: 8, y: 4)
            }
            .multilineTextAlignment(.center)
            .opacity(titleVisible ? 1 : 0)
            .offset(y: titleVisible ? 0 : 20)

            // Metadata line: "Var. 7 . H20-Seq"
            HStack(spacing: AlcheSpacing.md) {
                Text(variantLabel)
                    .font(.alcheOverlineTiny)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .textCase(.uppercase)
                    .tracking(1.5)

                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 3, height: 3)

                Text(sequenceLabel)
                    .font(.alcheOverlineTiny)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .textCase(.uppercase)
                    .tracking(1.5)
            }
            .padding(.top, AlcheSpacing.xxl)
            .opacity(metadataVisible ? 1 : 0)
            .offset(y: metadataVisible ? 0 : 20)
        }
        .padding(.horizontal, AlcheSpacing.xl)
    }

    // MARK: - Footer (Dismiss + Begin)

    private var footerSection: some View {
        VStack(spacing: 0) {
            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(height: 1)
                .padding(.horizontal, AlcheSpacing.xl)

            HStack {
                // Dismiss
                Button(action: onDismiss) {
                    Text("Dismiss")
                        .font(.alcheOverline)
                        .textCase(.uppercase)
                        .tracking(3)
                        .foregroundStyle(Color.white.opacity(0.6))
                }
                .buttonStyle(.plain)

                Spacer()

                // Begin
                Button(action: onBegin) {
                    Text("Begin")
                        .font(.alcheOverline)
                        .textCase(.uppercase)
                        .tracking(3)
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                        .overlay(
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 1),
                            alignment: .bottom
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 40)
            .padding(.top, AlcheSpacing.lg)
        }
        .padding(.bottom, 64)
        .opacity(footerVisible ? 1 : 0)
        .offset(y: footerVisible ? 0 : 20)
    }

    // MARK: - Animation

    private func animateEntrance() {
        withAnimation(.easeOut(duration: 1.2).delay(0.0)) {
            headerVisible = true
        }
        withAnimation(.easeOut(duration: 1.2).delay(0.2)) {
            titleVisible = true
        }
        withAnimation(.easeOut(duration: 1.2).delay(0.4)) {
            metadataVisible = true
        }
        withAnimation(.easeOut(duration: 1.2).delay(0.4)) {
            footerVisible = true
        }
    }
}

// MARK: - Preview

#Preview {
    RitualNotificationView(
        ritualTitle: "Cellular",
        ritualSubtitle: "Hydration",
        variantLabel: "Var. 7",
        sequenceLabel: "H20-Seq",
        onDismiss: {},
        onBegin: {}
    )
}
