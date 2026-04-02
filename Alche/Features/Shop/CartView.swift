import SwiftUI

struct CartView: View {
    @Bindable var viewModel: ShopViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFulfillment: FulfillmentOption = .pickup

    var body: some View {
        NavigationStack {
            if viewModel.cartItems.isEmpty {
                // Empty state
                VStack(spacing: AlcheSpacing.lg) {
                    Spacer()

                    Image(systemName: "bag")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.alcheSecondaryText.opacity(0.3))

                    VStack(spacing: AlcheSpacing.sm) {
                        Text("Your bag is empty")
                            .font(.heading)
                            .foregroundStyle(Color.alchePrimaryText)

                        Text("Browse our curated collection of supplements and blends.")
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Text("Browse Shop")
                            .font(.alcheBodyMedium)
                            .foregroundStyle(Color.alcheWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.alchePrimary)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                    }
                }
                .padding(AlcheSpacing.lg)
                .background(Color.alcheBackground)
            } else {
                ScrollView {
                    VStack(spacing: AlcheSpacing.lg) {
                        // Cart items
                        VStack(spacing: AlcheSpacing.sm) {
                            ForEach(viewModel.cartItems) { item in
                                CartItemRow(
                                    item: item,
                                    isMember: viewModel.isMember,
                                    onIncrease: { viewModel.addToCart(item.product) },
                                    onDecrease: { viewModel.removeFromCart(item.product) }
                                )
                            }
                        }

                        // Fulfillment selection
                        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                            Text("FULFILLMENT")
                                .font(.overline)
                                .foregroundStyle(Color.alcheSecondaryText)

                            ForEach(FulfillmentOption.allCases, id: \.self) { option in
                                Button {
                                    selectedFulfillment = option
                                } label: {
                                    HStack(spacing: AlcheSpacing.md) {
                                        Image(systemName: selectedFulfillment == option ? "circle.inset.filled" : "circle")
                                            .foregroundStyle(selectedFulfillment == option ? Color.alchePrimary : Color.alcheSecondaryText)

                                        Image(systemName: option == .pickup ? "storefront" : "shippingbox")
                                            .frame(width: 20)
                                            .foregroundStyle(Color.alchePrimary)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(option.displayName)
                                                .font(.alcheSubheading)
                                                .foregroundStyle(Color.alchePrimaryText)
                                            Text(option == .pickup ? "Ready within 24 hours" : "3-5 business days")
                                                .font(.alcheCaption)
                                                .foregroundStyle(Color.alcheSecondaryText)
                                        }

                                        Spacer()
                                    }
                                    .padding(AlcheSpacing.md)
                                    .background(selectedFulfillment == option ? Color.alchePrimary.opacity(0.06) : Color.alcheSurface)
                                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AlcheRadii.md)
                                            .strokeBorder(selectedFulfillment == option ? Color.alchePrimary.opacity(0.3) : Color.clear, lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        // Order summary
                        VStack(spacing: AlcheSpacing.sm) {
                            HStack {
                                Text("Subtotal")
                                    .font(.alcheSubheading)
                                    .foregroundStyle(Color.alcheSecondaryText)
                                Spacer()
                                Text(viewModel.formattedCartTotal)
                                    .font(.alcheBodyMedium)
                                    .foregroundStyle(Color.alchePrimaryText)
                            }

                            if viewModel.cartSavingsCents > 0 {
                                HStack {
                                    Text("Member savings")
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.sage)
                                    Spacer()
                                    Text("-\(formattedPrice(viewModel.cartSavingsCents))")
                                        .font(.alcheCaption)
                                        .foregroundStyle(Color.sage)
                                }
                            }

                            Divider().foregroundStyle(Color.alcheWarmGray)

                            HStack {
                                Text("Total")
                                    .font(.alcheBodyMedium)
                                    .foregroundStyle(Color.alchePrimaryText)
                                Spacer()
                                Text(viewModel.formattedCartTotal)
                                    .font(.alcheBodyMedium)
                                    .foregroundStyle(Color.alchePrimaryText)
                            }
                        }
                        .padding(AlcheSpacing.md)
                        .background(Color.alcheSurface)
                        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))

                        // Checkout button
                        Button {
                            Task {
                                await viewModel.checkout(fulfillment: selectedFulfillment)
                                dismiss()
                            }
                        } label: {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(Color.alcheWhite)
                                } else {
                                    Text("Checkout")
                                        .font(.alcheBodyMedium)
                                    Spacer()
                                    Text(viewModel.formattedCartTotal)
                                        .font(.alcheBodyMedium)
                                }
                            }
                            .foregroundStyle(Color.alcheWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.alchePrimary)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                        }
                        .disabled(viewModel.isLoading)

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.alcheCaption)
                                .foregroundStyle(Color.error)
                        }
                    }
                    .padding(AlcheSpacing.lg)
                }
                .background(Color.alcheBackground)
            }
        }
        .navigationTitle("Bag")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !viewModel.cartItems.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        viewModel.clearCart()
                    }
                    .font(.alcheCaption)
                    .foregroundStyle(Color.alcheSecondaryText)
                }
            }
        }
    }

    private func formattedPrice(_ cents: Int) -> String {
        let euros = Double(cents) / 100.0
        return String(format: "EUR %.2f", euros)
    }
}

// MARK: - Cart Item Row

private struct CartItemRow: View {
    let item: ShopViewModel.CartItem
    let isMember: Bool
    let onIncrease: () -> Void
    let onDecrease: () -> Void

    var body: some View {
        HStack(spacing: AlcheSpacing.md) {
            // Product thumbnail
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .fill(Color.alcheWarmGray.opacity(0.5))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "leaf")
                        .foregroundStyle(Color.alcheSecondaryText.opacity(0.4))
                )

            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text(item.product.name)
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alchePrimaryText)
                    .lineLimit(1)

                if isMember {
                    Text(item.product.formattedMemberPrice)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alchePrimaryText)
                } else {
                    Text(item.product.formattedPrice)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alchePrimaryText)
                }
            }

            Spacer()

            // Quantity controls
            HStack(spacing: AlcheSpacing.md) {
                Button(action: onDecrease) {
                    Image(systemName: "minus.circle")
                        .foregroundStyle(Color.alcheSecondaryText)
                }

                Text("\(item.quantity)")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alchePrimaryText)
                    .frame(width: 24)

                Button(action: onIncrease) {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(Color.alchePrimary)
                }
            }
        }
        .padding(AlcheSpacing.md)
        .background(Color.alcheWarmGray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
    }
}

#Preview {
    CartView(viewModel: ShopViewModel())
}
