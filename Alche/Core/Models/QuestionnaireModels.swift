import Foundation

// MARK: - Questionnaire Tier

enum QuestionnaireTier: String, Codable, Sendable {
    case quickScan   // Tier 1: 7 questions, 2 min, onboarding
    case deepProfile // Tier 2: 18 questions, 5 min, optional after first week
}

// MARK: - Answer Option

struct AnswerOption: Codable, Sendable, Hashable, Identifiable {
    let id: String
    let label: String
    let icon: String?

    init(id: String, label: String, icon: String? = nil) {
        self.id = id
        self.label = label
        self.icon = icon
    }
}

// MARK: - Question Format

enum QuestionFormat: String, Codable, Sendable {
    case singleSelect
    case multiSelect   // max selections defined per question
    case numberInput
    case slider
    case timePicker
    case freeText
}

// MARK: - Question

struct QuestionnaireQuestion: Codable, Sendable, Hashable, Identifiable {
    let id: String
    let tier: QuestionnaireTier
    let section: String?
    let questionText: String
    let format: QuestionFormat
    let options: [AnswerOption]
    let maxSelections: Int?
    let sliderMin: Int?
    let sliderMax: Int?
    let sliderMinLabel: String?
    let sliderMaxLabel: String?

    init(
        id: String,
        tier: QuestionnaireTier,
        section: String? = nil,
        questionText: String,
        format: QuestionFormat,
        options: [AnswerOption] = [],
        maxSelections: Int? = nil,
        sliderMin: Int? = nil,
        sliderMax: Int? = nil,
        sliderMinLabel: String? = nil,
        sliderMaxLabel: String? = nil
    ) {
        self.id = id
        self.tier = tier
        self.section = section
        self.questionText = questionText
        self.format = format
        self.options = options
        self.maxSelections = maxSelections
        self.sliderMin = sliderMin
        self.sliderMax = sliderMax
        self.sliderMinLabel = sliderMinLabel
        self.sliderMaxLabel = sliderMaxLabel
    }
}

// MARK: - Answer

struct QuestionnaireAnswer: Codable, Sendable, Hashable, Identifiable {
    let id: UUID
    let questionId: String
    var selectedOptionIds: [String]
    var numericValue: Int?
    var textValue: String?
    let answeredAt: Date

    init(
        id: UUID = UUID(),
        questionId: String,
        selectedOptionIds: [String] = [],
        numericValue: Int? = nil,
        textValue: String? = nil,
        answeredAt: Date = Date()
    ) {
        self.id = id
        self.questionId = questionId
        self.selectedOptionIds = selectedOptionIds
        self.numericValue = numericValue
        self.textValue = textValue
        self.answeredAt = answeredAt
    }
}

// MARK: - User Profile (aggregated from answers)

struct UserWellnessProfile: Codable, Sendable, Hashable {
    var selectedGoals: Set<WellnessGoal>
    var quickScanAnswers: [QuestionnaireAnswer]
    var deepProfileAnswers: [QuestionnaireAnswer]
    var personalizationLevel: Int // 0-100

    init(
        selectedGoals: Set<WellnessGoal> = [],
        quickScanAnswers: [QuestionnaireAnswer] = [],
        deepProfileAnswers: [QuestionnaireAnswer] = [],
        personalizationLevel: Int = 0
    ) {
        self.selectedGoals = selectedGoals
        self.quickScanAnswers = quickScanAnswers
        self.deepProfileAnswers = deepProfileAnswers
        self.personalizationLevel = personalizationLevel
    }

    var hasCompletedQuickScan: Bool {
        quickScanAnswers.count >= 7
    }

    var hasCompletedDeepProfile: Bool {
        deepProfileAnswers.count >= 18
    }
}
