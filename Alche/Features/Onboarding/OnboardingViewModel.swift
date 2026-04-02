import Foundation

@Observable
@MainActor
final class OnboardingViewModel {
    // MARK: - State

    var currentPage = 0
    var selectedGoals: Set<ProtocolGoal> = []
    var selectedTier: MembershipTier = .free
    var isLoading = false
    var errorMessage: String?

    let totalPages = 4 // Welcome, Goals, Tier, Complete

    // MARK: - Actions

    func toggleGoal(_ goal: ProtocolGoal) {
        if selectedGoals.contains(goal) {
            selectedGoals.remove(goal)
        } else {
            selectedGoals.insert(goal)
        }
    }

    func nextPage() {
        guard currentPage < totalPages - 1 else { return }
        currentPage += 1
    }

    func previousPage() {
        guard currentPage > 0 else { return }
        currentPage -= 1
    }

    func completeOnboarding() async {
        isLoading = true
        errorMessage = nil

        // TODO: Wire to AuthServiceProtocol — save goals + tier
        try? await Task.sleep(for: .seconds(0.8))

        isLoading = false
    }

    // MARK: - Computed

    var canProceedFromGoals: Bool {
        !selectedGoals.isEmpty
    }

    var progressFraction: Double {
        Double(currentPage) / Double(totalPages - 1)
    }

    var goalsAsStrings: [String] {
        selectedGoals.map(\.rawValue)
    }
}
