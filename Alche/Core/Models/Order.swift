import Foundation

enum OrderType: String, Codable, Sendable {
    case shop
    case smoothie
}

enum OrderStatus: String, Codable, Sendable {
    case pending
    case confirmed
    case ready
    case completed
    case cancelled
}

enum PickupType: String, Codable, Sendable {
    case inStore = "in_store"
    case delivery
}

struct OrderItem: Codable, Sendable, Hashable {
    let productId: UUID
    var quantity: Int
    var priceCents: Int
    var name: String?

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case quantity
        case priceCents = "price_cents"
        case name
    }
}

struct Order: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var orderType: OrderType
    var items: [OrderItem]
    var totalCents: Int
    var status: OrderStatus
    var pickupType: PickupType?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case orderType = "order_type"
        case items
        case totalCents = "total_cents"
        case status
        case pickupType = "pickup_type"
        case createdAt = "created_at"
    }

    var formattedTotal: String {
        let euros = Double(totalCents) / 100.0
        return String(format: "%.2f", euros)
    }
}

extension Order {
    static let preview = Order(
        id: UUID(),
        userId: UUID(),
        orderType: .smoothie,
        items: [
            OrderItem(productId: UUID(), quantity: 1, priceCents: 890, name: "Golden Glow")
        ],
        totalCents: 890,
        status: .confirmed,
        pickupType: .inStore,
        createdAt: Date()
    )
}
