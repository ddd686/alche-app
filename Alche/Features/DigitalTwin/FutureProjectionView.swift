import SwiftUI

struct FutureProjectionView: View {
    let projections: [FutureProjection]

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
            Text("YOUR FUTURE SELF")
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheSecondaryText)
                .tracking(0.8)

            Text("Where you could be in 12 weeks if you follow your protocols")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSecondaryText)

            if projections.isEmpty {
                HStack(spacing: AlcheSpacing.sm) {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(Color.alcheSage)
                    Text("All regions are looking well-balanced. Keep it up.")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alchePrimaryText)
                }
                .padding(AlcheSpacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.alcheSage.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
            } else {
                ForEach(projections, id: \.region) { projection in
                    ProjectionRow(projection: projection)
                }
            }
        }
    }
}

// MARK: - Projection Row

private struct ProjectionRow: View {
    let projection: FutureProjection

    var body: some View {
        HStack(spacing: AlcheSpacing.md) {
            // Current → Future
            VStack(spacing: 2) {
                Text("\(projection.currentScore)")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alcheSecondaryText)
                Text("now")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
            .frame(width: 40)

            Image(systemName: "arrow.right")
                .font(.alcheCaption)
                .foregroundStyle(Color.alcheSage)

            VStack(spacing: 2) {
                Text("\(projection.projectedScore)")
                    .font(.alcheBodyMedium)
                    .foregroundStyle(Color.alcheSage)
                Text("\(projection.timeframeWeeks)w")
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
            }
            .frame(width: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(projection.region.displayName)
                    .font(.alcheSubheading)
                    .foregroundStyle(Color.alchePrimaryText)

                HStack(spacing: AlcheSpacing.xs) {
                    Image(systemName: "arrow.up.right")
                        .font(.alcheOverline)
                    Text("+\(projection.improvement) points")
                        .font(.alcheCaption)
                }
                .foregroundStyle(Color.alcheSage)
            }

            Spacer()
        }
        .padding(AlcheSpacing.sm)
        .background(Color.alcheWarmGray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }
}

#Preview {
    FutureProjectionView(
        projections: DigitalTwinState.preview.futureProjection ?? []
    )
    .padding()
    .background(Color.alcheBackground)
}
