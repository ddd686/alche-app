import SwiftUI

// MARK: - Hormonal Balance / Cycle Tracker
// Design source: variant-3-5bbe — Hormonal Balance Screen

struct HormonalBalanceView: View {
    // MARK: - Mock Data

    private let currentPhase = "Late Follicular"
    private let cycleDay = 12
    private let cycleTotalDays = 28
    private let dailyInsight = "Estrogen is boosting your energy and verbal skills. Connect with your community today."
    private let lastUpdate = "14:02 PM"
    private let isOuraSynced = true

    @Environment(\.dismiss) private var dismiss
    @State private var chartAnimated = false

    var body: some View {
        VStack(spacing: 0) {
            headerBar

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: AlcheSpacing.xl) {
                    phaseHeader
                    cycleChart
                    hormonalMetricsGrid
                    dailyInsightSection
                }
                .padding(.horizontal, AlcheSpacing.lg)
                .padding(.top, AlcheSpacing.lg)
                .padding(.bottom, AlcheSpacing.md)
            }

            syncFooter
        }
        .background(Color.alcheWhite)
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 2.5)) {
                chartAnimated = true
            }
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.alcheEditorialBlack)
            }

            Spacer()

            Text("Hormonal Balance")
                .font(.alcheOverlineTiny)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundStyle(Color.alcheEditorialMuted)
        }
        .padding(.horizontal, AlcheSpacing.lg)
        .padding(.top, AlcheSpacing.lg)
        .padding(.bottom, AlcheSpacing.md)
        .background(
            Color.alcheWhite.opacity(0.8)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.alcheEditorialBlack.opacity(0.05))
                .frame(height: 1)
        }
    }

    // MARK: - Phase Header

    private var phaseHeader: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text("Current Phase")
                    .font(.alcheOverline)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alchePastelIndigo)

                HStack(alignment: .firstTextBaseline, spacing: AlcheSpacing.sm) {
                    Text("Late")
                        .font(.custom("Newsreader16pt-LightItalic", size: 30, relativeTo: .title))
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Text("Follicular")
                        .font(.custom("Newsreader16pt-Italic", size: 30, relativeTo: .title))
                        .foregroundStyle(Color.alcheEditorialBlack)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                Text("Cycle Day")
                    .font(.alcheOverline)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(cycleDay)")
                        .font(.custom("SpaceMono-Regular", size: 24, relativeTo: .title2))
                        .foregroundStyle(Color.alcheEditorialBlack)

                    Text("/\(cycleTotalDays)")
                        .font(.alcheCaption)
                        .foregroundStyle(Color.alcheEditorialMuted)
                }
            }
        }
    }

    // MARK: - Cycle Chart

    private var cycleChart: some View {
        ZStack(alignment: .topLeading) {
            // Border + grid background
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .fill(Color.alcheWhite)
                .overlay(
                    RoundedRectangle(cornerRadius: AlcheRadii.sm)
                        .stroke(Color.alcheEditorialBlack.opacity(0.1), lineWidth: 1)
                )
                .overlay(chartGridPattern)

            // Chart curves
            GeometryReader { geo in
                let chartInset: CGFloat = 16
                let width = geo.size.width - chartInset * 2
                let height = geo.size.height - chartInset * 2

                ZStack {
                    // Cortisol curve (indigo, lower opacity)
                    cortisolCurve(in: CGSize(width: width, height: height))
                        .stroke(
                            Color.alchePastelIndigo.opacity(0.4),
                            lineWidth: 2
                        )
                        .offset(x: chartInset, y: chartInset)

                    // Estrogen curve (rose, prominent)
                    estrogenCurve(in: CGSize(width: width, height: height))
                        .trim(from: 0, to: chartAnimated ? 1 : 0)
                        .stroke(
                            Color.alchePastelRose,
                            lineWidth: 3
                        )
                        .offset(x: chartInset, y: chartInset)

                    // Ovulation dashed line
                    Path { path in
                        let x = chartInset + width * 0.375
                        path.move(to: CGPoint(x: x, y: chartInset))
                        path.addLine(to: CGPoint(x: x, y: geo.size.height - chartInset))
                    }
                    .stroke(
                        Color.alcheEditorialBlack.opacity(0.8),
                        style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                    )

                    // Peak dot
                    Circle()
                        .fill(Color.alcheWhite)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(Color.alchePastelRose, lineWidth: 2)
                        )
                        .position(
                            x: chartInset + width * 0.375,
                            y: chartInset + height * 0.2
                        )
                }

                // Estrogen Peak callout
                estrogenPeakLabel
                    .position(
                        x: chartInset + width * 0.42,
                        y: chartInset + height * 0.12
                    )
            }

            // Day labels
            VStack {
                Spacer()
                HStack {
                    Text("DAY 1")
                        .font(.custom("SpaceMono-Regular", size: 8, relativeTo: .caption2))
                        .foregroundStyle(Color.alcheEditorialMuted)

                    Spacer()

                    Text("OVULATION")
                        .font(.custom("SpaceMono-Regular", size: 8, relativeTo: .caption2))
                        .foregroundStyle(Color.alcheEditorialMuted)

                    Spacer()

                    Text("DAY 28")
                        .font(.custom("SpaceMono-Regular", size: 8, relativeTo: .caption2))
                        .foregroundStyle(Color.alcheEditorialMuted)
                }
                .padding(.horizontal, AlcheSpacing.sm)
                .padding(.bottom, AlcheSpacing.sm)
            }
        }
        .frame(height: 240)
    }

    private var chartGridPattern: some View {
        Canvas { context, size in
            let spacing: CGFloat = 24
            let lineColor = Color(red: 0.945, green: 0.96, blue: 0.976).opacity(0.6)

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
        .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
    }

    // Estrogen: rises sharply to peak near ovulation, then drops
    private func estrogenCurve(in size: CGSize) -> Path {
        Path { path in
            let w = size.width
            let h = size.height

            path.move(to: CGPoint(x: 0, y: h * 0.7))
            path.addCurve(
                to: CGPoint(x: w * 0.4, y: h * 0.15),
                control1: CGPoint(x: w * 0.12, y: h * 0.7),
                control2: CGPoint(x: w * 0.25, y: h * 0.2)
            )
            path.addCurve(
                to: CGPoint(x: w * 0.62, y: h * 0.65),
                control1: CGPoint(x: w * 0.5, y: h * 0.12),
                control2: CGPoint(x: w * 0.55, y: h * 0.55)
            )
            path.addCurve(
                to: CGPoint(x: w, y: h * 0.65),
                control1: CGPoint(x: w * 0.7, y: h * 0.75),
                control2: CGPoint(x: w * 0.85, y: h * 0.55)
            )
        }
    }

    // Cortisol: gentler, lower amplitude curve
    private func cortisolCurve(in size: CGSize) -> Path {
        Path { path in
            let w = size.width
            let h = size.height

            path.move(to: CGPoint(x: 0, y: h * 0.85))
            path.addCurve(
                to: CGPoint(x: w * 0.45, y: h * 0.75),
                control1: CGPoint(x: w * 0.2, y: h * 0.85),
                control2: CGPoint(x: w * 0.37, y: h * 0.75)
            )
            path.addCurve(
                to: CGPoint(x: w * 0.7, y: h * 0.25),
                control1: CGPoint(x: w * 0.53, y: h * 0.75),
                control2: CGPoint(x: w * 0.6, y: h * 0.25)
            )
            path.addCurve(
                to: CGPoint(x: w, y: h * 0.75),
                control1: CGPoint(x: w * 0.8, y: h * 0.25),
                control2: CGPoint(x: w * 0.88, y: h * 0.65)
            )
        }
    }

    private var estrogenPeakLabel: some View {
        HStack(spacing: AlcheSpacing.xs) {
            Circle()
                .fill(Color.alchePastelRose)
                .frame(width: 6, height: 6)

            Text("Estrogen Peak")
                .font(.custom("SpaceMono-Regular", size: 9, relativeTo: .caption2))
                .textCase(.uppercase)
                .tracking(1)
                .foregroundStyle(Color.alcheEditorialBlack)
        }
        .padding(.horizontal, AlcheSpacing.sm)
        .padding(.vertical, AlcheSpacing.xs + 1)
        .background(
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .fill(Color.alcheWhite.opacity(0.9))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: AlcheRadii.sm))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AlcheRadii.sm)
                .stroke(Color.alcheEditorialBlack.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - 2x2 Hormonal Metrics Grid

    private var hormonalMetricsGrid: some View {
        VStack(spacing: 1) {
            HStack(spacing: 1) {
                hormonalMetricCell(
                    label: "Cortisol",
                    value: "Stable",
                    valueStyle: .displayItalic,
                    subtitle: "+2% vs avg",
                    trailingIcon: "checkmark.circle",
                    trailingIconColor: .alchePastelSage
                )

                hormonalMetricCell(
                    label: "Estrogen",
                    value: "Surging",
                    valueStyle: .displayItalic,
                    subtitle: "Pre-ovulatory",
                    trailingIcon: "arrow.up.right",
                    trailingIconColor: .alchePastelRose
                )
            }

            HStack(spacing: 1) {
                hormonalMetricCellWithBar(
                    label: "Temp (BBT)",
                    value: "97.4\u{00B0}F",
                    progress: 0.4,
                    progressColor: .alchePastelIndigo
                )

                hormonalMetricCell(
                    label: "Readiness",
                    value: "High",
                    valueStyle: .mono,
                    subtitle: "Ideal for HIIT training today.",
                    subtitleStyle: .insight,
                    trailingIcon: nil,
                    trailingIconColor: .clear
                )
            }
        }
        .background(Color.alcheEditorialBlack.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.alcheEditorialBlack.opacity(0.05), lineWidth: 1)
        )
    }

    private enum MetricValueStyle {
        case displayItalic
        case mono
    }

    private enum MetricSubtitleStyle {
        case standard
        case insight
    }

    private func hormonalMetricCell(
        label: String,
        value: String,
        valueStyle: MetricValueStyle = .displayItalic,
        subtitle: String? = nil,
        subtitleStyle: MetricSubtitleStyle = .standard,
        trailingIcon: String?,
        trailingIconColor: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top row: label + icon
            HStack {
                Text(label)
                    .font(.alcheOverlineTiny)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)

                Spacer()

                if let icon = trailingIcon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(trailingIconColor)
                }
            }

            Spacer()

            // Value
            switch valueStyle {
            case .displayItalic:
                Text(value)
                    .font(.custom("Newsreader16pt-Italic", size: 18, relativeTo: .body))
                    .foregroundStyle(Color.alcheEditorialBlack)
            case .mono:
                Text(value)
                    .font(.custom("SpaceMono-Regular", size: 18, relativeTo: .body))
                    .foregroundStyle(Color.alcheEditorialBlack)
            }

            // Subtitle
            if let subtitle {
                switch subtitleStyle {
                case .standard:
                    Text(subtitle)
                        .font(.alcheOverline)
                        .foregroundStyle(Color.alcheEditorialMuted)
                        .padding(.top, AlcheSpacing.xs)
                case .insight:
                    Text(subtitle)
                        .font(.custom("Newsreader16pt-Italic", size: 10, relativeTo: .caption2))
                        .foregroundStyle(Color.alcheEditorialMuted)
                        .lineSpacing(1)
                        .padding(.top, AlcheSpacing.xs)
                }
            }
        }
        .padding(AlcheSpacing.md + 4)
        .frame(height: 128)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.alcheWhite)
    }

    private func hormonalMetricCellWithBar(
        label: String,
        value: String,
        progress: CGFloat,
        progressColor: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.alcheOverlineTiny)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .tracking(2)
                .foregroundStyle(Color.alcheEditorialMuted)

            Spacer()

            Text(value)
                .font(.custom("SpaceMono-Regular", size: 18, relativeTo: .body))
                .foregroundStyle(Color.alcheEditorialBlack)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: AlcheRadii.full)
                        .fill(Color.alcheWarmGray)
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: AlcheRadii.full)
                        .fill(progressColor)
                        .frame(width: geo.size.width * progress, height: 4)
                }
            }
            .frame(height: 4)
            .padding(.top, AlcheSpacing.sm)
        }
        .padding(AlcheSpacing.md + 4)
        .frame(height: 128)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.alcheWhite)
    }

    // MARK: - Daily Insight Quote

    private var dailyInsightSection: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm + 4) {
            HStack(alignment: .top, spacing: AlcheSpacing.md) {
                Rectangle()
                    .fill(Color.alchePastelRose)
                    .frame(width: 2)

                Text("\u{201C}\(dailyInsight)\u{201D}")
                    .font(.custom("Newsreader16pt-Italic", size: 18, relativeTo: .body))
                    .foregroundStyle(Color.alcheEditorialBlack)
                    .lineSpacing(3)
            }
            .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: AlcheSpacing.sm) {
                Rectangle()
                    .fill(Color.alcheEditorialBlack.opacity(0.2))
                    .frame(width: 32, height: 1)

                Text("Daily Insight")
                    .font(.alcheOverlineTiny)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)
            }
        }
    }

    // MARK: - Sync Footer

    private var syncFooter: some View {
        HStack {
            VStack(alignment: .leading, spacing: AlcheSpacing.xs) {
                Text("Oura Sync")
                    .font(.alcheOverlineTiny)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)

                HStack(spacing: AlcheSpacing.sm) {
                    Circle()
                        .fill(Color.alchePastelSage)
                        .frame(width: 6, height: 6)

                    Text("Connected")
                        .font(.custom("Newsreader16pt-Italic", size: 13, relativeTo: .footnote))
                        .foregroundStyle(Color.alcheEditorialBlack)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AlcheSpacing.xs) {
                Text("Last Update")
                    .font(.alcheOverlineTiny)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundStyle(Color.alcheEditorialMuted)

                Text(lastUpdate)
                    .font(.alcheMono)
                    .foregroundStyle(Color.alcheEditorialBlack)
            }
        }
        .padding(.horizontal, AlcheSpacing.xl)
        .padding(.vertical, AlcheSpacing.lg)
        .background(Color.alcheWhite)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.alcheEditorialBlack.opacity(0.05))
                .frame(height: 1)
        }
    }

}

// MARK: - Preview

#Preview("Hormonal Balance") {
    HormonalBalanceView()
}
