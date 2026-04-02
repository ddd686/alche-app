import Foundation

protocol QuestionnaireServiceProtocol: Sendable {
    func questions(for tier: QuestionnaireTier) async throws -> [QuestionnaireQuestion]
    func saveAnswer(_ answer: QuestionnaireAnswer, userId: UUID) async throws
    func savedAnswers(userId: UUID, tier: QuestionnaireTier) async throws -> [QuestionnaireAnswer]
    func userProfile(userId: UUID) async throws -> UserWellnessProfile
    func computeGoalRecommendations(from answers: [QuestionnaireAnswer]) -> [WellnessGoal]
}
