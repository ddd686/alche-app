import SwiftUI

struct MarkerTrendChart: View {
    let dataPoints: [Double]
    let referenceMin: Double?
    let referenceMax: Double?
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: AlcheSpacing.sm) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height

                ZStack {
                    // Reference range band
                    if let minRef = referenceMin, let maxRef = referenceMax {
                        let yMin = yPosition(for: maxRef, in: height)
                        let yMax = yPosition(for: minRef, in: height)
                        Rectangle()
                            .fill(Color.alcheSage.opacity(0.1))
                            .frame(height: max(0, yMax - yMin))
                            .offset(y: yMin)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }

                    // Line chart
                    if dataPoints.count > 1 {
                        Path { path in
                            for (index, value) in dataPoints.enumerated() {
                                let x = xPosition(for: index, count: dataPoints.count, in: width)
                                let y = yPosition(for: value, in: height)

                                if index == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                        // Data points
                        ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, value in
                            Circle()
                                .fill(color)
                                .frame(width: 6, height: 6)
                                .position(
                                    x: xPosition(for: index, count: dataPoints.count, in: width),
                                    y: yPosition(for: value, in: height)
                                )
                        }
                    }
                }
            }
            .frame(height: 120)
        }
    }

    // MARK: - Helpers

    private var chartMin: Double {
        let dataMin = dataPoints.min() ?? 0
        let refMin = referenceMin ?? dataMin
        return min(dataMin, refMin) * 0.9
    }

    private var chartMax: Double {
        let dataMax = dataPoints.max() ?? 100
        let refMax = referenceMax ?? dataMax
        return max(dataMax, refMax) * 1.1
    }

    private func xPosition(for index: Int, count: Int, in width: CGFloat) -> CGFloat {
        guard count > 1 else { return width / 2 }
        let padding: CGFloat = 16
        let usableWidth = width - padding * 2
        return padding + usableWidth * CGFloat(index) / CGFloat(count - 1)
    }

    private func yPosition(for value: Double, in height: CGFloat) -> CGFloat {
        let range = chartMax - chartMin
        guard range > 0 else { return height / 2 }
        let padding: CGFloat = 8
        let usableHeight = height - padding * 2
        return padding + usableHeight * (1 - (value - chartMin) / range)
    }
}

#Preview {
    VStack(spacing: AlcheSpacing.lg) {
        VStack(alignment: .leading) {
            Text("Vitamin D")
                .font(.alcheSubheading)
            MarkerTrendChart(
                dataPoints: [18, 20, 22, 24, 26, 28],
                referenceMin: 30,
                referenceMax: 80,
                color: .alcheAmber
            )
        }

        VStack(alignment: .leading) {
            Text("hsCRP")
                .font(.alcheSubheading)
            MarkerTrendChart(
                dataPoints: [1.2, 0.9, 0.8, 0.7, 0.8],
                referenceMin: 0,
                referenceMax: 3.0,
                color: .alcheSage
            )
        }
    }
    .padding()
    .background(Color.alcheBackground)
}
