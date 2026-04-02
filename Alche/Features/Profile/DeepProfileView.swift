import SwiftUI

struct DeepProfileView: View {
    @State private var viewModel = DeepProfileViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.alcheBackground.ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.alchePrimary)
            } else if viewModel.isComplete {
                completionScreen
            } else if viewModel.showSectionTransition {
                sectionTransitionScreen
            } else if let question = viewModel.currentQuestion {
                questionScreen(question)
            }
        }
        .navigationTitle("Deep Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewModel.currentQuestionIndex > 0 && !viewModel.isComplete)
        .toolbar {
            if viewModel.canGoBack && !viewModel.isComplete {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation(.alcheDefault) {
                            viewModel.goBack()
                        }
                    } label: {
                        HStack(spacing: AlcheSpacing.xs) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                            Text("Back")
                                .font(.alcheBody)
                        }
                        .foregroundStyle(Color.alchePrimary)
                    }
                }
            }
        }
        .task {
            await viewModel.loadQuestions()
        }
    }

    // MARK: - Question Screen

    @ViewBuilder
    private func questionScreen(_ question: QuestionnaireQuestion) -> some View {
        VStack(spacing: 0) {
            // Progress bar
            progressBar

            ScrollView {
                VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                    // Data source indicator
                    DataSourceIndicator(isMock: true)

                    // Section label
                    if let section = question.section {
                        Text(section.uppercased())
                            .font(.alcheOverline)
                            .tracking(1.2)
                            .foregroundStyle(Color.alcheEditorialMuted)
                    }

                    // Question text
                    Text(question.questionText)
                        .font(.alcheDisplayM)
                        .foregroundStyle(Color.alchePrimaryText)

                    // Question counter
                    Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.totalQuestions)")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheEditorialMuted)

                    // Answer options based on format
                    switch question.format {
                    case .singleSelect:
                        singleSelectOptions(question)
                    case .multiSelect:
                        multiSelectOptions(question)
                    case .slider:
                        sliderInput(question)
                    default:
                        Text("Unsupported question format")
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheEditorialMuted)
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.top, AlcheSpacing.lg)
                .padding(.bottom, AlcheSpacing.xxl)
            }

            // Bottom action for multiSelect and slider
            if question.format == .multiSelect {
                multiSelectContinueButton
            } else if question.format == .slider {
                sliderContinueButton
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
        .id(question.id)
        .animation(.alcheDefault, value: viewModel.currentQuestionIndex)
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.alcheEditorialBlack.opacity(0.06))
                    .frame(height: 3)

                Rectangle()
                    .fill(Color.alchePrimary)
                    .frame(width: geometry.size.width * viewModel.progressFraction, height: 3)
                    .animation(.alcheDefault, value: viewModel.progressFraction)
            }
        }
        .frame(height: 3)
    }

    // MARK: - Single Select Options

    @ViewBuilder
    private func singleSelectOptions(_ question: QuestionnaireQuestion) -> some View {
        VStack(spacing: AlcheSpacing.sm) {
            ForEach(question.options) { option in
                Button {
                    withAnimation(.alcheDefault) {
                        viewModel.selectOption(option.id)
                    }
                } label: {
                    HStack(spacing: AlcheSpacing.md) {
                        if let icon = option.icon {
                            Image(systemName: icon)
                                .font(.alcheBody)
                                .foregroundStyle(Color.alchePrimary)
                                .frame(width: 24)
                        }

                        Text(option.label)
                            .font(.alcheBody)
                            .foregroundStyle(Color.alchePrimaryText)

                        Spacer()
                    }
                    .padding(AlcheSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.alcheSurface)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: AlcheRadii.md)
                            .stroke(Color.alcheEditorialBlack.opacity(0.08), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Multi Select Options

    @ViewBuilder
    private func multiSelectOptions(_ question: QuestionnaireQuestion) -> some View {
        let selected = viewModel.currentSelectedOptionIds
        let maxLabel = question.maxSelections.map { "Select up to \($0)" } ?? "Select all that apply"

        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            Text(maxLabel)
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheEditorialMuted)

            ForEach(question.options) { option in
                let isOptionSelected = selected.contains(option.id)

                Button {
                    withAnimation(.alcheDefault) {
                        viewModel.selectOption(option.id)
                    }
                } label: {
                    HStack(spacing: AlcheSpacing.md) {
                        if let icon = option.icon {
                            Image(systemName: icon)
                                .font(.alcheBody)
                                .foregroundStyle(isOptionSelected ? Color.alchePrimary : Color.alcheEditorialMuted)
                                .frame(width: 24)
                        }

                        Text(option.label)
                            .font(.alcheBody)
                            .foregroundStyle(Color.alchePrimaryText)

                        Spacer()

                        if isOptionSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.alchePrimary)
                        }
                    }
                    .padding(AlcheSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(isOptionSelected ? Color.alchePrimary.opacity(0.04) : Color.alcheSurface)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: AlcheRadii.md)
                            .stroke(
                                isOptionSelected ? Color.alchePrimary : Color.alcheEditorialBlack.opacity(0.08),
                                lineWidth: isOptionSelected ? 2 : 1
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Slider Input

    @ViewBuilder
    private func sliderInput(_ question: QuestionnaireQuestion) -> some View {
        let sliderMin = Double(question.sliderMin ?? 1)
        let sliderMax = Double(question.sliderMax ?? 10)

        VStack(spacing: AlcheSpacing.lg) {
            // Current value display
            Text("\(Int(viewModel.sliderValue))")
                .font(.alcheMonoLarge)
                .foregroundStyle(Color.alchePrimary)
                .frame(maxWidth: .infinity)

            // Slider
            Slider(value: $viewModel.sliderValue, in: sliderMin...sliderMax, step: 1)
                .tint(Color.alchePrimary)

            // Min/Max labels
            HStack {
                Text(question.sliderMinLabel ?? "\(Int(sliderMin))")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheEditorialMuted)

                Spacer()

                Text(question.sliderMaxLabel ?? "\(Int(sliderMax))")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
        }
        .padding(.top, AlcheSpacing.lg)
    }

    // MARK: - Continue Buttons

    private var multiSelectContinueButton: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.alcheEditorialBlack.opacity(0.06))
                .frame(height: 1)

            AlcheButton("Continue", style: .primary, isFullWidth: true) {
                withAnimation(.alcheDefault) {
                    viewModel.confirmMultiSelect()
                }
            }
            .disabled(!viewModel.canContinueMultiSelect)
            .opacity(viewModel.canContinueMultiSelect ? 1 : 0.4)
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.vertical, AlcheSpacing.md)
        }
        .background(Color.alcheBackground)
    }

    private var sliderContinueButton: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.alcheEditorialBlack.opacity(0.06))
                .frame(height: 1)

            AlcheButton("Continue", style: .primary, isFullWidth: true) {
                withAnimation(.alcheDefault) {
                    viewModel.confirmSlider()
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.vertical, AlcheSpacing.md)
        }
        .background(Color.alcheBackground)
    }

    // MARK: - Section Transition

    private var sectionTransitionScreen: some View {
        VStack(spacing: AlcheSpacing.lg) {
            Spacer()

            // Section icon
            Image(systemName: sectionIcon(for: viewModel.currentSectionName))
                .font(.system(size: 40))
                .foregroundStyle(Color.alchePrimary)

            Text(viewModel.currentSectionName)
                .font(.alcheDisplayL)
                .foregroundStyle(Color.alchePrimaryText)
                .multilineTextAlignment(.center)

            // Section position
            if let idx = DeepProfileViewModel.sectionOrder.firstIndex(of: viewModel.currentSectionName) {
                Text("Section \(idx + 1) of \(DeepProfileViewModel.sectionOrder.count)")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .transition(.opacity)
    }

    private func sectionIcon(for section: String) -> String {
        switch section {
        case "Body & Symptoms": return "figure.stand"
        case "Lifestyle Patterns": return "sun.max"
        case "Skin & Appearance": return "sparkles"
        case "Goals & Preferences": return "target"
        default: return "circle"
        }
    }

    // MARK: - Completion Screen

    private var completionScreen: some View {
        VStack(spacing: AlcheSpacing.xl) {
            Spacer()

            Image(systemName: "checkmark.circle")
                .font(.system(size: 64))
                .foregroundStyle(Color.alchePastelSage)

            VStack(spacing: AlcheSpacing.md) {
                Text("Profile Complete")
                    .font(.alcheDisplayL)
                    .foregroundStyle(Color.alchePrimaryText)

                Text("Your protocols are now fine-tuned")
                    .font(.alcheBody)
                    .foregroundStyle(Color.alcheEditorialMuted)
                    .multilineTextAlignment(.center)
            }

            // Personalization level indicator
            VStack(spacing: AlcheSpacing.sm) {
                Text("PERSONALIZATION")
                    .font(.alcheOverline)
                    .tracking(1)
                    .foregroundStyle(Color.alcheEditorialMuted)

                // Progress bar showing personalization
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: AlcheRadii.full)
                            .fill(Color.alcheEditorialBlack.opacity(0.06))

                        RoundedRectangle(cornerRadius: AlcheRadii.full)
                            .fill(Color.alchePrimary)
                            .frame(width: geometry.size.width * 0.72) // deep profile completion adds significant %
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, AlcheSpacing.xl)

                Text("72% personalized")
                    .font(.alcheMono)
                    .foregroundStyle(Color.alchePrimary)
            }
            .padding(.top, AlcheSpacing.lg)

            Spacer()

            AlcheButton("Done") {
                dismiss()
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.bottom, AlcheSpacing.xl)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DeepProfileView()
    }
}
