import SwiftUI

/// `DashboardView` 构建首页仪表盘界面，展示占位统计与快捷入口。 
struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel

    private let cardMinWidth: CGFloat = 320
    private let columnSpacing = DesignSystem.Spacing.lg
    private let rankColumnWidth: CGFloat = 56
    private let fileSizeColumnWidth: CGFloat = 80
    private let fileDateColumnWidth: CGFloat = 112

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                ForEach(viewModel.metrics) { metric in
                    StatCard(
                        title: metric.title,
                        value: metric.value,
                        icon: metric.icon,
                        footnote: metric.footnote
                    )
                }

                wordFrequencyCard
                recentFilesCard
                quickStartCard
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.lg)
        }
        .background(DesignSystem.Colors.background)
    }

    private var columns: [GridItem] {
        [
            GridItem(
                .adaptive(minimum: cardMinWidth),
                spacing: columnSpacing,
                alignment: .top
            )
        ]
    }

    private var wordFrequencyCard: some View {
        Card(title: "词频 Top 10", subtitle: "最近分析文本的高频词") {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                ForEach(Array(viewModel.wordFrequencies.enumerated()), id: \.element.id) { index, item in
                    if index > 0 {
                        Divider()
                            .background(DesignSystem.Colors.divider)
                    }

                    HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
                        Text(String(format: "#%02d", item.rank))
                            .font(DesignSystem.Typography.label)
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                            .frame(width: rankColumnWidth, alignment: .leading)

                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text(item.word)
                                .font(DesignSystem.Typography.body)
                                .foregroundStyle(DesignSystem.Colors.textPrimary)

                            if let badgeText = item.badgeText {
                                Badge(style: item.badgeStyle, text: badgeText)
                            }
                        }

                        Spacer(minLength: DesignSystem.Spacing.sm)

                        VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                            Text("\(item.count) 次")
                                .font(DesignSystem.Typography.body)
                                .foregroundStyle(DesignSystem.Colors.textPrimary)

                            Text(item.trend)
                                .font(DesignSystem.Typography.caption)
                                .foregroundStyle(trendColor(for: item))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var recentFilesCard: some View {
        Card(title: "最近文件", subtitle: "继续处理你最近的文档") {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Text("文件名")
                        .font(DesignSystem.Typography.label)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("大小")
                        .font(DesignSystem.Typography.label)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .frame(width: fileSizeColumnWidth, alignment: .trailing)
                    Text("更新时间")
                        .font(DesignSystem.Typography.label)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .frame(width: fileDateColumnWidth, alignment: .trailing)
                }

                ForEach(Array(viewModel.recentFiles.enumerated()), id: \.element.id) { index, file in
                    if index > 0 {
                        Divider()
                            .background(DesignSystem.Colors.divider)
                    }

                    HStack(alignment: .center, spacing: DesignSystem.Spacing.sm) {
                        Text(file.name)
                            .font(DesignSystem.Typography.body)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)

                        Text(file.size)
                            .font(DesignSystem.Typography.body)
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                            .frame(width: fileSizeColumnWidth, alignment: .trailing)

                        Text(file.updatedAt)
                            .font(DesignSystem.Typography.body)
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                            .frame(width: fileDateColumnWidth, alignment: .trailing)
                    }
                }
            }
        }
    }

    private var quickStartCard: some View {
        Card(title: "快速开始", subtitle: "选择一种方式导入文本") {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(viewModel.quickActions) { action in
                        Button {
                            viewModel.handleQuickAction(action)
                        } label: {
                            Label(action.title, systemImage: action.symbol)
                                .font(DesignSystem.Typography.body)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, DesignSystem.Spacing.sm)
                                .padding(.horizontal, DesignSystem.Spacing.md)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(DesignSystem.Colors.accent)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .background(DesignSystem.Colors.divider)

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text("或者直接拖拽文本/文件到窗口，立即开始分词。")
                        .font(DesignSystem.Typography.body)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                    Text("支持 TXT、Markdown、CSV 等常见格式。")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }
        }
    }

    private func trendColor(for item: DashboardViewModel.WordFrequencyItem) -> Color {
        item.trend.contains("↓") ? DesignSystem.Colors.textSecondary : DesignSystem.Colors.accent
    }
}

#Preview {
    DashboardView(viewModel: DashboardViewModel())
        .frame(width: 1200, height: 900)
}
