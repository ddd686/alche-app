import Foundation

protocol FavoritesServiceProtocol: Sendable {
    func favorites(userId: UUID) async throws -> [Favorite]
    func favorites(userId: UUID, type: FavoriteType) async throws -> [Favorite]
    func addFavorite(userId: UUID, itemId: UUID, type: FavoriteType) async throws -> Favorite
    func removeFavorite(id: UUID) async throws
    func isFavorited(userId: UUID, itemId: UUID) async throws -> Bool
}
