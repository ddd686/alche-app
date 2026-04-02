import SwiftUI

struct RestaurantListView: View {
    @State private var viewModel = RestaurantListViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Cuisine filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AlcheSpacing.sm) {
                        CuisineFilterPill(
                            title: "All",
                            isSelected: viewModel.selectedCuisine == nil
                        ) {
                            viewModel.selectedCuisine = nil
                        }

                        ForEach(CuisineType.allCases, id: \.self) { cuisine in
                            CuisineFilterPill(
                                title: cuisine.displayName,
                                isSelected: viewModel.selectedCuisine == cuisine
                            ) {
                                viewModel.selectedCuisine = cuisine
                            }
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                // Content
                if viewModel.isLoading {
                    VStack(spacing: AlcheSpacing.md) {
                        ProgressView()
                            .tint(Color.alchePrimary)
                        Text("Loading restaurants...")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, AlcheSpacing.xl)
                } else if let errorMessage = viewModel.errorMessage {
                    AlcheEmptyStateView(
                        icon: "exclamationmark.triangle",
                        title: "Something went wrong",
                        message: errorMessage,
                        actionTitle: "Try Again"
                    ) {
                        Task { await viewModel.loadRestaurants() }
                    }
                } else if viewModel.filteredRestaurants.isEmpty {
                    AlcheEmptyStateView(
                        icon: "fork.knife",
                        title: "No partner restaurants",
                        message: "No partner restaurants match your selection. Try a different cuisine or check back soon."
                    )
                } else {
                    LazyVStack(spacing: AlcheSpacing.md) {
                        ForEach(viewModel.filteredRestaurants) { restaurant in
                            NavigationLink {
                                RestaurantDetailView(restaurant: restaurant)
                            } label: {
                                RestaurantCard(restaurant: restaurant)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }

                DataSourceIndicator(isMock: true)
                    .padding(.top, AlcheSpacing.md)
            }
            .padding(.top, AlcheSpacing.md)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Partner Restaurants")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchText, prompt: "Search restaurants")
        .task {
            await viewModel.loadRestaurants()
        }
    }
}

// MARK: - Cuisine Filter Pill

private struct CuisineFilterPill: View {
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

// MARK: - Restaurant Card

private struct RestaurantCard: View {
    let restaurant: PartnerRestaurant

    var body: some View {
        HStack(spacing: AlcheSpacing.md) {
            // Image placeholder
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .fill(cuisineGradient)
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: cuisineIcon)
                        .font(.alcheHeading)
                        .foregroundStyle(.white.opacity(0.7))
                )

            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text(restaurant.name)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alchePrimaryText)

                Text("\(restaurant.cuisineType.displayName) \u{00B7} \(restaurant.district)")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)

                HStack(spacing: AlcheSpacing.sm) {
                    Text(restaurant.priceRange.symbol)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alchePrimaryText)

                    if restaurant.isVerified {
                        HStack(spacing: 2) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 10))
                            Text("Verified")
                                .font(.alcheOverline)
                        }
                        .foregroundStyle(Color.alcheSage)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSecondaryText)
        }
        .padding(AlcheSpacing.md)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }

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

#Preview {
    NavigationStack {
        RestaurantListView()
    }
}
