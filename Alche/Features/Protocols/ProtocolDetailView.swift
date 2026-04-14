import SwiftUI

// MARK: - Protocol Detail View (Beauty Protocol / Daily Routine)

struct ProtocolDetailView: View {
    let healthProtocol: HealthProtocol
    @Bindable var viewModel: ProtocolsViewModel
    @Environment(\.dismiss) private var dismiss

    // Beauty palette — from AlcheColors tokens
    private let beautyBg = Color.alcheBeautyBg
    private let beautyText = Color.alcheBeautyText
    private let beautyMuted = Color.alcheBeautyMuted
    private let beautyDivider = Color.alcheBeautyDivider
    private let beautyFooterBg = Color.alcheBeautyFooterBg

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header bar
                    headerBar

                    // Thin divider
                    Rectangle()
                        .fill(beautyDivider)
                        .frame(height: 1)
                        .padding(.horizontal, AlcheSpacing.lg)
                        .padding(.bottom, AlcheSpacing.md)

                    // Content
                    VStack(alignment: .leading, spacing: 0) {
                        // Overline + Title
                        titleSection

                        // Status card
                        statusCard

                        // Checklist
                        checklistSection
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }
            }

            // Footer: Cycle Phase + Skin Hydration
            footerBar
        }
        .background(beautyBg.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    // MARK: - Header Bar

    private var headerBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .foregroundStyle(beautyText)
            }

            Spacer()

            Text("PROTOCOL V9")
                .font(.alcheMonoBold)
                .tracking(2.0)
                .foregroundStyle(beautyMuted)

            Spacer()

            Button {
                // Calendar action
            } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundStyle(beautyText)
            }
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.top, AlcheSpacing.lg)
        .padding(.bottom, AlcheSpacing.sm)
    }

    // MARK: - Title

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text("DAILY ROUTINE")
                .font(.alcheOverline)
                .textCase(.uppercase)
                .tracking(2.0)
                .foregroundStyle(beautyMuted)

            Text("Beauty Glow\nProtocol")
                .font(.alcheDisplayXL)
                .foregroundStyle(beautyText)
        }
        .padding(.top, AlcheSpacing.sm)
        .padding(.bottom, AlcheSpacing.xl)
    }

    // MARK: - Status Card

    private var statusCard: some View {
        VStack(spacing: 0) {
            // Thin progress bar at top
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(beautyText.opacity(0.05))

                    Rectangle()
                        .fill(beautyText)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 4)

            // Content
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text("STATUS")
                        .font(.alcheOverline)
                        .textCase(.uppercase)
                        .tracking(1.0)
                        .foregroundStyle(beautyMuted)

                    Text(statusText)
                        .font(.custom("Newsreader16pt-Italic", size: 18, relativeTo: .body))
                        .foregroundStyle(beautyText)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                    Text("COMPLETION")
                        .font(.alcheOverline)
                        .textCase(.uppercase)
                        .tracking(1.0)
                        .foregroundStyle(beautyMuted)

                    Text("\(Int(progress * 100))%")
                        .font(.custom("SpaceMono-Regular", size: 30, relativeTo: .title))
                        .foregroundStyle(beautyText)
                }
            }
            .padding(.horizontal, AlcheSpacing.md)
            .padding(.top, AlcheSpacing.sm + 4)
            .padding(.bottom, AlcheSpacing.md)
        }
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .stroke(beautyText.opacity(0.1), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
        .padding(.bottom, AlcheSpacing.xl + AlcheSpacing.sm)
    }

    // MARK: - Checklist

    private var checklistSection: some View {
        VStack(spacing: AlcheSpacing.lg) {
            ForEach(Array(healthProtocol.steps.enumerated()), id: \.offset) { index, step in
                let isCompleted = viewModel.isStepCompleted(
                    protocolId: healthProtocol.id,
                    stepIndex: index
                )
                let isLast = index == healthProtocol.steps.count - 1

                BeautyChecklistRow(
                    step: step,
                    isCompleted: isCompleted,
                    isLast: isLast,
                    onToggle: {
                        viewModel.toggleStep(
                            protocolId: healthProtocol.id,
                            stepIndex: index
                        )
                    }
                )
            }
        }
    }

    // MARK: - Footer

    private var footerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text("CYCLE PHASE")
                    .font(.alcheOverlineTiny)
                    .textCase(.uppercase)
                    .tracking(2.0)
                    .foregroundStyle(beautyMuted)

                Text("Ovulatory")
                    .font(.custom("Newsreader16pt-Italic", size: 14, relativeTo: .footnote))
                    .foregroundStyle(beautyText)
            }

            Spacer()

            // Divider
            Rectangle()
                .fill(beautyText.opacity(0.1))
                .frame(width: 1, height: 32)

            Spacer()

            VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                Text("SKIN HYDRATION")
                    .font(.alcheOverlineTiny)
                    .textCase(.uppercase)
                    .tracking(2.0)
                    .foregroundStyle(beautyMuted)

                Text("Optimal")
                    .font(.alcheMono)
                    .foregroundStyle(beautyText)
            }
        }
        .padding(.horizontal, AlcheSpacing.xl)
        .padding(.vertical, AlcheSpacing.lg)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(beautyDivider)
                .frame(height: 1)
        }
        .background(beautyFooterBg)
    }

    // MARK: - Computed

    private var completedCount: Int {
        viewModel.completedSteps(for: healthProtocol.id, totalSteps: healthProtocol.steps.count)
    }

    private var progress: Double {
        guard !healthProtocol.steps.isEmpty else { return 0 }
        return Double(completedCount) / Double(healthProtocol.steps.count)
    }

    private var statusText: String {
        let pct = progress
        if pct >= 1.0 { return "Luminous" }
        if pct >= 0.75 { return "Nearly Luminous" }
        if pct >= 0.5 { return "Approaching Luminous" }
        if pct >= 0.25 { return "Building Radiance" }
        return "Just Beginning"
    }
}

// MARK: - Beauty Checklist Row

private struct BeautyChecklistRow: View {
    let step: ProtocolStep
    let isCompleted: Bool
    let isLast: Bool
    let onToggle: () -> Void

    private let beautyText = Color.alcheBeautyText
    private let beautyMuted = Color.alcheBeautyMuted
    private let beautyDivider = Color.alcheBeautyDivider

    var body: some View {
        HStack(alignment: .top, spacing: AlcheSpacing.md) {
            // Custom checkbox
            Button(action: onToggle) {
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(isCompleted ? beautyText : Color.clear)
                        .frame(width: 16, height: 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(beautyText, lineWidth: 1)
                        )

                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.alcheWhite)
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 6)

            // Content
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                HStack(alignment: .firstTextBaseline) {
                    Text(step.action)
                        .font(.custom("Newsreader16pt-Italic", size: 20, relativeTo: .title3))
                        .foregroundStyle(beautyText)
                        .strikethrough(isCompleted, color: beautyText.opacity(0.3))

                    Spacer()

                    Text(step.time)
                        .font(.alcheOverline)
                        .foregroundStyle(beautyMuted)
                }

                if let detail = step.detail {
                    Text(detail.uppercased())
                        .font(.alcheCaption)
                        .tracking(0.8)
                        .foregroundStyle(beautyMuted)
                } else {
                    Text(categoryDescription(step.category).uppercased())
                        .font(.alcheCaption)
                        .tracking(0.8)
                        .foregroundStyle(beautyMuted)
                }
            }
            .padding(.bottom, AlcheSpacing.md)
            .overlay(alignment: .bottom) {
                if !isLast {
                    Rectangle()
                        .fill(beautyDivider)
                        .frame(height: 1)
                }
            }
        }
    }

    private func categoryDescription(_ category: StepCategory) -> String {
        switch category {
        case .supplement: "Supplement intake"
        case .nutrition: "Nutrition step"
        case .movement: "Movement activity"
        case .light: "Light therapy session"
        case .mindfulness: "Mindfulness practice"
        case .sleep: "Sleep optimization"
        case .hydration: "Hydration step"
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProtocolDetailView(
            healthProtocol: HealthProtocol(
                id: UUID(),
                name: "Beauty Glow Protocol",
                description: "A daily beauty protocol combining hydration, antioxidants, and light therapy.",
                goalTag: .glow,
                steps: [
                    ProtocolStep(time: "07:00", action: "Morning Hydration", category: .hydration, detail: "Electrolyte infusion + Lemon"),
                    ProtocolStep(time: "07:15", action: "Antioxidant Serum", category: .supplement, detail: "Vitamin C application"),
                    ProtocolStep(time: "13:00", action: "Supplements", category: .supplement, detail: "Collagen + Resveratrol"),
                    ProtocolStep(time: "20:30", action: "LED Therapy", category: .light, detail: "Red light spectrum / 15 mins"),
                    ProtocolStep(time: "21:00", action: "Night Repair", category: .sleep, detail: "Retinol + Lipid Barrier Cream"),
                ],
                tierRequired: .free
            ),
            viewModel: ProtocolsViewModel()
        )
    }
}
