import Foundation

enum FavoriteType: String, Codable, Sendable {
    case product
    case menuItem = "menu_item"
    case content
}

struct Favorite: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    let userId: UUID
    var itemId: UUID
    var itemType: FavoriteType
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case itemId = "item_id"
        case itemType = "item_type"
        case createdAt = "created_at"
    }
}

extension Favorite {
    static func preview(for productId: UUID) -> Favorite {
        Favorite(
            id: UUID(),
            userId: UUID(),
            itemId: productId,
            itemType: .product,
            createdAt: Date()
        )
    }
}
