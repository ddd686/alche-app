import Foundation

@Observable
@MainActor
final class SmoothieMenuViewModel {
    var menuItems: [MenuItem] = []
    var isLoading = false
    var errorMessage: String?
    var favoriteSmoothieIds: Set<UUID> = []

    // MARK: - Favorites

    func toggleFavorite(_ item: MenuItem) {
        if favoriteSmoothieIds.contains(item.id) {
            favoriteSmoothieIds.remove(item.id)
        } else {
            favoriteSmoothieIds.insert(item.id)
        }
        // TODO: Wire to FavoritesServiceProtocol (FavoriteType.menuItem)
    }

    func isFavorite(_ item: MenuItem) -> Bool {
        favoriteSmoothieIds.contains(item.id)
    }

    var favoriteSmoothies: [MenuItem] {
        menuItems.filter { favoriteSmoothieIds.contains($0.id) }
    }

    func loadMenu() async {
        isLoading = true

        // TODO: Wire to Supabase menu_items table
        try? await Task.sleep(for: .seconds(0.3))

        menuItems = [
            MenuItem(
                id: UUID(),
                name: "Golden Glow",
                description: "Mango, turmeric, ginger, coconut milk, a touch of black pepper. Your skin will thank you.",
                ingredients: ["Mango", "Turmeric", "Ginger", "Coconut Milk", "Black Pepper"],
                allergens: [],
                nutritionalInfo: ["calories": "180", "protein": "4g", "fiber": "3g"],
                goalTags: [.glow],
                priceCents: 890,
                imageURL: nil,
                available: true,
                sortOrder: 0,
                boostsAvailable: [.collagen, .adaptogens, .protein]
            ),
            MenuItem(
                id: UUID(),
                name: "Deep Recovery",
                description: "Tart cherry, beetroot, whey protein, cacao. For after your session.",
                ingredients: ["Tart Cherry", "Beetroot", "Whey Protein", "Cacao", "Banana"],
                allergens: ["Dairy"],
                nutritionalInfo: ["calories": "260", "protein": "18g", "fiber": "4g"],
                goalTags: [.recovery],
                priceCents: 950,
                imageURL: nil,
                available: true,
                sortOrder: 1,
                boostsAvailable: [.protein, .collagen, .greens]
            ),
            MenuItem(
                id: UUID(),
                name: "Calm Down",
                description: "Ashwagandha, lavender, chamomile, oat milk, vanilla. Breathe.",
                ingredients: ["Ashwagandha", "Lavender", "Chamomile", "Oat Milk", "Vanilla"],
                allergens: ["Gluten"],
                nutritionalInfo: ["calories": "150", "protein": "5g"],
                goalTags: [.calm],
                priceCents: 850,
                imageURL: nil,
                available: true,
                sortOrder: 2,
                boostsAvailable: [.adaptogens, .collagen]
            ),
            MenuItem(
                id: UUID(),
                name: "Gut Feeling",
                description: "Kefir, prebiotic fiber, blueberry, flaxseed, mint. Trust your gut.",
                ingredients: ["Kefir", "Prebiotic Fiber", "Blueberry", "Flaxseed", "Mint"],
                allergens: ["Dairy"],
                nutritionalInfo: ["calories": "200", "protein": "8g", "fiber": "6g"],
                goalTags: [.gut],
                priceCents: 920,
                imageURL: nil,
                available: true,
                sortOrder: 3,
                boostsAvailable: [.greens, .immunity, .protein]
            ),
            MenuItem(
                id: UUID(),
                name: "Morning Volt",
                description: "Matcha, spirulina, banana, almond butter, lion's mane. Wake up properly.",
                ingredients: ["Matcha", "Spirulina", "Banana", "Almond Butter", "Lion's Mane"],
                allergens: ["Tree Nuts"],
                nutritionalInfo: ["calories": "280", "protein": "10g"],
                goalTags: [.energy],
                priceCents: 980,
                imageURL: nil,
                available: true,
                sortOrder: 4,
                boostsAvailable: [.adaptogens, .greens, .protein]
            ),
            MenuItem(
                id: UUID(),
                name: "Winter Spice",
                description: "Pumpkin, cinnamon, cardamom, oat milk, maple. The season in a glass.",
                ingredients: ["Pumpkin", "Cinnamon", "Cardamom", "Oat Milk", "Maple Syrup"],
                allergens: ["Gluten"],
                nutritionalInfo: ["calories": "190", "protein": "4g"],
                goalTags: [.seasonal],
                priceCents: 870,
                imageURL: nil,
                available: true,
                sortOrder: 5,
                boostsAvailable: [.collagen, .immunity, .adaptogens]
            ),
        ]

        isLoading = false
    }
}
