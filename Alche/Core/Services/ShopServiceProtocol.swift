import Foundation

protocol ShopServiceProtocol: Sendable {
    func allProducts() async throws -> [Product]
    func products(category: ProductCategory) async throws -> [Product]
    func product(id: UUID) async throws -> Product
    func menuItems() async throws -> [MenuItem]
    func menuItems(goal: SmoothieGoal) async throws -> [MenuItem]
    func createOrder(items: [OrderItem], orderType: OrderType, pickupType: PickupType) async throws -> Order
    func orders(userId: UUID) async throws -> [Order]
    func order(id: UUID) async throws -> Order
    func cancelOrder(id: UUID) async throws
}
