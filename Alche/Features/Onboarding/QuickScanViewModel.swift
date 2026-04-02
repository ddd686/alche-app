import Foundation

@Observable
@MainActor
final class QuickScanViewModel {
    // MARK: - State

    var questions: [QuestionnaireQuestion] = []
    var answers: [String: QuestionnaireAnswer] = [:] // questionId -> answer
    var currentQuestionIndex: Int = 0
    var isLoading = false
    var errorMessage: String?
    var showMicroInsight = false
    var microInsightText: String = ""

    private let service: QuestionnaireServiceProtocol = MockQuestionnaireService()
    private let userId = UUID() // placeholder until auth wired

    // MARK: - Persistence Keys

    private let savedIndexKey = "alche_quickscan_current_index"

    // MARK: - Computed

    var totalQuestions: Int { questions.count }

    var currentQuestion: QuestionnaireQuestion? {
        guard currentQuestionIndex >= 0, currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var progressFraction: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentQuestionIndex) / Double(totalQuestions)
    }

    var isFirstQuestion: Bool { currentQuestionIndex == 0 }

    var isLastQuestion: Bool { currentQuestionIndex == totalQuestions - 1 }

    var isQuizComplete: Bool {
        guard totalQuestions > 0 else { return false }
        return answers.count >= totalQuestions
    }

    var allAnswers: [QuestionnaireAnswer] {
        Array(answers.values)
    }

    // MARK: - Selection State

    func selectedOptionIds(for questionId: String) -> Set<String> {
        guard let answer = answers[questionId] else { return [] }
        return Set(answer.selectedOptionIds)
    }

    func isOptionSelected(_ optionId: String, for questionId: String) -> Bool {
        selectedOptionIds(for: questionId).contains(optionId)
    }

    func selectionCount(for questionId: String) -> Int {
        answers[questionId]?.selectedOptionIds.count ?? 0
    }

    // MARK: - Actions

    func loadQuestions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            questions = try await service.questions(for: .quickScan)

            // Resume from saved position
            let savedIndex = UserDefaults.standard.integer(forKey: savedIndexKey)
            if savedIndex > 0, savedIndex < questions.count {
                // Load any existing answers
                let savedAnswers = try await service.savedAnswers(userId: userId, tier: .quickScan)
                for answer in savedAnswers {
                    answers[answer.questionId] = answer
                }
                currentQuestionIndex = savedIndex
            }
        } catch {
            errorMessage = "Failed to load questions."
        }
    }

    func selectOption(_ optionId: String, for question: QuestionnaireQuestion) {
        switch question.format {
        case .singleSelect:
            handleSingleSelect(optionId, for: question)
        case .multiSelect:
            handleMultiSelect(optionId, for: question)
        default:
            break
        }
    }

    func goBack() {
        guard currentQuestionIndex > 0 else { return }
        showMicroInsight = false
        currentQuestionIndex -= 1
        saveProgress()
    }

    func advanceToNext() {
        guard currentQuestionIndex < totalQuestions - 1 else { return }
        currentQuestionIndex += 1
        saveProgress()

        // Show micro-insight after Q4 (index 3 -> moving to index 4)
        if currentQuestionIndex == 4 {
            generateMicroInsight()
        }
    }

    func confirmMultiSelect(for question: QuestionnaireQuestion) {
        guard selectionCount(for: question.id) > 0 else { return }
        saveAnswer(for: question)
        advanceToNext()
    }

    // MARK: - Private

    private func handleSingleSelect(_ optionId: String, for question: QuestionnaireQuestion) {
        let answer = QuestionnaireAnswer(
            questionId: question.id,
            selectedOptionIds: [optionId]
        )
        answers[question.id] = answer
        saveAnswer(for: question)

        // Auto-advance on single select after brief delay
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(350))
            if currentQuestionIndex < totalQuestions - 1 {
                advanceToNext()
            }
        }
    }

    private func handleMultiSelect(_ optionId: String, for question: QuestionnaireQuestion) {
        var current = answers[question.id]?.selectedOptionIds ?? []
        let maxSelections = question.maxSelections ?? Int.max

        if current.contains(optionId) {
            current.removeAll { $0 == optionId }
        } else {
            guard current.count < maxSelections else { return }
            current.append(optionId)
        }

        let answer = QuestionnaireAnswer(
            questionId: question.id,
            selectedOptionIds: current
        )
        answers[question.id] = answer
    }

    private func saveAnswer(for question: QuestionnaireQuestion) {
        guard let answer = answers[question.id] else { return }
        Task {
            try? await service.saveAnswer(answer, userId: userId)
        }
    }

    private func saveProgress() {
        UserDefaults.standard.set(currentQuestionIndex, forKey: savedIndexKey)
    }

    private func generateMicroInsight() {
        // Build insight based on Q3 (energy) and Q4 (movement) answers
        let energyAnswer = answers["q3"]?.selectedOptionIds.first ?? ""
        let movementAnswer = answers["q4"]?.selectedOptionIds.first ?? ""

        let focusArea: String
        switch (energyAnswer, movementAnswer) {
        case ("strong", "intense"), ("strong", "regular"):
            focusArea = "recovery optimization"
        case ("dips", _), ("unpredictable", _):
            focusArea = "sustained energy protocols"
        case ("low", "sedentary"), ("low", "inconsistent"):
            focusArea = "foundational vitality support"
        case (_, "intense"):
            focusArea = "post-training recovery"
        default:
            focusArea = "personalized wellness protocols"
        }

        microInsightText = "People with your energy + movement profile often see the fastest gains from \(focusArea)."
        showMicroInsight = true

        // Auto-dismiss after 3 seconds
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(3.0))
            showMicroInsight = false
        }
    }

    func clearSavedProgress() {
        UserDefaults.standard.removeObject(forKey: savedIndexKey)
    }
}
