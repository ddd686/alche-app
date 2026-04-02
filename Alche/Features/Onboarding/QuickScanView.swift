import SwiftUI

struct QuickScanView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = QuickScanViewModel()
    @State private var questionAppeared = false

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            progressBar
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.top, AlcheSpacing.sm)

            // Back button row
            navigationRow
                .padding(.horizontal, AlcheSpacing.md)
                .padding(.top, AlcheSpacing.sm)

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .tint(Color.alchePrimary)
                Spacer()
            } else if let question = viewModel.currentQuestion {
                questionContent(question)
            }

            // Micro-insight overlay
            if viewModel.showMicroInsight {
                microInsightBanner
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color.alcheBackground)
        .animation(.alcheDefault, value: viewModel.currentQuestionIndex)
        .animation(.alcheDefault, value: viewModel.showMicroInsight)
        .task {
            await viewModel.loadQuestions()
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        VStack(spacing: AlcheSpacing.xs) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.alcheEditorialAccent.opacity(0.3))
                        .frame(height: 2)

                    Rectangle()
                        .fill(Color.alchePrimary)
                        .frame(width: geo.size.width * viewModel.progressFraction, height: 2)
                        .animation(.alcheDefault, value: viewModel.progressFraction)
                }
            }
            .frame(height: 2)

            HStack {
                Spacer()
                Text("\(viewModel.currentQuestionIndex + 1) OF \(viewModel.totalQuestions)")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheEditorialMuted)
                    .tracking(1.5)
            }
        }
    }

    // MARK: - Navigation Row

    private var navigationRow: some View {
        HStack {
            if !viewModel.isFirstQuestion {
                Button {
                    questionAppeared = false
                    viewModel.goBack()
                    withAnimation(.alcheDefault) {
                        questionAppeared = true
                    }
                } label: {
                    HStack(spacing: AlcheSpacing.xs) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 12))
                        Text("BACK")
                            .font(.alcheOverline)
                            .tracking(1.2)
                    }
                    .foregroundStyle(Color.alcheEditorialMuted)
                    .padding(.vertical, AlcheSpacing.sm)
                }
            }
            Spacer()
        }
    }

    // MARK: - Question Content

    @ViewBuilder
    private func questionContent(_ question: QuestionnaireQuestion) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                // Question text
                Text(question.questionText)
                    .font(.alcheDisplayM)
                    .foregroundStyle(Color.alchePrimaryText)
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.top, AlcheSpacing.lg)
                    .opacity(questionAppeared ? 1 : 0)
                    .offset(y: questionAppeared ? 0 : 8)

                // Multi-select count indicator
                if question.format == .multiSelect, let max = question.maxSelections {
                    let count = viewModel.selectionCount(for: question.id)
                    Text("SELECT UP TO \(max) (\(count)/\(max))")
                        .font(.alcheOverline)
                        .tracking(1.5)
                        .foregroundStyle(count >= max ? Color.alchePrimary : Color.alcheEditorialMuted)
                        .padding(.horizontal, AlcheSpacing.lg)
                        .opacity(questionAppeared ? 1 : 0)
                }

                // Answer options
                VStack(spacing: AlcheSpacing.sm) {
                    ForEach(Array(question.options.enumerated()), id: \.element.id) { index, option in
                        answerCard(
                            option: option,
                            question: question,
                            delay: Double(index) * 0.05
                        )
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Continue button for multiSelect
                if question.format == .multiSelect {
                    let count = viewModel.selectionCount(for: question.id)
                    AlcheButton("Continue", style: .primary, isFullWidth: true) {
                        questionAppeared = false
                        viewModel.confirmMultiSelect(for: question)
                        withAnimation(.alcheDefault) {
                            questionAppeared = true
                        }
                    }
                    .disabled(count == 0)
                    .opacity(count > 0 ? 1 : 0.4)
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.top, AlcheSpacing.sm)
                }

                Spacer(minLength: AlcheSpacing.xxl)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                questionAppeared = true
            }
        }
        .onChange(of: viewModel.currentQuestionIndex) { _, _ in
            // Check if quiz is complete after the last question
            if viewModel.isQuizComplete {
                completeQuickScan()
            }
        }
    }

    // MARK: - Answer Card

    private func answerCard(
        option: AnswerOption,
        question: QuestionnaireQuestion,
        delay: Double
    ) -> some View {
        let isSelected = viewModel.isOptionSelected(option.id, for: question.id)

        return Button {
            withAnimation(.alcheDefault) {
                viewModel.selectOption(option.id, for: question)
            }

            // For single select, check completion after auto-advance
            if question.format == .singleSelect {
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(400))
                    if viewModel.isQuizComplete {
                        completeQuickScan()
                    }
                }
            }
        } label: {
            HStack(spacing: AlcheSpacing.md) {
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.alcheBody)
                        .foregroundStyle(isSelected ? Color.alchePrimary : Color.alcheEditorialMuted)
                        .frame(width: 24)
                }

                Text(option.label)
                    .font(.alcheBody)
                    .foregroundStyle(isSelected ? Color.alcheEditorialBlack : Color.alchePrimaryText)
                    .multilineTextAlignment(.leading)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.alchePrimary)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(AlcheSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.alchePrimary.opacity(0.06) : Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.md)
                    .stroke(
                        isSelected ? Color.alchePrimary : Color.alcheEditorialBlack.opacity(0.10),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .opacity(questionAppeared ? 1 : 0)
        .offset(y: questionAppeared ? 0 : 6)
        .animation(
            .easeOut(duration: 0.35).delay(delay),
            value: questionAppeared
        )
    }

    // MARK: - Micro Insight Banner

    private var microInsightBanner: some View {
        VStack(spacing: AlcheSpacing.sm) {
            HStack(spacing: AlcheSpacing.sm) {
                Image(systemName: "sparkles")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alchePrimary)

                Text("INSIGHT")
                    .font(.alcheOverline)
                    .tracking(1.5)
                    .foregroundStyle(Color.alchePrimary)
            }

            Text(viewModel.microInsightText)
                .font(.alcheCaption)
                .foregroundStyle(Color.alchePrimaryText)
                .multilineTextAlignment(.center)
        }
        .padding(AlcheSpacing.md)
        .frame(maxWidth: .infinity)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.md)
                .stroke(Color.alchePrimary.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.bottom, AlcheSpacing.md)
    }

    // MARK: - Completion

    private func completeQuickScan() {
        viewModel.clearSavedProgress()
        appState.userWellnessProfile.quickScanAnswers = viewModel.allAnswers
        appState.onboardingStep = .focusAreaReveal
    }
}

#Preview {
    QuickScanView()
        .environment(AppState())
}
