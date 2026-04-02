import Foundation

protocol RestaurantServiceProtocol: Sendable {
    func allRestaurants() async throws -> [PartnerRestaurant]
    func restaurants(cuisine: CuisineType) async throws -> [PartnerRestaurant]
    func restaurant(id: UUID) async throws -> PartnerRestaurant
    func dishes(restaurantId: UUID) async throws -> [RestaurantDish]
    func dish(id: UUID) async throws -> RestaurantDish
    func nutritionalProfile(dishId: UUID) async throws -> NutritionalProfile
}
