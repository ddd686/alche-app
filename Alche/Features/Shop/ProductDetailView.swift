import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Bindable var viewModel: ShopViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Hero image placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: AlcheRadii.lg)
                        .fill(categoryGradient)
                        .frame(height: 280)

                    Image(systemName: productIcon)
                        .font(.system(size: 64))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.horizontal, AlcheSpacing.lg)

                VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                    // Title & pricing
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text(product.category.displayName.uppercased())
                            .font(.overline)
                            .foregroundStyle(Color.alchePrimary)

                        Text(product.name)
                            .font(.displayL)
                            .foregroundStyle(Color.alchePrimaryText)

                        HStack(spacing: AlcheSpacing.md) {
                            if viewModel.isMember {
                                let memberPrice = product.formattedMemberPrice
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(memberPrice)
                                        .font(.heading)
                                        .foregroundStyle(Color.alchePrimaryText)
                                    HStack(spacing: AlcheSpacing.xs) {
                                        Text(product.formattedPrice)
                                            .font(.alcheCaption)
                                            .foregroundStyle(Color.alcheSecondaryText)
                                            .strikethrough()
                                        if let savings = product.savingsPercent {
                                            Text("Save \(savings)%")
                                                .font(.alcheOverline)
                                                .foregroundStyle(Color.sage)
                                        }
                                    }
                                }
                            } else {
                                Text(product.formattedPrice)
                                    .font(.heading)
                                    .foregroundStyle(Color.alchePrimaryText)
                            }

                            Spacer()

                            if let weight = product.weight {
                                Text(weight)
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .padding(.horizontal, AlcheSpacing.sm)
                                    .padding(.vertical, AlcheSpacing.xs)
                                    .background(Color.alcheWarmGray.opacity(0.5))
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    // Description
                    if let description = product.description {
                        Text(description)
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .lineSpacing(4)
                    }

                    // Ingredients
                    if !product.ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                            Text("INGREDIENTS")
                                .font(.overline)
                                .foregroundStyle(Color.alcheSecondaryText)

                            Text(product.ingredients.joined(separator: ", "))
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alchePrimaryText)
                        }
                        .padding(AlcheSpacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.alcheSurface)
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }

                    // Fulfillment options
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("FULFILLMENT")
                            .font(.overline)
                            .foregroundStyle(Color.alcheSecondaryText)

                        ForEach(product.fulfillmentOptions, id: \.self) { option in
                            HStack(spacing: AlcheSpacing.sm) {
                                Image(systemName: option == .pickup ? "storefront" : "shippingbox")
                                    .frame(width: 20)
                                    .foregroundStyle(Color.alchePrimary)
                                Text(option.displayName)
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alchePrimaryText)
                            }
                        }
                    }

                    // EU disclaimer
                    Text("Food supplement. Not intended to replace a varied, balanced diet and healthy lifestyle. Do not exceed recommended daily intake.")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText.opacity(0.5))
                        .padding(.top, AlcheSpacing.sm)
                }
                .padding(.horizontal, AlcheSpacing.lg)
            }
            .padding(.bottom, 100)
        }
        .background(Color.alcheBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFavorite(product)
                } label: {
                    Image(systemName: viewModel.isFavorite(product) ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorite(product) ? Color.alchePrimary : Color.alcheSecondaryText)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            // Add to cart
            VStack(spacing: 0) {
                Divider()

                let quantity = viewModel.quantityInCart(for: product)

                if quantity > 0 {
                    HStack(spacing: AlcheSpacing.lg) {
                        Button {
                            viewModel.removeFromCart(product)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.alcheHeading)
                                .foregroundStyle(Color.alcheSecondaryText)
                        }

                        Text("\(quantity)")
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alchePrimaryText)
                            .frame(width: 32)

                        Button {
                            viewModel.addToCart(product)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.alcheHeading)
                                .foregroundStyle(Color.alchePrimary)
                        }

                        Spacer()

                        Text("In bag")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.sage)
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.vertical, AlcheSpacing.md)
                } else {
                    Button {
                        viewModel.addToCart(product)
                    } label: {
                        Text("Add to Bag")
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alcheWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(product.inStock ? Color.alchePrimary : Color.alcheSecondaryText)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                    .disabled(!product.inStock)
                    .padding(.horizontal, AlcheSpacing.lg)
                    .padding(.vertical, AlcheSpacing.md)
                }
            }
            .background(.ultraThinMaterial)
        }
    }

    private var categoryGradient: LinearGradient {
        let base: Color = switch product.category {
        case .glow: Color.amber
        case .recovery: Color.sage
        case .energy: Color.terra
        case .sleep: Color.info
        case .gut: Color.sage
        }
        return LinearGradient(
            colors: [base.opacity(0.4), base.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var productIcon: String {
        switch product.productType {
        case .blend: "flask"
        case .singleIngredient: "leaf"
        case .capsule: "pill"
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: .preview, viewModel: ShopViewModel())
    }
}
