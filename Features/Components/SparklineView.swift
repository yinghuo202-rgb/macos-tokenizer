import SwiftUI
import Charts

/// 小型趋势图组件，接收数值序列并绘制简洁火花线。外部传入数据源与数值 KeyPath。
public struct SparklineView<DataPoint: Identifiable>: View {
    private let data: [DataPoint]
    private let valueKeyPath: KeyPath<DataPoint, Double>
    private let lineWidth: CGFloat
    private let cornerRadius: CGFloat
    private let inset: CGFloat

    @State private var isHovering = false

    public init(
        data: [DataPoint],
        value: KeyPath<DataPoint, Double>,
        lineWidth: CGFloat = 1.5,
        cornerRadius: CGFloat = 8,
        inset: CGFloat = 8
    ) {
        self.data = data
        valueKeyPath = value
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.inset = inset
    }

    public var body: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, element in
                LineMark(
                    x: .value("序号", index),
                    y: .value("数值", element[keyPath: valueKeyPath])
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(
                    StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .foregroundStyle(lineColor)
            }
        }
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartPlotStyle { plotArea in
            plotArea
                .background(plotBackground)
                .cornerRadius(cornerRadius)
        }
        .padding(inset)
        .frame(minHeight: 48)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
    }

    private var lineColor: Color {
        isHovering ? DesignSystem.Colors.accent : DesignSystem.Colors.accent.opacity(0.92)
    }

    private var plotBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(DesignSystem.Colors.accent.opacity(isHovering ? 0.14 : 0.08))
    }
}
