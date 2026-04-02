import Foundation

/// ViewModel for browsing the practitioner roster.
/// Loads all active practitioners and supports filtering by specialty.
@Observable
@MainActor
final class PractitionerListViewModel {

    // MARK: - State

    var practitioners: [Practitioner] = []
    var selectedSpecialty: PractitionerSpecialty?
    var isLoading = false
    var errorMessage: String?

    // MARK: - Service

    private let service: DoctorSessionServiceProtocol = MockDoctorSessionService()

    // MARK: - Computed

    /// Returns practitioners filtered by the selected specialty.
    /// If no specialty is selected, returns all active practitioners.
    var filteredPractitioners: [Practitioner] {
        guard let specialty = selectedSpecialty else {
            return practitioners.filter(\.isActive)
        }
        return practitioners
            .filter(\.isActive)
            .filter { $0.specialties.contains(specialty) }
    }

    /// All unique specialties across all practitioners, for the filter pills.
    var availableSpecialties: [PractitionerSpecialty] {
        PractitionerSpecialty.allCases
    }

    /// Whether there are no results for the current filter.
    var isEmpty: Bool {
        !isLoading && filteredPractitioners.isEmpty
    }

    // MARK: - Actions

    /// Loads all practitioners from the service.
    func loadPractitioners() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            practitioners = try await service.allPractitioners()
        } catch {
            errorMessage = "Unable to load practitioners. Please try again."
        }

        isLoading = false
    }

    /// Sets the specialty filter. Pass `nil` to show all.
    func selectSpecialty(_ specialty: PractitionerSpecialty?) {
        if selectedSpecialty == specialty {
            selectedSpecialty = nil
        } else {
            selectedSpecialty = specialty
        }
    }

    /// Resets all filters and reloads.
    func refresh() async {
        selectedSpecialty = nil
        await loadPractitioners()
    }
}
