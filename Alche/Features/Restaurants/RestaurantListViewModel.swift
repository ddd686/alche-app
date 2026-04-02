import Foundation

@Observable
@MainActor
final class RestaurantListViewModel {
    var restaurants: [PartnerRestaurant] = []
    var selectedCuisine: CuisineType?
    var searchText = ""
    var isLoading = false
    var errorMessage: String?

    private let service: RestaurantServiceProtocol = MockRestaurantService()

    var filteredRestaurants: [PartnerRestaurant] {
        var results = restaurants.filter(\.isActive)

        if let cuisine = selectedCuisine {
            results = results.filter { $0.cuisineType == cuisine }
        }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            results = results.filter {
                $0.name.lowercased().contains(query) ||
                $0.district.lowercased().contains(query) ||
                $0.cuisineType.displayName.lowercased().contains(query)
            }
        }

        return results.sorted { $0.sortOrder < $1.sortOrder }
    }

    func loadRestaurants() async {
        isLoading = true
        errorMessage = nil
        do {
            restaurants = try await service.allRestaurants()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
