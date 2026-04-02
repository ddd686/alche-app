import Foundation

final class MockQuestionnaireService: QuestionnaireServiceProtocol, @unchecked Sendable {
    private let answersKey = "alche_questionnaire_answers"

    func questions(for tier: QuestionnaireTier) async throws -> [QuestionnaireQuestion] {
        try await Task.sleep(for: .milliseconds(300))
        switch tier {
        case .quickScan: return Self.quickScanQuestions
        case .deepProfile: return Self.deepProfileQuestions
        }
    }

    func saveAnswer(_ answer: QuestionnaireAnswer, userId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(200))
        var existing = loadAnswers(userId: userId)
        existing.removeAll { $0.questionId == answer.questionId }
        existing.append(answer)
        persistAnswers(existing, userId: userId)
    }

    func savedAnswers(userId: UUID, tier: QuestionnaireTier) async throws -> [QuestionnaireAnswer] {
        try await Task.sleep(for: .milliseconds(200))
        let all = loadAnswers(userId: userId)
        let tierQuestionIds = Set((tier == .quickScan ? Self.quickScanQuestions : Self.deepProfileQuestions).map(\.id))
        return all.filter { tierQuestionIds.contains($0.questionId) }
    }

    func userProfile(userId: UUID) async throws -> UserWellnessProfile {
        try await Task.sleep(for: .milliseconds(300))
        let all = loadAnswers(userId: userId)
        let quickIds = Set(Self.quickScanQuestions.map(\.id))
        let deepIds = Set(Self.deepProfileQuestions.map(\.id))

        let quickAnswers = all.filter { quickIds.contains($0.questionId) }
        let deepAnswers = all.filter { deepIds.contains($0.questionId) }

        let goals = Set(computeGoalRecommendations(from: quickAnswers))
        let level = min(100, quickAnswers.count * 6 + deepAnswers.count * 3)

        return UserWellnessProfile(
            selectedGoals: goals,
            quickScanAnswers: quickAnswers,
            deepProfileAnswers: deepAnswers,
            personalizationLevel: level
        )
    }

    func computeGoalRecommendations(from answers: [QuestionnaireAnswer]) -> [WellnessGoal] {
        // Q1 "What brought you to Alche?" maps directly to goals
        guard let q1 = answers.first(where: { $0.questionId == "q1" }) else {
            return [.cellularVitality, .stressResilience]
        }

        var goals: [WellnessGoal] = []
        for optionId in q1.selectedOptionIds {
            switch optionId {
            case "energy": goals.append(.cellularVitality)
            case "skin": goals.append(.radiantDefense)
            case "sleep", "recovery": goals.append(.deepRecovery)
            case "stress", "calm": goals.append(.stressResilience)
            case "gut": goals.append(.innerBalance)
            case "longevity", "aging": goals.append(.cellularVitality)
            case "weight", "body": goals.append(.innerBalance)
            case "clarity": goals.append(.stressResilience)
            default: break
            }
        }

        // Ensure at least 2 goals
        if goals.isEmpty { goals = [.cellularVitality, .stressResilience] }
        if goals.count == 1 { goals.append(.deepRecovery) }

        // Deduplicate preserving order
        var seen = Set<WellnessGoal>()
        return goals.filter { seen.insert($0).inserted }
    }

    // MARK: - Persistence

    private func loadAnswers(userId: UUID) -> [QuestionnaireAnswer] {
        guard let data = UserDefaults.standard.data(forKey: "\(answersKey)_\(userId.uuidString)"),
              let answers = try? JSONDecoder().decode([QuestionnaireAnswer].self, from: data) else {
            return []
        }
        return answers
    }

    private func persistAnswers(_ answers: [QuestionnaireAnswer], userId: UUID) {
        if let data = try? JSONEncoder().encode(answers) {
            UserDefaults.standard.set(data, forKey: "\(answersKey)_\(userId.uuidString)")
        }
    }

    // MARK: - Quick Scan Questions (Tier 1)

    static let quickScanQuestions: [QuestionnaireQuestion] = [
        QuestionnaireQuestion(
            id: "q1",
            tier: .quickScan,
            questionText: "What brought you to Alche?",
            format: .multiSelect,
            options: [
                AnswerOption(id: "energy", label: "Energy & vitality", icon: "bolt.fill"),
                AnswerOption(id: "skin", label: "Skin & appearance", icon: "sparkles"),
                AnswerOption(id: "sleep", label: "Sleep & recovery", icon: "moon.fill"),
                AnswerOption(id: "stress", label: "Stress & calm", icon: "leaf.fill"),
                AnswerOption(id: "gut", label: "Gut health", icon: "circle.grid.cross.fill"),
                AnswerOption(id: "longevity", label: "Longevity & aging well", icon: "heart.fill"),
                AnswerOption(id: "weight", label: "Weight & body composition", icon: "figure.walk"),
                AnswerOption(id: "clarity", label: "Mental clarity", icon: "brain.head.profile"),
            ],
            maxSelections: 3
        ),
        QuestionnaireQuestion(
            id: "q2",
            tier: .quickScan,
            questionText: "How old are you?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "20s", label: "20s"),
                AnswerOption(id: "30s", label: "30s"),
                AnswerOption(id: "40s", label: "40s"),
                AnswerOption(id: "50plus", label: "50+"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q3",
            tier: .quickScan,
            questionText: "How would you describe your energy on a typical day?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "strong", label: "Consistently strong", icon: "battery.100"),
                AnswerOption(id: "dips", label: "Good mornings, afternoon dip", icon: "battery.75"),
                AnswerOption(id: "unpredictable", label: "Unpredictable — some days great, some terrible", icon: "battery.50"),
                AnswerOption(id: "low", label: "Running on fumes most days", icon: "battery.25"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q4",
            tier: .quickScan,
            questionText: "What does your movement look like?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "intense", label: "I train 4+ times/week", icon: "figure.run"),
                AnswerOption(id: "regular", label: "I move regularly (walks, yoga, 2-3x gym)", icon: "figure.walk"),
                AnswerOption(id: "inconsistent", label: "I want to move more but struggle", icon: "figure.stand"),
                AnswerOption(id: "sedentary", label: "I'm mostly sedentary right now", icon: "chair.fill"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q5",
            tier: .quickScan,
            questionText: "How do you eat, roughly?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "well", label: "I eat well and enjoy cooking"),
                AnswerOption(id: "okay", label: "I eat okay but it's inconsistent"),
                AnswerOption(id: "convenience", label: "I rely on convenience food more than I'd like"),
                AnswerOption(id: "specific", label: "I follow a specific diet"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q6",
            tier: .quickScan,
            questionText: "How's your sleep?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "great", label: "I sleep well and wake rested", icon: "moon.stars.fill"),
                AnswerOption(id: "decent", label: "I sleep enough but don't feel refreshed", icon: "moon.fill"),
                AnswerOption(id: "struggle", label: "I struggle to fall or stay asleep", icon: "moon.haze.fill"),
                AnswerOption(id: "chaotic", label: "My sleep is chaotic", icon: "moon.circle"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q7",
            tier: .quickScan,
            questionText: "How much do you already know about longevity and wellness?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "curious", label: "I'm curious but new to this"),
                AnswerOption(id: "basics", label: "I know the basics and want to go deeper"),
                AnswerOption(id: "optimizing", label: "I'm already optimizing — show me what's next"),
                AnswerOption(id: "skeptical", label: "I'm skeptical but open"),
            ]
        ),
    ]

    // MARK: - Deep Profile Questions (Tier 2)

    static let deepProfileQuestions: [QuestionnaireQuestion] = [
        // Section A: Body & Symptoms
        QuestionnaireQuestion(
            id: "q8",
            tier: .deepProfile,
            section: "Body & Symptoms",
            questionText: "Do you experience any of these regularly?",
            format: .multiSelect,
            options: [
                AnswerOption(id: "energy_crash", label: "Afternoon energy crashes"),
                AnswerOption(id: "brain_fog", label: "Brain fog or difficulty concentrating"),
                AnswerOption(id: "bloating", label: "Bloating or digestive discomfort"),
                AnswerOption(id: "skin_issues", label: "Skin dullness, dryness, or breakouts"),
                AnswerOption(id: "joint_stiffness", label: "Joint stiffness or muscle soreness"),
                AnswerOption(id: "frequent_colds", label: "Frequent colds or slow recovery"),
                AnswerOption(id: "mood_swings", label: "Mood swings or irritability"),
                AnswerOption(id: "none", label: "None of these"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q9",
            tier: .deepProfile,
            section: "Body & Symptoms",
            questionText: "How would you rate your stress right now?",
            format: .slider,
            sliderMin: 1,
            sliderMax: 10,
            sliderMinLabel: "Very calm",
            sliderMaxLabel: "Overwhelmed"
        ),
        QuestionnaireQuestion(
            id: "q10",
            tier: .deepProfile,
            section: "Body & Symptoms",
            questionText: "Any conditions a practitioner has diagnosed?",
            format: .multiSelect,
            options: [
                AnswerOption(id: "thyroid", label: "Thyroid issues"),
                AnswerOption(id: "autoimmune", label: "Autoimmune condition"),
                AnswerOption(id: "pcos", label: "PCOS/hormonal imbalance"),
                AnswerOption(id: "digestive", label: "Digestive condition (IBS, SIBO)"),
                AnswerOption(id: "anxiety_depression", label: "Anxiety or depression"),
                AnswerOption(id: "none", label: "None"),
                AnswerOption(id: "prefer_not", label: "Prefer not to say"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q11",
            tier: .deepProfile,
            section: "Body & Symptoms",
            questionText: "Are you currently pregnant, breastfeeding, or trying to conceive?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "yes", label: "Yes"),
                AnswerOption(id: "no", label: "No"),
                AnswerOption(id: "prefer_not", label: "Prefer not to say"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q12",
            tier: .deepProfile,
            section: "Body & Symptoms",
            questionText: "Do you take any medications or supplements currently?",
            format: .multiSelect,
            options: [
                AnswerOption(id: "birth_control", label: "Birth control"),
                AnswerOption(id: "thyroid_med", label: "Thyroid medication"),
                AnswerOption(id: "antidepressants", label: "Antidepressants"),
                AnswerOption(id: "blood_pressure", label: "Blood pressure medication"),
                AnswerOption(id: "supplements", label: "I take supplements"),
                AnswerOption(id: "none", label: "None"),
            ]
        ),
        // Section B: Lifestyle Patterns
        QuestionnaireQuestion(
            id: "q13",
            tier: .deepProfile,
            section: "Lifestyle Patterns",
            questionText: "What time do you typically wake up?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "before_6", label: "Before 6 AM"),
                AnswerOption(id: "6_7", label: "6-7 AM"),
                AnswerOption(id: "7_8", label: "7-8 AM"),
                AnswerOption(id: "8_9", label: "8-9 AM"),
                AnswerOption(id: "after_9", label: "After 9 AM"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q14",
            tier: .deepProfile,
            section: "Lifestyle Patterns",
            questionText: "How much time do you spend outdoors on a typical day?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "under_30", label: "Less than 30 minutes"),
                AnswerOption(id: "30_60", label: "30-60 minutes"),
                AnswerOption(id: "1_2hr", label: "1-2 hours"),
                AnswerOption(id: "over_2hr", label: "2+ hours"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q15",
            tier: .deepProfile,
            section: "Lifestyle Patterns",
            questionText: "How much water do you drink daily?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "forget", label: "I forget to drink water"),
                AnswerOption(id: "3_5", label: "3-5 glasses"),
                AnswerOption(id: "6_8", label: "6-8 glasses"),
                AnswerOption(id: "8_plus", label: "8+ glasses or I track it"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q16",
            tier: .deepProfile,
            section: "Lifestyle Patterns",
            questionText: "How often do you drink alcohol?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "never", label: "Never"),
                AnswerOption(id: "occasionally", label: "Occasionally (1-2x/month)"),
                AnswerOption(id: "regularly", label: "Regularly (1-2x/week)"),
                AnswerOption(id: "most_days", label: "Most days"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q17",
            tier: .deepProfile,
            section: "Lifestyle Patterns",
            questionText: "Screen time before bed?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "until_sleep", label: "I'm on screens until I fall asleep"),
                AnswerOption(id: "30_before", label: "I try to stop 30 min before"),
                AnswerOption(id: "strict", label: "I have a strict wind-down routine"),
                AnswerOption(id: "no_track", label: "I don't track this"),
            ]
        ),
        // Section C: Skin & Appearance
        QuestionnaireQuestion(
            id: "q18",
            tier: .deepProfile,
            section: "Skin & Appearance",
            questionText: "What's your biggest skin concern right now?",
            format: .multiSelect,
            options: [
                AnswerOption(id: "dullness", label: "Dullness or tired-looking skin"),
                AnswerOption(id: "dryness", label: "Dryness or dehydration"),
                AnswerOption(id: "breakouts", label: "Breakouts or blemishes"),
                AnswerOption(id: "fine_lines", label: "Fine lines or texture"),
                AnswerOption(id: "uneven_tone", label: "Uneven tone or dark spots"),
                AnswerOption(id: "redness", label: "Redness or sensitivity"),
                AnswerOption(id: "none", label: "None — my skin is fine"),
            ],
            maxSelections: 2
        ),
        QuestionnaireQuestion(
            id: "q19",
            tier: .deepProfile,
            section: "Skin & Appearance",
            questionText: "How would you describe your skin type?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "oily", label: "Oily"),
                AnswerOption(id: "dry", label: "Dry"),
                AnswerOption(id: "combination", label: "Combination"),
                AnswerOption(id: "sensitive", label: "Sensitive"),
                AnswerOption(id: "normal", label: "Normal"),
                AnswerOption(id: "unknown", label: "I don't know"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q20",
            tier: .deepProfile,
            section: "Skin & Appearance",
            questionText: "Do you currently have a skincare routine?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "consistent", label: "Consistent daily routine"),
                AnswerOption(id: "sometimes", label: "Sometimes"),
                AnswerOption(id: "basics", label: "Just basics (cleanser + moisturizer)"),
                AnswerOption(id: "not_really", label: "Not really"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q21",
            tier: .deepProfile,
            section: "Skin & Appearance",
            questionText: "How much sun exposure does your skin get?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "minimal", label: "Minimal (mostly indoors)"),
                AnswerOption(id: "moderate", label: "Moderate"),
                AnswerOption(id: "regular", label: "Regular (outdoor work/exercise)"),
                AnswerOption(id: "sun_seek", label: "I actively sun-seek"),
            ]
        ),
        // Section D: Goals & Preferences
        QuestionnaireQuestion(
            id: "q22",
            tier: .deepProfile,
            section: "Goals & Preferences",
            questionText: "What does 'aging well' mean to you?",
            format: .multiSelect,
            options: [
                AnswerOption(id: "energetic", label: "Staying energetic and active"),
                AnswerOption(id: "looking_good", label: "Looking as good as I feel"),
                AnswerOption(id: "mind_sharp", label: "Keeping my mind sharp"),
                AnswerOption(id: "avoid_disease", label: "Avoiding chronic disease"),
                AnswerOption(id: "independent", label: "Staying independent as long as possible"),
                AnswerOption(id: "community", label: "Being part of a community that cares about this"),
            ],
            maxSelections: 3
        ),
        QuestionnaireQuestion(
            id: "q23",
            tier: .deepProfile,
            section: "Goals & Preferences",
            questionText: "How do you prefer to build new habits?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "checklist", label: "Give me a daily checklist"),
                AnswerOption(id: "suggest", label: "Suggest things and let me choose"),
                AnswerOption(id: "track", label: "Just track what I'm already doing"),
                AnswerOption(id: "accountability", label: "I need accountability (remind me, nudge me)"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q24",
            tier: .deepProfile,
            section: "Goals & Preferences",
            questionText: "Budget for wellness monthly?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "under_50", label: "Under \u{20AC}50"),
                AnswerOption(id: "50_100", label: "\u{20AC}50-100"),
                AnswerOption(id: "100_200", label: "\u{20AC}100-200"),
                AnswerOption(id: "200_plus", label: "\u{20AC}200+"),
                AnswerOption(id: "no_track", label: "I don't track this"),
            ]
        ),
        QuestionnaireQuestion(
            id: "q25",
            tier: .deepProfile,
            section: "Goals & Preferences",
            questionText: "Would you be open to biological testing for deeper personalization?",
            format: .singleSelect,
            options: [
                AnswerOption(id: "very_interested", label: "Yes, very interested"),
                AnswerOption(id: "maybe", label: "Maybe, if it's easy"),
                AnswerOption(id: "not_now", label: "Not right now"),
                AnswerOption(id: "have_results", label: "I already have results I could share"),
            ]
        ),
    ]
}
