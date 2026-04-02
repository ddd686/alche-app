import SwiftUI

// MARK: - Biological Age Card
// Design source: variant-4-81e2 — Profile / Biological Age Archive
// Embeddable card component — no own ScrollView, header, or bottom nav.

struct BiologicalAgeCard: View {
    let profile: BiomarkerProfile

    private let subjectId = "042"
    private let archiveRef = "A-99"
    private let clockSpeed = 0.82
    private let metabolicRate = "1,420"
    private let hrvMean = 68
    private let hydrationPercent = 94
    private let telomereInsight = "Telomere length is in the top 5% for your demographic."
    private let lastBiopsy = "12 Oct 2023"

    var body: some View {
        VStack(spacing: 0) {
            compactHeader
            heroSection
            metricsGrid
            molecularInsightsSection
        }
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.md))
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.md)
                .stroke(Color.alcheEditorialBlack.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Compact Header

    private var compactHeader: some View {
        HStack {
            HStack(spacing: AlcheSpacing.sm) {
                Image(systemName: "folder")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.alcheEditorialBlack)

                VStack(alignment: .leading, spacing: 1) {
                    Text("Subject: \(subjectId)")
                        .font(.alcheOverlineTiny)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .tracking(1.5)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Text("Archive Ref. \(archiveRef)")
                        .font(.custom("SpaceMono-Regular", size: 8, relativeTo: .caption2))
                        .textCase(.uppercase)
                        .tracking(2)
                        .foregroundStyle(Color.alcheEditorialMuted)
                }
            }

            Spacer()

            verifiedBadge
        }
        .padding(.horizontal, AlcheSpacing.md)
        .padding(.vertical, AlcheSpacing.sm)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.alcheEditorialBlack)
                .frame(height: 1)
        }
        .background(Color.alcheLightGray)
    }

    private var verifiedBadge: some View {
        HStack(spacing: AlcheSpacing.xs) {
            Circle()
                .fill(Color.alcheSuccess)
                .frame(width: 6, height: 6)

            Text("Verified")
                .font(.alcheOverlineTiny)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .tracking(2)
                .foregroundStyle(Color.alcheWhite)
        }
        .padding(.horizontal, AlcheSpacing.sm)
        .padding(.vertical, AlcheSpacing.xs)
        .background(
            Capsule()
                .fill(Color.alcheEditorialBlack)
        )
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 0) {
            VStack(spacing: AlcheSpacing.sm) {
                Text("Biological Age Calculation")
                    .font(.alcheOverline)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .tracking(1.5)
                    .foregroundStyle(Color.alcheEditorialMuted)
                    .padding(.horizontal, AlcheSpacing.sm + 4)
                    .padding(.vertical, AlcheSpacing.xs)
                    .overlay(
                        Capsule()
                            .stroke(Color.alcheEditorialMuted.opacity(0.3), lineWidth: 1)
                    )

                heroAgeNumber

                HStack(spacing: AlcheSpacing.sm + 4) {
                    Text("Chronological: \(profile.chronologicalAge) yrs")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Rectangle()
                        .fill(Color.alcheEditorialBlack.opacity(0.2))
                        .frame(width: 1, height: 12)

                    Text(String(format: "%.1f Delta", -profile.ageDifference))
                        .font(.alcheCaption)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.alchePrimary)
                }
                .padding(.top, AlcheSpacing.xs)
            }
            .padding(.vertical, AlcheSpacing.xxl)
            .frame(maxWidth: .infinity)
            .background(gridPatternBackground)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.alcheEditorialBlack)
                    .frame(height: 1)
            }
        }
    }

    private var heroAgeNumber: some View {
        let integerPart = Int(profile.biologicalAge)
        let decimalPart = profile.biologicalAge - Double(integerPart)
        let decimalString = String(format: ".%d", Int(decimalPart * 10))

        return ZStack(alignment: .topTrailing) {
            HStack(alignment: .top, spacing: -4) {
                Text("\(integerPart)")
                    .font(.custom("Newsreader-LightItalic", size: 108, relativeTo: .largeTitle))
                    .foregroundStyle(Color.alcheEditorialBlack)

                Text(decimalString)
                    .font(.custom("Newsreader-Light", size: 64, relativeTo: .largeTitle))
                    .foregroundStyle(Color.alcheEditorialBlack)
                    .offset(y: 4)
            }

            Text("*")
                .font(.custom("Newsreader-Regular", size: 36, relativeTo: .title))
                .foregroundStyle(Color.alchePrimary)
                .offset(x: 16, y: 8)
        }
    }

    private var gridPatternBackground: some View {
        Color.alcheWhite
            .overlay(
                Canvas { context, size in
                    let spacing: CGFloat = 20
                    let lineColor = Color.alcheEditorialBlack.opacity(0.03)

                    for x in stride(from: 0, through: size.width, by: spacing) {
                        var path = Path()
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                        context.stroke(path, with: .color(lineColor), lineWidth: 1)
                    }
                    for y in stride(from: 0, through: size.height, by: spacing) {
                        var path = Path()
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(lineColor), lineWidth: 1)
                    }
                }
            )
    }

    // MARK: - 2x2 Metrics Grid

    private var metricsGrid: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                metricCell(
                    icon: "clock",
                    value: String(format: "%.2f", clockSpeed),
                    label: "Clock Speed",
                    sublabel: "DunedinPACE",
                    badge: MetricBadge(text: "OPTIMAL", color: .alcheSuccess, bgColor: Color.alcheSuccess.opacity(0.08)),
                    showRightBorder: true
                )
                metricCell(
                    icon: "flame",
                    value: metabolicRate,
                    label: "Metabolic Rate",
                    sublabel: "Kcal / Resting",
                    badge: nil,
                    showRightBorder: false
                )
            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.alcheEditorialBlack)
                    .frame(height: 1)
            }

            HStack(spacing: 0) {
                metricCell(
                    icon: "waveform.path.ecg",
                    value: "\(hrvMean)",
                    label: "HRV Mean",
                    sublabel: "Milliseconds",
                    badge: MetricBadge(text: "RISING", color: .alchePrimary, bgColor: Color.alchePrimary.opacity(0.05)),
                    showRightBorder: true
                )
                metricCell(
                    icon: "drop",
                    value: "\(hydrationPercent)%",
                    label: "Hydration",
                    sublabel: "Intracellular",
                    badge: nil,
                    showRightBorder: false
                )
            }
        }
    }

    private struct MetricBadge {
        let text: String
        let color: Color
        let bgColor: Color
    }

    private func metricCell(
        icon: String,
        value: String,
        label: String,
        sublabel: String,
        badge: MetricBadge?,
        showRightBorder: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.alcheEditorialMuted)

                Spacer()

                if let badge {
                    Text(badge.text)
                        .font(.alcheOverlineTiny)
                        .fontWeight(.bold)
                        .foregroundStyle(badge.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                                .fill(badge.bgColor)
                        )
                }
            }

            Text(value)
                .font(.alcheDisplayL)
                .foregroundStyle(Color.alcheEditorialBlack)
                .padding(.top, AlcheSpacing.xs)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.alcheOverlineTiny)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)

                Text(sublabel)
                    .font(.custom("Newsreader-Italic", size: 10, relativeTo: .caption2))
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
        }
        .padding(AlcheSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.alcheWhite)
        .overlay(alignment: .trailing) {
            if showRightBorder {
                Rectangle()
                    .fill(Color.alcheEditorialBlack)
                    .frame(width: 1)
            }
        }
    }

    // MARK: - Molecular Insights

    private var molecularInsightsSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.md) {
            HStack {
                Text("Molecular Insights")
                    .font(.alcheCaption)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialBlack)

                Spacer()

                Image(systemName: "DNA")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.alcheEditorialMuted)
                    .symbolRenderingMode(.monochrome)
            }

            HStack(alignment: .center, spacing: AlcheSpacing.md) {
                Rectangle()
                    .fill(Color.alcheEditorialBlack)
                    .frame(width: 3, height: 40)

                Text(telomereInsight)
                    .font(.custom("Newsreader-Italic", size: 18, relativeTo: .body))
                    .foregroundStyle(Color.alcheEditorialBlack)
                    .lineSpacing(2)
            }

            Rectangle()
                .fill(Color.alcheEditorialBlack.opacity(0.05))
                .frame(height: 1)

            HStack {
                Text("Last Biopsy: \(lastBiopsy)")
                    .font(.alcheOverline)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.alcheEditorialMuted)

                Spacer()

                Button {
                } label: {
                    Text("View Report")
                        .font(.alcheOverline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.alchePrimary)
                        .underline()
                }
            }
        }
        .padding(AlcheSpacing.lg)
        .background(Color.alcheLightGray)
    }
}

// MARK: - Preview

#Preview("Biological Age Card") {
    ScrollView {
        BiologicalAgeCard(
            profile: BiomarkerProfile(
                id: UUID(),
                userId: UUID(),
                biologicalAge: 28.4,
                chronologicalAge: 32,
                overallScore: 82,
                isMock: true,
                source: .mock,
                recordedAt: Date()
            )
        )
        .padding(.horizontal, AlcheSpacing.lg)
    }
    .background(Color.alcheBackground)
}
