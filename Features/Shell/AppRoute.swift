import SwiftUI

/// `AppRoute` 枚举描述应用的导航目的地，用于侧边栏与内容区的同步切换。
enum AppRoute: String, CaseIterable, Identifiable {
    case dashboard
    case analyze
    case batch
    case dictionaries
    case logs
    case settings

    var id: String { rawValue }

    /// 返回在侧边栏中展示的标题。
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .analyze: return "Analyze"
        case .batch: return "Batch"
        case .dictionaries: return "Dictionaries"
        case .logs: return "Logs"
        case .settings: return "Settings"
        }
    }

    /// 对应的 SF Symbols 图标名称。
    var systemImageName: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .analyze: return "text.magnifyingglass"
        case .batch: return "tray.full"
        case .dictionaries: return "book"
        case .logs: return "doc.text"
        case .settings: return "gearshape"
        }
    }
}
