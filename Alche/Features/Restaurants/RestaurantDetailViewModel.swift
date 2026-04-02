import Foundation

@Observable
@MainActor
final class RestaurantDetailViewModel {
    let restaurant: PartnerRestaurant
    var dishes: [RestaurantDish] = []
    var nutritionalProfiles: [UUID: NutritionalProfile] = [:]
    var selectedCategory: DishCategory?
    var isLoading = false
    var errorMessage: String?

    private let service: RestaurantServiceProtocol = MockRestaurantService()

    init(restaurant: PartnerRestaurant) {
        self.restaurant = restaurant
    }

    var filteredDishes: [RestaurantDish] {
        guard let category = selectedCategory else {
            return dishes
        }
        return dishes.filter { $0.category == category }
    }

    var categories: [DishCategory] {
        Array(Set(dishes.map(\.category))).sorted { $0.rawValue < $1.rawValue }
    }

    func loadMenu() async {
        isLoading = true
        errorMessage = nil
        do {
            dishes = try await service.dishes(restaurantId: restaurant.id)

            // Load nutritional profiles for all dishes
            for dish in dishes {
                if let profile = try? await service.nutritionalProfile(dishId: dish.id) {
                    nutritionalProfiles[dish.id] = profile
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func nutritionalProfile(for dish: RestaurantDish) -> NutritionalProfile? {
        nutritionalProfiles[dish.id]
    }
}
