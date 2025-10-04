import SwiftUI

/// 徽标样式枚举，区分不同状态颜色。
public enum BadgeStyle {
    case success
    case warning
    case error
    case info
}

/// 状态徽标组件，支持 Success/Warning/Error/Info 四种样式。
public struct Badge: View {
    private let style: BadgeStyle
    private let text: String

    /// 初始化状态徽标，传入样式与展示文本。
    public init(style: BadgeStyle, text: String) {
        self.style = style
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(DesignSystem.Typography.caption)
            .padding(.vertical, 4)
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .foregroundStyle(colorSet.foreground)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.badge, style: .continuous)
                    .fill(colorSet.background)
            )
            .accessibilityLabel(accessibilityLabel)
    }

    private var colorSet: DesignSystem.Colors.BadgeColorSet {
        switch style {
        case .success:
            return DesignSystem.Colors.Badge.success
        case .warning:
            return DesignSystem.Colors.Badge.warning
        case .error:
            return DesignSystem.Colors.Badge.error
        case .info:
            return DesignSystem.Colors.Badge.info
        }
    }

    private var accessibilityLabel: Text {
        Text("状态：\(text)")
    }
}
