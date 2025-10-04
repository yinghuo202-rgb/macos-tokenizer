import SwiftUI
import UniformTypeIdentifiers

/// 提供统一样式的拖拽导入区域，支持点击、悬停与加载状态。
public struct DropZone: View {
    public enum Size {
        case large
        case compact
    }

    private let icon: String
    private let title: String
    private let message: String
    private let size: Size
    private let isLoading: Bool
    private let loadingMessage: String?
    private let onOpen: () -> Void
    private let onDrop: ([NSItemProvider]) -> Bool

    @State private var isPointerHovering: Bool = false
    @State private var isDropHovering: Bool = false

    /// 创建拖拽导入区域。
    /// - Parameters:
    ///   - icon: 展示的 SF Symbols 名称。
    ///   - title: 主标题文案。
    ///   - message: 副标题提示文案。
    ///   - size: 显示尺寸（大号或紧凑）。
    ///   - isLoading: 是否处于加载状态。
    ///   - loadingMessage: 加载状态下展示的提示文案。
    ///   - onOpen: 点击或键盘触发时调用的打开动作。
    ///   - onDrop: 接收到拖拽文件时的回调。
    public init(
        icon: String,
        title: String,
        message: String,
        size: Size,
        isLoading: Bool,
        loadingMessage: String? = nil,
        onOpen: @escaping () -> Void,
        onDrop: @escaping ([NSItemProvider]) -> Bool
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.size = size
        self.isLoading = isLoading
        self.loadingMessage = loadingMessage
        self.onOpen = onOpen
        self.onDrop = onDrop
    }

    public var body: some View {
        let isHovering = (isPointerHovering || isDropHovering) && !isLoading
        let backgroundColor = isHovering
            ? DesignSystem.Colors.accent.opacity(0.08)
            : DesignSystem.Colors.card
        let borderColor = isLoading
            ? DesignSystem.Colors.textSecondary.opacity(0.4)
            : (isHovering ? DesignSystem.Colors.accent : DesignSystem.Colors.divider)

        Button(action: onOpen) {
            VStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(iconFont)
                    .foregroundStyle(DesignSystem.Colors.accent)
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                Text(message)
                    .font(messageFont)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: minHeight)
            .padding(padding)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: DesignSystem.Spacing.xs / 4,
                            dash: [DesignSystem.Spacing.sm]
                        )
                    )
                    .foregroundStyle(borderColor)
            )
            .cornerRadius(DesignSystem.CornerRadius.card)
            .shadow(
                color: DesignSystem.Shadows.card.color,
                radius: DesignSystem.Shadows.card.radius,
                x: DesignSystem.Shadows.card.x,
                y: DesignSystem.Shadows.card.y
            )
            .overlay(loadingOverlay)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .contentShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous))
        .onHover { hovering in
            isPointerHovering = hovering
        }
        .onDrop(of: [UTType.fileURL], isTargeted: $isDropHovering, perform: onDrop)
        .animation(.easeInOut(duration: 0.2), value: isHovering)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .focusable(true)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("导入文件"))
        .accessibilityHint(Text("拖拽 TXT 或 XLSX 文件，或按回车打开文件对话框。"))
    }

    private var padding: CGFloat {
        switch size {
        case .large:
            return DesignSystem.Spacing.lg
        case .compact:
            return DesignSystem.Spacing.md
        }
    }

    private var minHeight: CGFloat {
        switch size {
        case .large:
            return DesignSystem.Spacing.lg * 7
        case .compact:
            return DesignSystem.Spacing.lg * 3
        }
    }

    private var iconFont: Font {
        switch size {
        case .large:
            return DesignSystem.Typography.value
        case .compact:
            return DesignSystem.Typography.title
        }
    }

    private var titleFont: Font {
        switch size {
        case .large:
            return DesignSystem.Typography.title
        case .compact:
            return DesignSystem.Typography.body
        }
    }

    private var messageFont: Font {
        switch size {
        case .large:
            return DesignSystem.Typography.caption
        case .compact:
            return DesignSystem.Typography.caption
        }
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if isLoading {
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous)
                .fill(DesignSystem.Colors.textSecondary.opacity(0.12))
                .overlay(
                    ProgressView(loadingMessage ?? "处理中…")
                        .progressViewStyle(.circular)
                        .controlSize(.large)
                        .tint(DesignSystem.Colors.accent)
                )
        }
    }
}
