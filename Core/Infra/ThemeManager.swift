import SwiftUI

/// 应用主题策略，负责在浅色、暗色与跟随系统之间切换。
@MainActor
public final class ThemeManager: ObservableObject {
    private enum Constants {
        static let storageKey = "ThemeManager.mode"
    }

    @Published public private(set) var mode: ThemeMode
    private let userDefaults: UserDefaults
    private var systemColorScheme: ColorScheme = .light

    /// 初始化主题管理器，读取用户偏好并应用调色板。
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        if let rawValue = userDefaults.string(forKey: Constants.storageKey),
           let savedMode = ThemeMode(rawValue: rawValue) {
            self.mode = savedMode
        } else {
            self.mode = .system
        }
        applyCurrentPalette()
    }

    /// 当前应当应用的 SwiftUI 色板，供顶层视图绑定 preferredColorScheme。
    public var currentColorScheme: ColorScheme? {
        switch mode {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    /// 外部更新系统色彩方案（system 模式下跟随变化）。
    public func updateSystemColorScheme(_ scheme: ColorScheme) {
        systemColorScheme = scheme
        if mode == .system {
            applyCurrentPalette()
        }
    }

    /// 切换主题模式，立即持久化并刷新调色板。
    public func apply(_ mode: ThemeMode) {
        userDefaults.set(mode.rawValue, forKey: Constants.storageKey)
        self.mode = mode
        applyCurrentPalette()
    }

    /// 当前主题对应的颜色调色板，便于外界获取实时 Token。
    public var activePalette: DesignSystem.Colors.Palette {
        effectiveScheme == .dark ? DesignSystem.Colors.dark : DesignSystem.Colors.light
    }

    /// 当前主题对应的阴影集合，使卡片层级在暗色下依旧清晰。
    public var activeShadows: DesignSystem.Shadows.ShadowSet {
        effectiveScheme == .dark ? DesignSystem.Shadows.dark : DesignSystem.Shadows.light
    }

    private var effectiveScheme: ColorScheme {
        switch mode {
        case .system:
            return systemColorScheme
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    private func applyCurrentPalette() {
        DesignSystem.Colors.use(activePalette)
        DesignSystem.Shadows.use(activeShadows)
    }
}

/// 主题模式枚举，提供浅色、暗色与跟随系统三种策略。
public enum ThemeMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    public var id: String { rawValue }

    /// 菜单展示名称，保持中英文友好。
    public var displayName: String {
        switch self {
        case .system:
            return "跟随系统"
        case .light:
            return "浅色模式"
        case .dark:
            return "暗色模式"
        }
    }

    /// 对应的 SF Symbol，便于在菜单中展示。
    public var symbolName: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max"
        case .dark:
            return "moon.stars"
        }
    }
}
