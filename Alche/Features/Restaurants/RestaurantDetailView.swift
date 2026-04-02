import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: PartnerRestaurant
    @State private var viewModel: RestaurantDetailViewModel

    init(restaurant: PartnerRestaurant) {
        self.restaurant = restaurant
        self._viewModel = State(initialValue: RestaurantDetailViewModel(restaurant: restaurant))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Hero image placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: AlcheRadii.lg)
                        .fill(cuisineGradient)
                        .frame(height: 200)

                    VStack(spacing: AlcheSpacing.sm) {
                        Image(systemName: cuisineIcon)
                            .font(.system(size: 48))
                            .foregroundStyle(.white.opacity(0.5))

                        if restaurant.isVerified {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 12))
                                Text("alche verified")
                                    .font(.alcheCaption)
                            }
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.horizontal, AlcheSpacing.sm)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                    // Restaurant info
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text(restaurant.name)
                            .font(.alcheDisplayL)
                            .foregroundStyle(Color.alchePrimaryText)

                        HStack(spacing: AlcheSpacing.sm) {
                            Text(restaurant.cuisineType.displayName)
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                            Text("\u{00B7}")
                                .foregroundStyle(Color.alcheSecondaryText)
                            Text(restaurant.district)
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alcheSecondaryText)
                            Text("\u{00B7}")
                                .foregroundStyle(Color.alcheSecondaryText)
                            Text(restaurant.priceRange.symbol)
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alchePrimaryText)
                        }

                        if let description = restaurant.description {
                            Text(description)
                                .font(.alcheBody)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .lineSpacing(4)
                        }
                    }

                    // Menu section
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("MENU")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        // Category filter
                        if viewModel.categories.count > 1 {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AlcheSpacing.sm) {
                                    DishCategoryPill(
                                        title: "All",
                                        isSelected: viewModel.selectedCategory == nil
                                    ) {
                                        viewModel.selectedCategory = nil
                                    }

                                    ForEach(viewModel.categories, id: \.self) { category in
                                        DishCategoryPill(
                                            title: category.displayName,
                                            isSelected: viewModel.selectedCategory == category
                                        ) {
                                            viewModel.selectedCategory = category
                                        }
                                    }
                                }
                            }
                        }

                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .tint(Color.alchePrimary)
                                Spacer()
                            }
                            .padding(.vertical, AlcheSpacing.xl)
                        } else if let errorMessage = viewModel.errorMessage {
                            VStack(spacing: AlcheSpacing.sm) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.alcheHeading)
                                    .foregroundStyle(Color.alcheAmber)
                                Text(errorMessage)
                                    .font(.alcheCaption)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                    .multilineTextAlignment(.center)
                                Button("Retry") {
                                    Task { await viewModel.loadMenu() }
                                }
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alchePrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AlcheSpacing.xl)
                        } else {
                            LazyVStack(spacing: AlcheSpacing.sm) {
                                ForEach(viewModel.filteredDishes) { dish in
                                    NavigationLink {
                                        DishDetailView(
                                            dish: dish,
                                            restaurant: restaurant,
                                            profile: viewModel.nutritionalProfile(for: dish)
                                        )
                                    } label: {
                                        DishRow(
                                            dish: dish,
                                            profile: viewModel.nutritionalProfile(for: dish)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // Last analyzed
                    Text("Menu last analyzed: \(restaurant.menuLastUpdated.formatted(date: .abbreviated, time: .omitted))")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)

                    DataSourceIndicator(isMock: true)
                }
                .padding(.horizontal, AlcheSpacing.lg)
            }
            .padding(.bottom, AlcheSpacing.xl)
        }
        .background(Color.alcheBackground)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMenu()
        }
    }

    // MARK: - Computed

    private var cuisineGradient: LinearGradient {
        let base: Color = switch restaurant.cuisineType {
        case .mediterranean: .alcheAmber
        case .asian: .alchePrimary
        case .german: .alcheEditorialBlack
        case .fusion: .alcheInfo
        case .vegan: .alcheSage
        case .raw: .alcheSage
        case .bowls: .alchePrimary
        }
        return LinearGradient(
            colors: [base.opacity(0.4), base.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var cuisineIcon: String {
        switch restaurant.cuisineType {
        case .mediterranean: "sun.max"
        case .asian: "leaf"
        case .german: "fork.knife"
        case .fusion: "sparkles"
        case .vegan: "leaf.fill"
        case .raw: "carrot"
        case .bowls: "bowl"
        }
    }
}

// MARK: - Dish Category Pill

private struct DishCategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.alcheCaption)
                .foregroundStyle(isSelected ? Color.alcheWhite : Color.alchePrimaryText)
                .padding(.horizontal, AlcheSpacing.md)
                .padding(.vertical, AlcheSpacing.sm)
                .background(isSelected ? Color.alchePrimary : Color.alcheWarmGray.opacity(0.5))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Dish Row

private struct DishRow: View {
    let dish: RestaurantDish
    let profile: NutritionalProfile?

    var body: some View {
        HStack(alignment: .top, spacing: AlcheSpacing.md) {
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                HStack(spacing: AlcheSpacing.sm) {
                    Text(dish.name)
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alchePrimaryText)

                    if dish.isSignatureDish {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.alcheAmber)
                    }
                }

                if let description = dish.description {
                    Text(description)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .lineLimit(2)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                Text("EUR \(dish.formattedPrice)")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alchePrimaryText)

                if let profile {
                    Text("\(profile.calories) kcal")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alchePrimary)
                        .padding(.horizontal, AlcheSpacing.sm)
                        .padding(.vertical, 2)
                        .background(Color.alchePrimary.opacity(0.06))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(AlcheSpacing.md)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }
}

#Preview {
    NavigationStack {
        RestaurantDetailView(restaurant: .preview)
    }
}
