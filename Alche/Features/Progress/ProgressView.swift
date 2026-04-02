import SwiftUI

struct WellnessProgressView: View {
    @State private var viewModel = ProgressViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AlcheSpacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text("Progress")
                        .font(.alcheDisplayL)
                        .foregroundStyle(Color.alchePrimaryText)

                    Text("Track your wellness trends over time.")
                        .font(.alcheBody)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Summary cards
                HStack(spacing: AlcheSpacing.md) {
                    SummaryCard(
                        title: "Average",
                        value: String(format: "%.1f", viewModel.currentAverage),
                        subtitle: viewModel.selectedMetric.rawValue,
                        color: metricColor
                    )

                    SummaryCard(
                        title: "Trend",
                        value: viewModel.trend.label,
                        icon: viewModel.trend.icon,
                        color: trendColor
                    )

                    SummaryCard(
                        title: "Streak",
                        value: "\(viewModel.streakDays)",
                        subtitle: "days",
                        color: .alchePrimary
                    )
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Metric picker
                Picker("Metric", selection: $viewModel.selectedMetric) {
                    ForEach(ProgressViewModel.Metric.allCases, id: \.self) { metric in
                        Text(metric.rawValue).tag(metric)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AlcheSpacing.lg)

                // Chart
                AlcheCard(shadow: .medium) {
                    VStack(alignment: .leading, spacing: AlcheSpacing.md) {
                        HStack {
                            Text(viewModel.selectedMetric.rawValue.uppercased())
                                .font(.alcheOverline)
                                .foregroundStyle(Color.alcheSecondaryText)
                                .tracking(0.8)

                            Spacer()

                            // Range picker
                            Picker("Range", selection: $viewModel.selectedRange) {
                                ForEach(ProgressViewModel.DateRange.allCases, id: \.self) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 160)
                        }

                        TrendChart(
                            data: viewModel.chartData,
                            color: metricColor,
                            minValue: 1,
                            maxValue: 5
                        )
                        .frame(height: 180)
                    }
                }
                .padding(.horizontal, AlcheSpacing.lg)

                // Recent check-ins
                VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
                    Text("RECENT CHECK-INS")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .tracking(0.8)
                        .padding(.horizontal, AlcheSpacing.lg)

                    LazyVStack(spacing: AlcheSpacing.sm) {
                        ForEach(viewModel.filteredCheckins.reversed().prefix(10)) { checkin in
                            CheckinRow(checkin: checkin)
                        }
                    }
                    .padding(.horizontal, AlcheSpacing.lg)
                }
            }
            .padding(.top, AlcheSpacing.md)
            .padding(.bottom, AlcheSpacing.xxl)
        }
        .background(Color.alcheBackground)
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadProgress()
        }
    }

    private var metricColor: Color {
        switch viewModel.selectedMetric {
        case .energy: .alchePrimary
        case .sleep: .alcheInfo
        case .mood: .alcheSage
        case .overall: .alcheAmber
        }
    }

    private var trendColor: Color {
        switch viewModel.trend {
        case .up: .alcheSage
        case .down: .alcheError
        case .neutral: .alcheSecondaryText
        }
    }
}

// MARK: - Summary Card

private struct SummaryCard: View {
    let title: String
    let value: String
    var subtitle: String? = nil
    var icon: String? = nil
    let color: Color

    var body: some View {
        AlcheCard {
            VStack(spacing: AlcheSpacing.xs) {
                Text(title.uppercased())
                    .font(.alcheOverline)
                    .foregroundStyle(Color.alcheSecondaryText)
                    .tracking(0.5)

                if let icon {
                    HStack(spacing: 4) {
                        Image(systemName: icon)
                            .font(.alcheCaption)
                        Text(value)
                            .font(.alcheBodyMedium)
                    }
                    .foregroundStyle(color)
                } else {
                    Text(value)
                        .font(.alcheHeading)
                        .foregroundStyle(color)
                }

                if let subtitle {
                    Text(subtitle)
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Trend Chart

private struct TrendChart: View {
    let data: [(date: Date, value: Double)]
    let color: Color
    let minValue: Double
    let maxValue: Double

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let insetHeight = height - 24 // Room for date labels

            ZStack(alignment: .topLeading) {
                // Grid lines
                ForEach(1...5, id: \.self) { level in
                    let y = insetHeight - (CGFloat(level - 1) / CGFloat(maxValue - minValue)) * insetHeight
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    .stroke(Color.alcheWarmGray, lineWidth: 0.5)

                    Text("\(level)")
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheSecondaryText)
                        .position(x: -6, y: y)
                }

                if data.count >= 2 {
                    // Area fill
                    Path { path in
                        let points = chartPoints(width: width, height: insetHeight)
                        guard let first = points.first else { return }

                        path.move(to: CGPoint(x: first.x, y: insetHeight))
                        path.addLine(to: first)

                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }

                        path.addLine(to: CGPoint(x: points.last!.x, y: insetHeight))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.2), color.opacity(0.02)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    // Line
                    Path { path in
                        let points = chartPoints(width: width, height: insetHeight)
                        guard let first = points.first else { return }

                        path.move(to: first)
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                    // Dots
                    ForEach(Array(chartPoints(width: width, height: insetHeight).enumerated()), id: \.offset) { _, point in
                        Circle()
                            .fill(color)
                            .frame(width: 6, height: 6)
                            .position(point)
                    }
                }

                // Date labels
                if let first = data.first, let last = data.last {
                    HStack {
                        Text(shortDate(first.date))
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)

                        Spacer()

                        Text(shortDate(last.date))
                            .font(.alcheOverline)
                            .foregroundStyle(Color.alcheSecondaryText)
                    }
                    .offset(y: insetHeight + 6)
                }
            }
            .padding(.leading, 16)
        }
    }

    private func chartPoints(width: CGFloat, height: CGFloat) -> [CGPoint] {
        guard data.count >= 2 else { return [] }

        let adjustedWidth = width - 16 // Account for left padding
        return data.enumerated().map { index, entry in
            let x = CGFloat(index) / CGFloat(data.count - 1) * adjustedWidth
            let normalized = (entry.value - minValue) / (maxValue - minValue)
            let y = height - CGFloat(normalized) * height
            return CGPoint(x: x, y: y)
        }
    }

    private func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
}

// MARK: - Check-in Row

private struct CheckinRow: View {
    let checkin: DailyCheckin

    var body: some View {
        AlcheCard {
            HStack(spacing: AlcheSpacing.md) {
                VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                    Text(formattedDate)
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheSecondaryText)

                    if let notes = checkin.notes {
                        Text(notes)
                            .font(.alcheCaption)
                            .foregroundStyle(Color.alchePrimaryText)
                            .lineLimit(1)
                    }
                }

                Spacer()

                HStack(spacing: AlcheSpacing.md) {
                    MetricDot(value: checkin.energy, label: "E", color: .alchePrimary)
                    MetricDot(value: checkin.sleepQuality, label: "S", color: .alcheInfo)
                    MetricDot(value: checkin.mood, label: "M", color: .alcheSage)
                }
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        return formatter.string(from: checkin.date)
    }
}

// MARK: - Metric Dot

private struct MetricDot: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.alcheBodyMedium)
                .foregroundStyle(color)
            Text(label)
                .font(.alcheOverline)
                .foregroundStyle(Color.alcheSecondaryText)
        }
    }
}

#Preview {
    NavigationStack {
        WellnessProgressView()
    }
}
