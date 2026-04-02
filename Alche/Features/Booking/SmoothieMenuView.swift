import SwiftUI

struct SmoothieMenuView: View {
    @Bindable var viewModel: BookingViewModel
    @State private var menuViewModel = SmoothieMenuViewModel()
    @State private var selectedCategory: SmoothieGoal?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: AlcheSpacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("What are you in the mood for?")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text("Functional smoothies crafted to complement your session.")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AlcheSpacing.sm) {
                        CategoryPill(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }

                        ForEach(SmoothieGoal.allCases, id: \.self) { goal in
                            CategoryPill(
                                title: goal.displayName,
                                isSelected: selectedCategory == goal
                            ) {
                                selectedCategory = goal
                            }
                        }
                    }
                }

                // Smoothie list
                if filteredItems.isEmpty {
                    VStack(spacing: AlcheSpacing.md) {
                        Image(systemName: "cup.and.saucer")
                            .font(.largeTitle)
                            .foregroundStyle(Color.alcheSecondaryText.opacity(0.4))

                        Text("No smoothies in this category")
                            .font(.alcheSubheading)
                            .foregroundStyle(Color.alcheSecondaryText)

                        Text("Try selecting a different category.")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AlcheSpacing.xl)
                }

                VStack(spacing: AlcheSpacing.md) {
                    ForEach(filteredItems) { item in
                        SmoothieCard(
                            item: item,
                            isSelected: viewModel.selectedSmoothie?.id == item.id,
                            isFavorite: menuViewModel.isFavorite(item),
                            onToggleFavorite: { menuViewModel.toggleFavorite(item) }
                        ) {
                            viewModel.selectedSmoothie = item
                        }
                    }
                }

                // Boosts section
                if viewModel.selectedSmoothie != nil {
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        Text("ADD A BOOST")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)

                        Text("+EUR 2.00 each")
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)

                        FlowLayout(spacing: AlcheSpacing.sm) {
                            ForEach(availableBoosts, id: \.self) { boost in
                                BoostChip(
                                    boost: boost,
                                    isSelected: viewModel.selectedBoosts.contains(boost)
                                ) {
                                    if viewModel.selectedBoosts.contains(boost) {
                                        viewModel.selectedBoosts.removeAll { $0 == boost }
                                    } else {
                                        viewModel.selectedBoosts.append(boost)
                                    }
                                }
                            }
                        }
                    }
                    .padding(AlcheSpacing.md)
                    .background(Color.alcheSurface)
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                }

                // Confirm selection
                if viewModel.selectedSmoothie != nil {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("Add to Booking")
                                .font(.alcheBodyMedium)
                            Spacer()
                            Text(formattedTotal)
                                .font(.alcheBodyMedium)
                        }
                        .foregroundStyle(Color.alcheWhite)
                        .padding(.horizontal, AlcheSpacing.lg)
                        .frame(height: 52)
                        .background(Color.alchePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                }
            }
            .padding(.horizontal, AlcheSpacing.lg)
            .padding(.top, AlcheSpacing.md)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Smoothie Menu")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await menuViewModel.loadMenu()
        }
    }

    // MARK: - Computed

    private var filteredItems: [MenuItem] {
        guard let category = selectedCategory else {
            return menuViewModel.menuItems
        }
        return menuViewModel.menuItems.filter { $0.goalTags.contains(category) }
    }

    private var availableBoosts: [BoostType] {
        viewModel.selectedSmoothie?.boostsAvailable ?? BoostType.allCases
    }

    private var formattedTotal: String {
        let total = viewModel.preOrderTotal
        let euros = Double(total) / 100.0
        return String(format: "EUR %.2f", euros)
    }
}

// MARK: - Category Pill

private struct CategoryPill: View {
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

// MARK: - Smoothie Card

private struct SmoothieCard: View {
    let item: MenuItem
    let isSelected: Bool
    var isFavorite: Bool = false
    var onToggleFavorite: (() -> Void)?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: AlcheSpacing.md) {
                // Placeholder smoothie art
                RoundedRectangle(cornerRadius: AlcheRadii.sm)
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: item.category == .energy ? "bolt" : "cup.and.saucer")
                            .foregroundStyle(categoryColor)
                    )

                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(item.name)
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alchePrimaryText)

                    if let description = item.description {
                        Text(description)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .lineLimit(2)
                    }

                    HStack(spacing: AlcheSpacing.xs) {
                        ForEach(item.goalTags, id: \.self) { tag in
                            Text(tag.displayName)
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alchePrimary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.alchePrimary.opacity(0.06))
                                .clipShape(Capsule())
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: AlcheSpacing.sm) {
                    Text(item.formattedPrice)
                        .font(.alcheBodyMedium)
                        .foregroundStyle(Color.alchePrimaryText)

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.alcheSuccess)
                    }

                    if let onToggleFavorite {
                        Button {
                            onToggleFavorite()
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.alcheCaption)
                                .foregroundStyle(isFavorite ? Color.alchePrimary : Color.alcheSecondaryText)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(AlcheSpacing.md)
            .background(isSelected ? Color.alcheSuccess.opacity(0.06) : Color.alcheSurface)
            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
            .overlay(
                RoundedRectangle(cornerRadius: AlcheRadii.md)
                    .strokeBorder(isSelected ? Color.alcheSuccess.opacity(0.4) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var categoryColor: Color {
        switch item.category {
        case .glow: Color.alcheAmber
        case .recovery: Color.alcheSuccess
        case .calm: Color.alcheInfo
        case .gut: Color.alcheSuccess
        case .energy: Color.alchePrimary
        case .seasonal: Color.alcheAmber
        }
    }
}

// MARK: - Boost Chip

private struct BoostChip: View {
    let boost: BoostType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                }
                Text(boost.displayName)
                    .font(.alcheCaption)
            }
            .foregroundStyle(isSelected ? Color.alcheWhite : Color.alchePrimaryText)
            .padding(.horizontal, AlcheSpacing.md)
            .padding(.vertical, AlcheSpacing.sm)
            .background(isSelected ? Color.alchePrimary : Color.alcheWarmGray.opacity(0.5))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Flow Layout

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX)
        }

        return (CGSize(width: maxX, height: currentY + lineHeight), positions)
    }
}

#Preview {
    NavigationStack {
        SmoothieMenuView(viewModel: BookingViewModel())
    }
}
