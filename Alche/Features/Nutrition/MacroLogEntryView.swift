import SwiftUI

struct MacroLogEntryView: View {
    @Bindable var viewModel: MacroDashboardViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case name
        case calories
        case protein
        case carbs
        case fat
        case fiber
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                        Text("Log a Meal")
                            .font(.alcheDisplayL)
                            .foregroundStyle(Color.alchePrimaryText)

                        Text("Track what you eat to support your wellness goals.")
                            .font(.alcheBody)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                    .padding(.horizontal, AlcheSpacing.lg)

                    // Meal name
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("MEAL NAME")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        TextField("e.g. Avocado Toast", text: $viewModel.manualName)
                            .font(.alcheBody)
                            .padding(AlcheSpacing.md)
                            .background(Color.alcheSurface)
                            .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
                            .overlay(
                                RoundedRectangle(cornerRadius: AlcheRadii.md)
                                    .stroke(Color.alcheWarmGray, lineWidth: 1)
                            )
                            .focused($focusedField, equals: .name)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .calories }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)

                    // Meal type picker
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("MEAL TYPE")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        MealTypePicker(selectedType: $viewModel.manualMealType)
                    }
                    .padding(.horizontal, AlcheSpacing.lg)

                    // Nutrition fields
                    VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                        Text("NUTRITION")
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                            .tracking(0.8)

                        NutritionField(
                            label: "Calories",
                            unit: "kcal",
                            value: $viewModel.manualCalories,
                            color: .alchePrimary
                        )
                        .focused($focusedField, equals: .calories)

                        NutritionField(
                            label: "Protein",
                            unit: "g",
                            value: $viewModel.manualProtein,
                            color: .alcheSage
                        )
                        .focused($focusedField, equals: .protein)

                        NutritionField(
                            label: "Carbs",
                            unit: "g",
                            value: $viewModel.manualCarbs,
                            color: .alcheAmber
                        )
                        .focused($focusedField, equals: .carbs)

                        NutritionField(
                            label: "Fat",
                            unit: "g",
                            value: $viewModel.manualFat,
                            color: .alchePrimary
                        )
                        .focused($focusedField, equals: .fat)

                        NutritionField(
                            label: "Fiber",
                            unit: "g",
                            value: $viewModel.manualFiber,
                            color: .alcheSecondaryText
                        )
                        .focused($focusedField, equals: .fiber)
                    }
                    .padding(.horizontal, AlcheSpacing.lg)

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alcheError)
                            .padding(.horizontal, AlcheSpacing.lg)
                    }

                    // Log button
                    AlcheButton(
                        "Log Meal",
                        style: .primary,
                        icon: "plus.circle"
                    ) {
                        focusedField = nil
                        Task { await viewModel.logManualEntry() }
                    }
                    .disabled(!viewModel.isManualEntryValid)
                    .opacity(viewModel.isManualEntryValid ? 1.0 : 0.5)
                    .padding(.horizontal, AlcheSpacing.lg)

                    // Sample data indicator
                    HStack {
                        Spacer()
                        DataSourceIndicator(isMock: true)
                        Spacer()
                    }
                }
                .padding(.top, AlcheSpacing.md)
                .padding(.bottom, AlcheSpacing.xxl)
            }
            .background(Color.alcheBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.alchePrimary)
                }
            }
        }
    }
}

// MARK: - Meal Type Picker

private struct MealTypePicker: View {
    @Binding var selectedType: MealType

    var body: some View {
        HStack(spacing: AlcheSpacing.sm) {
            ForEach(MealType.allCases, id: \.self) { type in
                let isSelected = selectedType == type

                Button {
                    selectedType = type
                } label: {
                    VStack(spacing: AlcheSpacing.xs) {
                        Image(systemName: type.icon)
                            .font(.alcheBody)
                        Text(type.displayName)
                            .font(.alcheOverline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AlcheSpacing.sm)
                    .foregroundStyle(isSelected ? Color.alcheWhite : Color.alchePrimaryText)
                    .background(isSelected ? Color.alchePrimary : Color.alcheWarmGray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Nutrition Field

private struct NutritionField: View {
    let label: String
    let unit: String
    @Binding var value: String
    var color: Color = .alchePrimary

    var body: some View {
        HStack(spacing: AlcheSpacing.md) {
            // Color indicator
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(label)
                .font(.alcheBody)
                .foregroundStyle(Color.alchePrimaryText)
                .frame(width: 64, alignment: .leading)

            TextField("0", text: $value)
                .font(.alcheBody)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity)

            Text(unit)
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSecondaryText)
                .frame(width: 32, alignment: .leading)
        }
        .padding(.horizontal, AlcheSpacing.md)
        .padding(.vertical, AlcheSpacing.sm)
        .background(Color.alcheSurface)
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .stroke(Color.alcheWarmGray, lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    MacroLogEntryView(viewModel: MacroDashboardViewModel())
}
