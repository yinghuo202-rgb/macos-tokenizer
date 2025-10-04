import SwiftUI

/// 设计系统基础 Token，集中管理颜色、间距与圆角。
public enum DesignSystem {
    @MainActor
    public enum Colors {
        public struct Palette {
            public let background: Color
            public let card: Color
            public let elevatedCard: Color
            public let border: Color
            public let separator: Color
            public let textPrimary: Color
            public let textSecondary: Color
            public let textMuted: Color
            public let accent: Color
            public let success: Color
            public let warning: Color
            public let error: Color
            public let info: Color
            public let badges: BadgePalette

            public init(
                background: Color,
                card: Color,
                elevatedCard: Color,
                border: Color,
                separator: Color,
                textPrimary: Color,
                textSecondary: Color,
                textMuted: Color,
                accent: Color,
                success: Color,
                warning: Color,
                error: Color,
                info: Color,
                badges: BadgePalette
            ) {
                self.background = background
                self.card = card
                self.elevatedCard = elevatedCard
                self.border = border
                self.separator = separator
                self.textPrimary = textPrimary
                self.textSecondary = textSecondary
                self.textMuted = textMuted
                self.accent = accent
                self.success = success
                self.warning = warning
                self.error = error
                self.info = info
                self.badges = badges
            }
        }

        public struct BadgePalette {
            public let success: BadgeColorSet
            public let warning: BadgeColorSet
            public let error: BadgeColorSet
            public let info: BadgeColorSet

            public init(
                success: BadgeColorSet,
                warning: BadgeColorSet,
                error: BadgeColorSet,
                info: BadgeColorSet
            ) {
                self.success = success
                self.warning = warning
                self.error = error
                self.info = info
            }
        }

        public struct BadgeColorSet {
            public let foreground: Color
            public let background: Color

            public init(foreground: Color, background: Color) {
                self.foreground = foreground
                self.background = background
            }
        }

        public static let light = Palette(
            background: Color(hex: 0xF8FAFC),
            card: Color(hex: 0xFFFFFF),
            elevatedCard: Color(hex: 0xF1F5F9),
            border: Color(hex: 0xD0D7E3),
            separator: Color(hex: 0xE2E8F0),
            textPrimary: Color(hex: 0x0F172A),
            textSecondary: Color(hex: 0x475569),
            textMuted: Color(hex: 0x64748B),
            accent: Color(hex: 0x4F46E5),
            success: Color(hex: 0x059669),
            warning: Color(hex: 0xF59E0B),
            error: Color(hex: 0xDC2626),
            info: Color(hex: 0x2563EB),
            badges: BadgePalette(
                success: BadgeColorSet(
                    foreground: Color(hex: 0x047857),
                    background: Color(hex: 0x34D399, alpha: 0.18)
                ),
                warning: BadgeColorSet(
                    foreground: Color(hex: 0xB45309),
                    background: Color(hex: 0xFBBF24, alpha: 0.18)
                ),
                error: BadgeColorSet(
                    foreground: Color(hex: 0xB91C1C),
                    background: Color(hex: 0xF87171, alpha: 0.18)
                ),
                info: BadgeColorSet(
                    foreground: Color(hex: 0x1D4ED8),
                    background: Color(hex: 0x60A5FA, alpha: 0.18)
                )
            )
        )

        public static let dark = Palette(
            background: Color(hex: 0x0B1120),
            card: Color(hex: 0x111827),
            elevatedCard: Color(hex: 0x1F2937),
            border: Color(hex: 0x1F2A3A),
            separator: Color(hex: 0x243044),
            textPrimary: Color(hex: 0xE2E8F0),
            textSecondary: Color(hex: 0x9CA3AF),
            textMuted: Color(hex: 0x6B7280),
            accent: Color(hex: 0x6366F1),
            success: Color(hex: 0x34D399),
            warning: Color(hex: 0xFBBF24),
            error: Color(hex: 0xF87171),
            info: Color(hex: 0x60A5FA),
            badges: BadgePalette(
                success: BadgeColorSet(
                    foreground: Color(hex: 0x34D399),
                    background: Color(hex: 0x064E3B, alpha: 0.42)
                ),
                warning: BadgeColorSet(
                    foreground: Color(hex: 0xFBBF24),
                    background: Color(hex: 0x78350F, alpha: 0.45)
                ),
                error: BadgeColorSet(
                    foreground: Color(hex: 0xF87171),
                    background: Color(hex: 0x7F1D1D, alpha: 0.48)
                ),
                info: BadgeColorSet(
                    foreground: Color(hex: 0x60A5FA),
                    background: Color(hex: 0x1E3A8A, alpha: 0.45)
                )
            )
        )

        private static var activePalette: Palette = light

        public static var background: Color { activePalette.background }
        public static var card: Color { activePalette.card }
        public static var elevatedCard: Color { activePalette.elevatedCard }
        public static var border: Color { activePalette.border }
        public static var separator: Color { activePalette.separator }
        public static var textPrimary: Color { activePalette.textPrimary }
        public static var textSecondary: Color { activePalette.textSecondary }
        public static var textMuted: Color { activePalette.textMuted }
        public static var accent: Color { activePalette.accent }
        public static var success: Color { activePalette.success }
        public static var warning: Color { activePalette.warning }
        public static var error: Color { activePalette.error }
        public static var info: Color { activePalette.info }

        public enum Badge {
            public static var success: BadgeColorSet { Colors.activePalette.badges.success }
            public static var warning: BadgeColorSet { Colors.activePalette.badges.warning }
            public static var error: BadgeColorSet { Colors.activePalette.badges.error }
            public static var info: BadgeColorSet { Colors.activePalette.badges.info }
        }

        /// 切换当前生效的调色板，供主题管理器调用。
        public static func use(_ palette: Palette) {
            activePalette = palette
        }
    }

    public enum CornerRadius {
        public static let card: CGFloat = 18
        public static let badge: CGFloat = 10
        public static let button: CGFloat = 12
    }

    public enum Spacing {
        public static let xs: CGFloat = 8
        public static let sm: CGFloat = 12
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
    }

    @MainActor
    public enum Shadows {
        public struct ShadowSet {
            public let card: ShadowStyle
            public let cardHover: ShadowStyle

            public init(card: ShadowStyle, cardHover: ShadowStyle) {
                self.card = card
                self.cardHover = cardHover
            }
        }

        public static let light = ShadowSet(
            card: ShadowStyle(
                color: Color(hex: 0x0F172A, alpha: 0.08),
                radius: 12,
                x: 0,
                y: 2
            ),
            cardHover: ShadowStyle(
                color: Color(hex: 0x0F172A, alpha: 0.14),
                radius: 18,
                x: 0,
                y: 8
            )
        )

        public static let dark = ShadowSet(
            card: ShadowStyle(
                color: Color(hex: 0x000000, alpha: 0.45),
                radius: 14,
                x: 0,
                y: 6
            ),
            cardHover: ShadowStyle(
                color: Color(hex: 0x000000, alpha: 0.55),
                radius: 22,
                x: 0,
                y: 12
            )
        )

        private static var activeSet: ShadowSet = light

        public static var card: ShadowStyle { activeSet.card }
        public static var cardHover: ShadowStyle { activeSet.cardHover }

        /// 根据主题更新阴影强度与模糊值。
        public static func use(_ set: ShadowSet) {
            activeSet = set
        }
    }

    public enum Typography {
        public static let title = Font.system(size: 18, weight: .semibold)
        public static let subtitle = Font.system(size: 14, weight: .regular)
        public static let body = Font.system(size: 15, weight: .regular)
        public static let caption = Font.system(size: 13, weight: .regular)
        public static let value = Font.system(size: 32, weight: .semibold, design: .monospaced)
        public static let label = Font.system(size: 13, weight: .semibold)
    }

    public struct ShadowStyle {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat

        public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }
}

private extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
