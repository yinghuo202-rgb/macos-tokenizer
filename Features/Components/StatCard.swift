import SwiftUI

/// SF Symbol 名称别名，便于区分参数语义。
public typealias SFSymbol = String

/// 关键指标卡片，突出数字指标并支持可选图标与脚注。
public struct StatCard: View {
    private let title: String
    private let value: String
    private let icon: SFSymbol?
    private let footnote: String?

    /// 初始化关键指标卡片，传入标题、主数值及可选图标与脚注。
    public init(
        title: String,
        value: String,
        icon: SFSymbol? = nil,
        footnote: String? = nil
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.footnote = footnote
    }

    public var body: some View {
        Group {
            if let icon {
                Card(title: title, subtitle: nil, trailingActions: {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(DesignSystem.Colors.accent)
                        .accessibilityHidden(true)
                }) {
                    content
                }
            } else {
                Card(title: title, subtitle: nil) {
                    content
                }
            }
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(value)
                .font(DesignSystem.Typography.value)
                .foregroundStyle(DesignSystem.Colors.textPrimary)

            if let footnote {
                Text(footnote)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }
        }
    }
}
