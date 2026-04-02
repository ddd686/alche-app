import SwiftUI

struct DiscoverView: View {
    @State private var viewModel = DiscoverViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Section picker
            Picker("Section", selection: $viewModel.selectedSection) {
                ForEach(DiscoverViewModel.DiscoverSection.allCases, id: \.self) { section in
                    Text(section.rawValue).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.vertical, AlcheSpacing.sm)

            ScrollView {
                switch viewModel.selectedSection {
                case .content:
                    contentSection
                case .events:
                    eventsSection
                case .eatOut:
                    eatOutSection
                case .saved:
                    savedSection
                }
            }
        }
        .background(Color.alcheBackground)
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadContent()
        }
    }

    // MARK: - Content Section

    private var contentSection: some View {
        LazyVStack(spacing: AlcheSpacing.md) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.alchePrimary)
                    .padding(.top, AlcheSpacing.xl)
            } else if viewModel.articles.isEmpty {
                AlcheEmptyStateView(
                    icon: "doc.text",
                    title: "Fresh reads coming soon",
                    message: "We're working on our first batch of articles and science reviews."
                )
            } else {
                ForEach(viewModel.articles) { article in
                    ContentCardView(
                        content: article,
                        isBookmarked: viewModel.isBookmarked(article.id)
                    ) {
                        viewModel.toggleBookmark(article)
                    }
                }
            }
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.bottom, AlcheSpacing.xxl)
    }

    // MARK: - Saved Section

    private var savedSection: some View {
        LazyVStack(spacing: AlcheSpacing.md) {
            if viewModel.bookmarkedArticles.isEmpty {
                AlcheEmptyStateView(
                    icon: "bookmark",
                    title: "No saved articles yet",
                    message: "Tap the bookmark icon on any article to save it here for later."
                )
            } else {
                ForEach(viewModel.bookmarkedArticles) { article in
                    ContentCardView(
                        content: article,
                        isBookmarked: true
                    ) {
                        viewModel.toggleBookmark(article)
                    }
                }
            }
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.bottom, AlcheSpacing.xxl)
    }

    // MARK: - Eat Out Section

    private var eatOutSection: some View {
        VStack(spacing: AlcheSpacing.md) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.alchePrimary)
                    .padding(.top, AlcheSpacing.xl)
            } else {
                // Intro card
                AlcheCard(shadow: .medium) {
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        HStack {
                            Text("Partner Restaurants")
                                .font(.alcheSubheading)
                                .foregroundStyle(Color.alcheEditorialBlack)
                            Spacer()
                            AlcheTag(text: "Verified", color: .alcheSage, isSelected: true)
                        }
                        Text("Independently analyzed nutrition data for every dish. No guesswork.")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                }

                // Restaurant preview cards
                if viewModel.restaurants.isEmpty {
                    AlcheEmptyStateView(
                        icon: "fork.knife",
                        title: "No partner restaurants yet",
                        message: "We're onboarding our first restaurant partners. Check back soon."
                    )
                } else {
                    ForEach(viewModel.restaurants.filter(\.isActive).prefix(4), id: \.id) { restaurant in
                        NavigationLink {
                            RestaurantDetailView(restaurant: restaurant)
                        } label: {
                            eatOutRestaurantRow(restaurant)
                        }
                        .buttonStyle(.plain)
                    }

                    // Browse all link
                    NavigationLink {
                        RestaurantListView()
                    } label: {
                        HStack {
                            Text("Browse all \(viewModel.restaurants.filter(\.isActive).count) restaurants")
                                .font(.alcheBodyMedium)
                                .foregroundStyle(Color.alchePrimary)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.alcheCaption)
                                .foregroundStyle(Color.alchePrimary)
                        }
                        .padding(AlcheSpacing.md)
                        .background(Color.alchePrimary.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                    .buttonStyle(.plain)
                }

                DataSourceIndicator(isMock: true)
                    .padding(.top, AlcheSpacing.sm)
            }
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.bottom, AlcheSpacing.xxl)
    }

    private func eatOutRestaurantRow(_ restaurant: PartnerRestaurant) -> some View {
        HStack(spacing: AlcheSpacing.md) {
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .fill(
                    LinearGradient(
                        colors: [cuisineColor(restaurant.cuisineType).opacity(0.4),
                                 cuisineColor(restaurant.cuisineType).opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: cuisineIcon(restaurant.cuisineType))
                        .font(.alcheSubheading)
                        .foregroundStyle(.white.opacity(0.7))
                )

            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text(restaurant.name)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alcheEditorialBlack)

                Text("\(restaurant.cuisineType.displayName) \u{00B7} \(restaurant.district) \u{00B7} \(restaurant.priceRange.symbol)")
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
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

    private func cuisineColor(_ type: CuisineType) -> Color {
        switch type {
        case .mediterranean: .alcheAmber
        case .asian: .alchePrimary
        case .german: .alcheEditorialBlack
        case .fusion: .alcheInfo
        case .vegan: .alcheSage
        case .raw: .alcheSage
        case .bowls: .alchePrimary
        }
    }

    private func cuisineIcon(_ type: CuisineType) -> String {
        switch type {
        case .mediterranean: "sun.max"
        case .asian: "leaf"
        case .german: "fork.knife"
        case .fusion: "sparkles"
        case .vegan: "leaf.fill"
        case .raw: "carrot"
        case .bowls: "bowl"
        }
    }

    // MARK: - Events Section

    private var eventsSection: some View {
        LazyVStack(spacing: AlcheSpacing.md) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color.alchePrimary)
                    .padding(.top, AlcheSpacing.xl)
            } else if viewModel.events.isEmpty {
                AlcheEmptyStateView(
                    icon: "calendar",
                    title: "No upcoming events",
                    message: "New Alche Salons and workshops are announced regularly. Check back soon."
                )
            } else {
                ForEach(viewModel.events) { event in
                    NavigationLink {
                        EventDetailView(
                            event: event,
                            isRSVPd: viewModel.isRSVPd(event.id),
                            onRSVP: { await viewModel.rsvp(eventId: event.id) },
                            onCancelRSVP: { await viewModel.cancelRSVP(eventId: event.id) }
                        )
                    } label: {
                        EventCardView(
                            event: event,
                            isRSVPd: viewModel.isRSVPd(event.id)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.bottom, AlcheSpacing.xxl)
    }
}

#Preview {
    NavigationStack {
        DiscoverView()
    }
}
