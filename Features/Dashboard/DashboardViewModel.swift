import Foundation
import SwiftUI

/// `DashboardViewModel` 提供首页仪表盘的占位数据，后续可替换为真实统计。 
final class DashboardViewModel: ObservableObject {
    struct Metric: Identifiable {
        let id = UUID()
        let title: String
        let value: String
        let icon: SFSymbol?
        let footnote: String?
    }

    struct WordFrequencyItem: Identifiable {
        let id = UUID()
        let rank: Int
        let word: String
        let count: Int
        let badgeText: String?
        let badgeStyle: BadgeStyle
        let trend: String
    }

    struct RecentFile: Identifiable {
        let id = UUID()
        let name: String
        let size: String
        let updatedAt: String
    }

    struct QuickAction: Identifiable {
        let id = UUID()
        let title: String
        let symbol: SFSymbol
    }

    @Published var metrics: [Metric]
    @Published var wordFrequencies: [WordFrequencyItem]
    @Published var recentFiles: [RecentFile]
    let quickActions: [QuickAction]

    init() {
        metrics = [
            Metric(title: "总词数", value: "128,450", icon: "character.cursor.ibeam", footnote: "较昨日 +12%"),
            Metric(title: "唯一词数", value: "8,920", icon: "textformat.abc", footnote: "覆盖 4 种语言"),
            Metric(title: "上次处理耗时", value: "182 ms", icon: "timer", footnote: "文本长度 24,500 字"),
        ]

        wordFrequencies = [
            WordFrequencyItem(rank: 1, word: "数据", count: 482, badgeText: "名词", badgeStyle: .info, trend: "↑ 18%"),
            WordFrequencyItem(rank: 2, word: "分析", count: 430, badgeText: "动词", badgeStyle: .success, trend: "↑ 9%"),
            WordFrequencyItem(rank: 3, word: "模型", count: 398, badgeText: "名词", badgeStyle: .info, trend: "↑ 4%"),
            WordFrequencyItem(rank: 4, word: "训练", count: 364, badgeText: "动词", badgeStyle: .success, trend: "↓ 3%"),
            WordFrequencyItem(rank: 5, word: "优化", count: 342, badgeText: "动词", badgeStyle: .success, trend: "↑ 6%"),
            WordFrequencyItem(rank: 6, word: "准确率", count: 321, badgeText: "指标", badgeStyle: .warning, trend: "↑ 12%"),
            WordFrequencyItem(rank: 7, word: "语料", count: 310, badgeText: "名词", badgeStyle: .info, trend: "↑ 5%"),
            WordFrequencyItem(rank: 8, word: "推理", count: 288, badgeText: "动词", badgeStyle: .success, trend: "↓ 1%"),
            WordFrequencyItem(rank: 9, word: "部署", count: 264, badgeText: "动词", badgeStyle: .success, trend: "↑ 2%"),
            WordFrequencyItem(rank: 10, word: "评估", count: 251, badgeText: "动词", badgeStyle: .success, trend: "↑ 7%"),
        ]

        recentFiles = [
            RecentFile(name: "产品需求-0423.md", size: "512 KB", updatedAt: "今天 10:24"),
            RecentFile(name: "季度汇报-v2.key", size: "1.8 MB", updatedAt: "昨天 19:12"),
            RecentFile(name: "客服对话-样例.csv", size: "742 KB", updatedAt: "3 天前"),
            RecentFile(name: "语料-机器学习.txt", size: "2.4 MB", updatedAt: "上周"),
            RecentFile(name: "会议记录-产品评审.docx", size: "968 KB", updatedAt: "上周"),
        ]

        quickActions = [
            QuickAction(title: "粘贴文本", symbol: "doc.on.clipboard"),
            QuickAction(title: "打开文件", symbol: "folder.badge.plus"),
        ]
    }

    /// 快速开始按钮的点击占位逻辑，后续接入真实操作。 
    func handleQuickAction(_ action: QuickAction) {
        print("[Dashboard] Quick action triggered: \(action.title)")
    }
}
