import Foundation

@Observable
@MainActor
final class DeepProfileViewModel {
    // MARK: - State

    var questions: [QuestionnaireQuestion] = []
    var answers: [String: QuestionnaireAnswer] = [:] // keyed by questionId
    var currentQuestionIndex = 0
    var isLoading = false
    var isComplete = false
    var errorMessage: String?
    var showSectionTransition = false
    var currentSectionName: String = ""

    // Slider state for Q9
    var sliderValue: Double = 5

    private let service: QuestionnaireServiceProtocol = MockQuestionnaireService()
    private let userId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    // MARK: - Computed

    var currentQuestion: QuestionnaireQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var progressFraction: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(questions.count)
    }

    var canGoBack: Bool {
        currentQuestionIndex > 0
    }

    var totalQuestions: Int {
        questions.count
    }

    var answeredCount: Int {
        answers.count
    }

    /// Ordered section names for transitions
    static let sectionOrder = [
        "Body & Symptoms",
        "Lifestyle Patterns",
        "Skin & Appearance",
        "Goals & Preferences"
    ]

    var currentSection: String? {
        currentQuestion?.section
    }

    var isFirstQuestionInSection: Bool {
        guard let current = currentQuestion, let section = current.section else { return false }
        if currentQuestionIndex == 0 { return true }
        let previous = questions[currentQuestionIndex - 1]
        return previous.section != section
    }

    /// Selected option IDs for the current question
    var currentSelectedOptionIds: Set<String> {
        guard let q = currentQuestion,
              let answer = answers[q.id] else { return [] }
        return Set(answer.selectedOptionIds)
    }

    /// Whether Continue can proceed for multiSelect questions
    var canContinueMultiSelect: Bool {
        guard let q = currentQuestion else { return false }
        return !currentSelectedOptionIds.isEmpty && q.format == .multiSelect
    }

    // MARK: - Load

    func loadQuestions() async {
        isLoading = true
        errorMessage = nil

        do {
            questions = try await service.questions(for: .deepProfile)

            // Load saved answers to resume
            let saved = try await service.savedAnswers(userId: userId, tier: .deepProfile)
            for answer in saved {
                answers[answer.questionId] = answer
            }

            // Resume from where left off
            if !saved.isEmpty {
                let answeredIds = Set(saved.map(\.questionId))
                if let firstUnanswered = questions.firstIndex(where: { !answeredIds.contains($0.id) }) {
                    currentQuestionIndex = firstUnanswered
                } else {
                    // All answered
                    isComplete = true
                }
            }

            // Initialize slider value if Q9 has a saved answer
            if let q9Answer = answers["q9"], let numeric = q9Answer.numericValue {
                sliderValue = Double(numeric)
            }
        } catch {
            errorMessage = "Failed to load questions."
        }

        isLoading = false
    }

    // MARK: - Answer Actions

    func selectOption(_ optionId: String) {
        guard let q = currentQuestion else { return }

        switch q.format {
        case .singleSelect:
            let answer = QuestionnaireAnswer(
                questionId: q.id,
                selectedOptionIds: [optionId]
            )
            answers[q.id] = answer
            saveAndAdvance(answer)

        case .multiSelect:
            var existing = answers[q.id]?.selectedOptionIds ?? []
            if existing.contains(optionId) {
                existing.removeAll { $0 == optionId }
            } else {
                let max = q.maxSelections ?? 99
                if existing.count < max {
                    existing.append(optionId)
                }
            }
            let answer = QuestionnaireAnswer(
                questionId: q.id,
                selectedOptionIds: existing
            )
            answers[q.id] = answer
            // Don't auto-advance for multiSelect

        default:
            break
        }
    }

    func confirmMultiSelect() {
        guard let q = currentQuestion, let answer = answers[q.id] else { return }
        saveAndAdvance(answer)
    }

    func confirmSlider() {
        guard let q = currentQuestion else { return }
        let answer = QuestionnaireAnswer(
            questionId: q.id,
            numericValue: Int(sliderValue)
        )
        answers[q.id] = answer
        saveAndAdvance(answer)
    }

    func goBack() {
        guard canGoBack else { return }
        showSectionTransition = false
        currentQuestionIndex -= 1

        // Restore slider value if going back to slider question
        if let q = currentQuestion, q.format == .slider {
            if let saved = answers[q.id]?.numericValue {
                sliderValue = Double(saved)
            } else {
                sliderValue = Double((q.sliderMin ?? 1 + (q.sliderMax ?? 10)) / 2)
            }
        }
    }

    // MARK: - Private

    private func saveAndAdvance(_ answer: QuestionnaireAnswer) {
        Task {
            try? await service.saveAnswer(answer, userId: userId)
        }

        if currentQuestionIndex < questions.count - 1 {
            let nextIndex = currentQuestionIndex + 1
            let nextQuestion = questions[nextIndex]

            // Check if entering a new section
            if let nextSection = nextQuestion.section,
               nextSection != currentQuestion?.section {
                currentSectionName = nextSection
                showSectionTransition = true

                // Auto-dismiss section transition after a delay
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(1.2))
                    showSectionTransition = false
                    currentQuestionIndex = nextIndex

                    // Initialize slider if next question is slider
                    if nextQuestion.format == .slider {
                        if let saved = answers[nextQuestion.id]?.numericValue {
                            sliderValue = Double(saved)
                        } else {
                            sliderValue = Double((nextQuestion.sliderMin ?? 1 + (nextQuestion.sliderMax ?? 10)) / 2)
                        }
                    }
                }
            } else {
                currentQuestionIndex = nextIndex

                // Initialize slider if next question is slider
                if nextQuestion.format == .slider {
                    if let saved = answers[nextQuestion.id]?.numericValue {
                        sliderValue = Double(saved)
                    } else {
                        sliderValue = Double((nextQuestion.sliderMin ?? 1 + (nextQuestion.sliderMax ?? 10)) / 2)
                    }
                }
            }
        } else {
            // Completed all questions
            isComplete = true
        }
    }
}
