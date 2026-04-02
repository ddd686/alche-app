import SwiftUI

struct ProtocolListView: View {
    @State private var viewModel = ProtocolsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text("Protocols")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text("Curated routines for your goals. Follow the steps, track your progress.")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Goal filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AlcheSpacing.sm) {
                        AlcheTag(
                            text: "All",
                            color: .alchePrimary,
                            isSelected: viewModel.selectedGoal == nil
                        )
                        .onTapGesture { viewModel.selectedGoal = nil }

                        ForEach(ProtocolGoal.allCases, id: \.self) { goal in
                            AlcheTag(
                                text: goal.displayName,
                                color: goalColor(goal),
                                isSelected: viewModel.selectedGoal == goal
                            )
                            .onTapGesture { viewModel.selectedGoal = goal }
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Active protocol highlight
                if let activeId = viewModel.activeProtocolId,
                   let active = viewModel.protocols.first(where: { $0.id == activeId }) {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("ACTIVE PROTOCOL")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)
                            .padding(.horizontal, AlcheSpacing.lg)

                        NavigationLink {
                            ProtocolDetailView(
                                healthProtocol: active,
                                viewModel: viewModel
                            )
                        } label: {
                            ActiveProtocolCard(
                                healthProtocol: active,
                                completedSteps: viewModel.completedSteps(for: active.id, totalSteps: active.steps.count),
                                totalSteps: active.steps.count
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, AlcheSpacing.lg)
                    }
                }

                // Protocol list
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("ALL PROTOCOLS")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)
                        .padding(.horizontal, AlcheSpacing.lg)

                    LazyVStack(spacing: AlcheSpacing.md) {
                        ForEach(viewModel.filteredProtocols) { proto in
                            NavigationLink {
                                ProtocolDetailView(
                                    healthProtocol: proto,
                                    viewModel: viewModel
                                )
                            } label: {
                                ProtocolCard(
                                    healthProtocol: proto,
                                    isLocked: viewModel.isProtocolLocked(proto),
                                    isActive: proto.id == viewModel.activeProtocolId
                                )
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.isProtocolLocked(proto))
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }
            }
            .padding(.top, AlcheSpacing.md)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Protocols")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadProtocols()
        }
    }

    private func goalColor(_ goal: ProtocolGoal) -> Color {
        switch goal {
        case .sleep: .alcheInfo
        case .energy: .alchePrimary
        case .recovery: .alcheSage
        case .glow: .alcheAmber
        case .calm: .alcheSage
        case .gut: .alcheSage
        }
    }
}

// MARK: - Active Protocol Card

private struct ActiveProtocolCard: View {
    let healthProtocol: HealthProtocol
    let completedSteps: Int
    let totalSteps: Int

    var body: some View {
        AlcheCard(shadow: .medium) {
            VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text(healthProtocol.name)
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheEditorialBlack)

                        if let goal = healthProtocol.goalTag {
                            AlcheTag(text: goal.displayName, color: goalColor(goal))
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    ProgressView(value: progress)
                        .tint(Color.alcheSage)

                    Text("\(completedSteps) of \(totalSteps) steps completed today")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
    }

    private var progress: Double {
        guard totalSteps > 0 else { return 0 }
        return Double(completedSteps) / Double(totalSteps)
    }

    private func goalColor(_ goal: ProtocolGoal) -> Color {
        switch goal {
        case .sleep: .alcheInfo
        case .energy: .alchePrimary
        case .recovery: .alcheSage
        case .glow: .alcheAmber
        case .calm: .alcheSage
        case .gut: .alcheSage
        }
    }
}

// MARK: - Protocol Card

private struct ProtocolCard: View {
    let healthProtocol: HealthProtocol
    let isLocked: Bool
    let isActive: Bool

    var body: some View {
        AlcheCard {
            HStack(spacing: AlcheSpacing.md) {
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    HStack(spacing: AlcheSpacing.sm) {
                        Text(healthProtocol.name)
                            .font(.alcheSubheading)
                            .foregroundStyle(isLocked ? Color.alcheSecondaryText : Color.alcheEditorialBlack)

                        if isActive {
                            Text("ACTIVE")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSage)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.alcheSage.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }

                    if let desc = healthProtocol.description {
                        Text(desc)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .lineLimit(2)
                    }

                    HStack(spacing: AlcheSpacing.sm) {
                        if let goal = healthProtocol.goalTag {
                            AlcheTag(text: goal.displayName, color: goalColor(goal))
                        }

                        Label("\(healthProtocol.steps.count) steps", systemImage: "list.bullet")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)

                        if isLocked {
                            Label(healthProtocol.tierRequired.displayName, systemImage: "lock.fill")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheAmber)
                        }
                    }
                }

                Spacer()

                if !isLocked {
                    Image(systemName: "chevron.right")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
        .opacity(isLocked ? 0.6 : 1.0)
    }

    private func goalColor(_ goal: ProtocolGoal) -> Color {
        switch goal {
        case .sleep: .alcheInfo
        case .energy: .alchePrimary
        case .recovery: .alcheSage
        case .glow: .alcheAmber
        case .calm: .alcheSage
        case .gut: .alcheSage
        }
    }
}

#Preview {
    NavigationStack {
        ProtocolListView()
    }
}
