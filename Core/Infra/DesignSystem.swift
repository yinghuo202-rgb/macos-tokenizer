import SwiftUI

/// 设计系统基础 Token，集中管理颜色、间距与圆角。
public enum DesignSystem {
    public enum Colors {
        public enum Light {
            public static let background = Color(hex: 0xF6F7FB)
            public static let card = Color(hex: 0xFFFFFF)
            public static let textPrimary = Color(hex: 0x0F172A)
            public static let textSecondary = Color(hex: 0x475569)
            public static let accent = Color(hex: 0x4F46E5)
            public static let divider = Color(hex: 0xE2E8F0)
            public static let success = Color(hex: 0x10B981)
            public static let warning = Color(hex: 0xF59E0B)
            public static let error = Color(hex: 0xEF4444)
            public static let info = Color(hex: 0x3B82F6)
        }

        public enum Dark {
            public static let background = Color(hex: 0x0F172A)
            public static let card = Color(hex: 0x1E293B)
            public static let textPrimary = Color.white
            public static let textSecondary = Color(hex: 0xCBD5F5)
            public static let accent = Color(hex: 0x6366F1)
            public static let divider = Color(hex: 0x334155)
            public static let success = Color(hex: 0x10B981)
            public static let warning = Color(hex: 0xF59E0B)
            public static let error = Color(hex: 0xEF4444)
            public static let info = Color(hex: 0x3B82F6)
        }

        public struct BadgeColorSet {
            public let foreground: Color
            public let background: Color

            public init(foreground: Color, background: Color) {
                self.foreground = foreground
                self.background = background
            }
        }

        public enum Badge {
            public static let success = BadgeColorSet(
                foreground: Light.success,
                background: Color(hex: 0x10B981, alpha: 0.14)
            )
            public static let warning = BadgeColorSet(
                foreground: Light.warning,
                background: Color(hex: 0xF59E0B, alpha: 0.18)
            )
            public static let error = BadgeColorSet(
                foreground: Light.error,
                background: Color(hex: 0xEF4444, alpha: 0.16)
            )
            public static let info = BadgeColorSet(
                foreground: Light.info,
                background: Color(hex: 0x3B82F6, alpha: 0.14)
            )
        }

        public static let background = Light.background
        public static let card = Light.card
        public static let textPrimary = Light.textPrimary
        public static let textSecondary = Light.textSecondary
        public static let accent = Light.accent
        public static let divider = Light.divider
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

    public enum Shadows {
        public static let card = ShadowStyle(
            color: Color(hex: 0x0F172A, alpha: 0.08),
            radius: 12,
            x: 0,
            y: 2
        )
        public static let cardHover = ShadowStyle(
            color: Color(hex: 0x0F172A, alpha: 0.12),
            radius: 18,
            x: 0,
            y: 8
        )
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
