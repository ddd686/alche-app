import Foundation

@Observable
@MainActor
final class ShopViewModel {
    // MARK: - State

    var products: [Product] = []
    var cartItems: [CartItem] = []
    var selectedCategory: ProductCategory?
    var isLoading = false
    var errorMessage: String?
    var isMember = true // TODO: Wire to membership state
    var showCheckout = false
    var searchText = ""
    var showWishlistOnly = false
    var favoriteProductIds: Set<UUID> = []

    // MARK: - Cart Item

    struct CartItem: Identifiable, Hashable {
        let id = UUID()
        let product: Product
        var quantity: Int

        var subtotalCents: Int {
            product.priceCents * quantity
        }

        var memberSubtotalCents: Int {
            (product.memberPriceCents ?? product.priceCents) * quantity
        }
    }

    // MARK: - Computed

    var filteredProducts: [Product] {
        var result = products.filter(\.inStock)

        if showWishlistOnly {
            result = result.filter { favoriteProductIds.contains($0.id) }
        }

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                ($0.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }

        return result.sorted { $0.sortOrder < $1.sortOrder }
    }

    var wishlistCount: Int {
        favoriteProductIds.count
    }

    var cartCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }

    var cartTotalCents: Int {
        if isMember {
            return cartItems.reduce(0) { $0 + $1.memberSubtotalCents }
        }
        return cartItems.reduce(0) { $0 + $1.subtotalCents }
    }

    var formattedCartTotal: String {
        let euros = Double(cartTotalCents) / 100.0
        return String(format: "EUR %.2f", euros)
    }

    var cartSavingsCents: Int {
        guard isMember else { return 0 }
        let fullPrice = cartItems.reduce(0) { $0 + $1.subtotalCents }
        return fullPrice - cartTotalCents
    }

    // MARK: - Actions

    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        // TODO: Wire to ShopServiceProtocol / Supabase products table
        try? await Task.sleep(for: .seconds(0.5))
        products = Product.allPreviews
        isLoading = false
    }

    func addToCart(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(product: product, quantity: 1))
        }
    }

    func removeFromCart(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
    }

    func clearCart() {
        cartItems.removeAll()
    }

    func quantityInCart(for product: Product) -> Int {
        cartItems.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }

    // MARK: - Favorites

    func toggleFavorite(_ product: Product) {
        if favoriteProductIds.contains(product.id) {
            favoriteProductIds.remove(product.id)
        } else {
            favoriteProductIds.insert(product.id)
        }
        // TODO: Wire to Supabase favorites table
    }

    func isFavorite(_ product: Product) -> Bool {
        favoriteProductIds.contains(product.id)
    }

    // MARK: - Checkout

    func checkout(fulfillment: FulfillmentOption) async {
        isLoading = true
        errorMessage = nil

        do {
            // TODO: Wire to Stripe via Supabase Edge Function
            try await Task.sleep(for: .seconds(1.5))
            clearCart()
            showCheckout = false
        } catch {
            errorMessage = "Checkout failed. Please try again."
        }

        isLoading = false
    }
}
