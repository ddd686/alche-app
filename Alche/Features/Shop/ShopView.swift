import SwiftUI

struct ShopView: View {
    @State private var viewModel = ShopViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: AlcheSpacing.md),
        GridItem(.flexible(), spacing: AlcheSpacing.md)
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AlcheSpacing.xl) {

                        // MARK: - Hero Editorial Section

                        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                            Text("THE SHOP")
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)

                            Text("Curated for\nLongevity")
                                .font(.alcheDisplayXL)
                                .foregroundStyle(Color.alchePrimaryText)

                            Text("Science-backed supplements, ethically sourced and formulated for those who take longevity seriously.")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .padding(.top, AlcheSpacing.xs)
                        }
                        .padding(.top, AlcheSpacing.xl)
                        .padding(.horizontal, AlcheSpacing.lg)

                        // MARK: - Category Filter (AlcheTag style)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AlcheSpacing.sm) {
                                AlcheTag(
                                    text: "All",
                                    color: .alchePrimary,
                                    variant: .outline,
                                    isSelected: viewModel.selectedCategory == nil && !viewModel.showWishlistOnly
                                )
                                .onTapGesture {
                                    viewModel.selectedCategory = nil
                                    viewModel.showWishlistOnly = false
                                }

                                // Saved / wishlist tag
                                Button {
                                    viewModel.showWishlistOnly.toggle()
                                    if viewModel.showWishlistOnly {
                                        viewModel.selectedCategory = nil
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 9))
                                        Text("SAVED")
                                            .font(.alcheOverline)
                                            .tracking(0.8)
                                        if viewModel.wishlistCount > 0 {
                                            Text("\(viewModel.wishlistCount)")
                                                .font(.alcheOverlineTiny)
                                                .foregroundStyle(viewModel.showWishlistOnly ? Color.alcheWhite : Color.alcheSurface)
                                                .frame(width: 16, height: 16)
                                                .background(viewModel.showWishlistOnly ? Color.alcheSurface.opacity(0.3) : Color.alchePrimary)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .foregroundStyle(viewModel.showWishlistOnly ? Color.alcheWhite : Color.alchePrimary)
                                    .padding(.horizontal, AlcheSpacing.sm)
                                    .padding(.vertical, AlcheSpacing.xs)
                                    .background(viewModel.showWishlistOnly ? Color.alchePrimary : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AlcheRadii.sm)
                                            .stroke(Color.alchePrimary.opacity(viewModel.showWishlistOnly ? 0 : 1), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)

                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    AlcheTag(
                                        text: category.displayName,
                                        color: .alchePrimary,
                                        variant: .outline,
                                        isSelected: viewModel.selectedCategory == category && !viewModel.showWishlistOnly
                                    )
                                    .onTapGesture {
                                        viewModel.selectedCategory = category
                                        viewModel.showWishlistOnly = false
                                    }
                                }
                            }
                            .padding(.horizontal, AlcheSpacing.lg)
                        }

                        // MARK: - Product Grid (2 columns, staggered)

                        if viewModel.isLoading {
                            VStack(spacing: AlcheSpacing.md) {
                                ProgressView()
                                    .tint(Color.alchePrimary)
                                Text("Loading products...")
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, AlcheSpacing.xl)
                        } else if viewModel.filteredProducts.isEmpty {
                            VStack(spacing: AlcheSpacing.md) {
                                Image(systemName: viewModel.showWishlistOnly ? "heart" : "leaf")
                                    .font(.alcheDisplayXL)
                                    .foregroundStyle(Color.alcheSecondaryText.opacity(0.4))

                                Text(viewModel.showWishlistOnly ? "No saved products yet" : "Nothing here yet")
                                    .font(.alcheSubheading)
                                    .foregroundStyle(Color.alcheSecondaryText)

                                if viewModel.showWishlistOnly {
                                    Text("Tap the heart on any product to save it here.")
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.alcheSecondaryText.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, AlcheSpacing.xl)
                        } else {
                            LazyVGrid(columns: columns, spacing: AlcheSpacing.md) {
                                ForEach(Array(viewModel.filteredProducts.enumerated()), id: \.element.id) { index, product in
                                    NavigationLink {
                                        ProductDetailView(product: product, viewModel: viewModel)
                                    } label: {
                                        ProductCard(
                                            product: product,
                                            isMember: viewModel.isMember,
                                            isFavorite: viewModel.isFavorite(product),
                                            index: index
                                        ) {
                                            viewModel.toggleFavorite(product)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    // Staggered: even indices get extra top padding
                                    .padding(.top, index % 2 == 0 ? 0 : AlcheSpacing.lg)
                                }
                            }
                            .padding(.horizontal, AlcheSpacing.lg)
                        }

                        // MARK: - Info Section (Bottom)

                        VStack(spacing: AlcheSpacing.lg) {
                            Rectangle()
                                .fill(Color.alcheEditorialBlack.opacity(0.10))
                                .frame(height: 1)

                            HStack(alignment: .top, spacing: AlcheSpacing.md) {
                                InfoBlock(
                                    title: "Ethically Sourced",
                                    description: "Responsibly harvested ingredients from trusted partners"
                                )

                                InfoBlock(
                                    title: "Science-Backed",
                                    description: "Every formula reviewed by our longevity research team"
                                )

                                InfoBlock(
                                    title: "Free Shipping 60\u{20AC}+",
                                    description: "Complimentary delivery on orders over sixty euros"
                                )
                            }
                        }
                        .padding(.horizontal, AlcheSpacing.lg)

                        // Disclaimer
                        Text("All products are food supplements. They are not intended to replace a varied, balanced diet and healthy lifestyle.")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AlcheSpacing.xl)
                            .padding(.bottom, viewModel.cartCount > 0 ? 80 : AlcheSpacing.lg)
                    }
                    .padding(.top, AlcheSpacing.md)
                }
                .background(Color.alcheBackground)

                // MARK: - Cart Bar

                if viewModel.cartCount > 0 {
                    Button {
                        viewModel.showCheckout = true
                    } label: {
                        HStack {
                            HStack(spacing: AlcheSpacing.sm) {
                                Image(systemName: "bag.fill")
                                Text("\(viewModel.cartCount) item\(viewModel.cartCount == 1 ? "" : "s")")
                                    .font(.alcheBodyMedium)
                            }
                            Spacer()
                            Text(viewModel.formattedCartTotal)
                                .font(.alcheBodyMedium)
                        }
                        .foregroundStyle(Color.alcheWhite)
                        .padding(.horizontal, AlcheSpacing.lg)
                        .frame(height: 56)
                        .background(Color.alchePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.bottom, AlcheSpacing.sm)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.cartCount)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .searchable(text: $viewModel.searchText, prompt: "Search products")
            .sheet(isPresented: $viewModel.showCheckout) {
                CartView(viewModel: viewModel)
            }
            .task {
                await viewModel.loadProducts()
            }
        }
    }
}

// MARK: - Product Card (Stitch: no card chrome, staggered)

private struct ProductCard: View {
    let product: Product
    let isMember: Bool
    var isFavorite: Bool = false
    var index: Int = 0
    var onToggleFavorite: (() -> Void)?

    /// Determine badge text based on sort order / index
    private var badgeText: String? {
        if product.sortOrder == 0 { return "BESTSELLER" }
        if product.sortOrder == 1 { return "NEW" }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            // Image container: 4:5 aspect, warm gray background
            ZStack(alignment: .topLeading) {
                Color.alcheWarmGray.opacity(0.3)
                    .aspectRatio(4.0 / 5.0, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                    .overlay(
                        Image(systemName: productIcon)
                            .font(.system(size: 40))
                            .foregroundStyle(Color.alcheEditorialMuted.opacity(0.4))
                            .scaleEffect(0.75)
                    )

                // Badge
                if let badge = badgeText {
                    Text(badge)
                        .font(.alcheOverlineTiny)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.alchePrimary)
                        .padding(.horizontal, AlcheSpacing.sm)
                        .padding(.vertical, AlcheSpacing.xs)
                        .background(Color.alcheWhite.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                        .padding(AlcheSpacing.sm)
                }

                // Favorite button
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            onToggleFavorite?()
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.alcheCaption)
                                .foregroundStyle(isFavorite ? Color.alchePrimary : Color.alcheEditorialMuted)
                                .padding(AlcheSpacing.sm)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(AlcheSpacing.sm)
                    }
                }
            }

            // Product info: name (subheading italic) + price (overline)
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text(product.name)
                    .font(.alcheSubheading)
                    .italic()
                    .foregroundStyle(Color.alchePrimaryText)
                    .lineLimit(2)

                HStack(spacing: AlcheSpacing.xs) {
                    if isMember {
                        Text(product.formattedMemberPrice)
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                        Text(product.formattedPrice)
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText.opacity(0.5))
                            .strikethrough()
                    } else {
                        Text(product.formattedPrice)
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                }

                if !product.inStock {
                    Text("Out of stock")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
        // No card chrome: no border, no shadow, no background on the card itself
    }

    private var productIcon: String {
        switch product.productType {
        case .blend: "flask"
        case .singleIngredient: "leaf"
        case .capsule: "pill"
        }
    }
}

// MARK: - Info Block (Bottom Section)

private struct InfoBlock: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
            Text(title.uppercased())
                .font(.alcheOverline)
                .foregroundStyle(Color.alchePrimaryText)

            Text(description)
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSecondaryText)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ShopView()
}
