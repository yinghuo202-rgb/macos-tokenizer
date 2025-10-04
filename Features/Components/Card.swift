import SwiftUI

/// 通用卡片容器，支持标题、副标题与右上角动作插槽。
public struct Card<TrailingActions: View, Content: View>: View {
    private let title: String?
    private let subtitle: String?
    private let includesTrailingActions: Bool
    private let trailingActions: () -> TrailingActions
    private let content: () -> Content

    @State private var isHovering = false

    fileprivate init(
        title: String?,
        subtitle: String?,
        includesTrailingActions: Bool,
        @ViewBuilder trailingActions: @escaping () -> TrailingActions,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.includesTrailingActions = includesTrailingActions
        self.trailingActions = trailingActions
        self.content = content
    }

    /// 初始化卡片并提供右上角自定义动作插槽。
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder trailingActions: @escaping () -> TrailingActions,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            includesTrailingActions: true,
            trailingActions: trailingActions,
            content: content
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            if shouldShowHeader {
                header
            }

            content()
        }
        .padding(DesignSystem.Spacing.lg)
        .background(DesignSystem.Colors.card)
        .cornerRadius(DesignSystem.CornerRadius.card)
        .shadow(
            color: currentShadow.color,
            radius: currentShadow.radius,
            x: currentShadow.x,
            y: currentShadow.y
        )
        .animation(.easeInOut(duration: 0.2), value: isHovering)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
    }

    private var shouldShowHeader: Bool {
        (title?.isEmpty == false) || (subtitle?.isEmpty == false) || includesTrailingActions
    }

    private var currentShadow: DesignSystem.ShadowStyle {
        isHovering ? DesignSystem.Shadows.cardHover : DesignSystem.Shadows.card
    }

    @ViewBuilder
    private var header: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(DesignSystem.Typography.title)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                }

                if let subtitle {
                    Text(subtitle)
                        .font(DesignSystem.Typography.subtitle)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }

            Spacer(minLength: DesignSystem.Spacing.sm)

            if includesTrailingActions {
                trailingActions()
            }
        }
    }
}

public extension Card where TrailingActions == EmptyView {
    /// 便捷初始化，适用于无右上角动作的卡片。
    /// 初始化卡片，省略动作插槽时使用该便捷方法。
    init(
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            includesTrailingActions: false,
            trailingActions: { EmptyView() },
            content: content
        )
    }
}

/// 键值列表卡片，用于展示文件名、大小等信息。
public struct KeyValueCard: View {
    private let title: String?
    private let subtitle: String?
    private let items: [(key: String, value: String)]
    private let maxVisible: Int?
    private let rowHeight: CGFloat = 36

    /// 传入键值数组及可选显示上限，生成信息列表卡片。
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        items: [(key: String, value: String)],
        maxVisible: Int? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.maxVisible = maxVisible
    }

    public var body: some View {
        Card(title: title, subtitle: subtitle) {
            contentView
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if shouldScroll {
            ScrollView {
                keyValueList
                    .padding(.vertical, 2)
            }
            .frame(maxHeight: maxContentHeight)
        } else {
            keyValueList
        }
    }

    private var keyValueList: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                if index > 0 {
                    Divider()
                        .background(DesignSystem.Colors.divider)
                }
                KeyValueRow(item: item)
            }
        }
    }

    private var shouldScroll: Bool {
        guard let maxVisible else { return false }
        return items.count > maxVisible
    }

    private var maxContentHeight: CGFloat {
        guard let maxVisible else { return .infinity }
        return CGFloat(maxVisible) * rowHeight
    }
}

private struct KeyValueRow: View {
    let item: (key: String, value: String)

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: DesignSystem.Spacing.sm) {
            Text(item.key)
                .font(DesignSystem.Typography.label)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
            Spacer(minLength: DesignSystem.Spacing.sm)
            Text(item.value)
                .font(DesignSystem.Typography.body)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}
