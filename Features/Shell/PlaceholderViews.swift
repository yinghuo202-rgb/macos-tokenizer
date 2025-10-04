import SwiftUI

/// `AnalyzeWorkspaceView` 嵌入已有的分词主界面，保证单文分析功能保持可用。
struct AnalyzeWorkspaceView: View {
    @ObservedObject var viewModel: TokenizerViewModel

    var body: some View {
        TokenizerMainView(viewModel: viewModel)
    }
}

/// `DashboardPlaceholderView` 展示仪表盘占位界面。
struct DashboardPlaceholderView: View {
    var body: some View {
        ComingSoonContainer(title: "Dashboard", message: "Overview widgets are under construction.")
    }
}

/// `BatchPlaceholderView` 展示批量处理模块的占位界面。
struct BatchPlaceholderView: View {
    var body: some View {
        ComingSoonContainer(title: "Batch", message: "Batch processing tools will arrive soon.")
    }
}

/// `DictionariesPlaceholderView` 展示词典管理的占位界面。
struct DictionariesPlaceholderView: View {
    var body: some View {
        ComingSoonContainer(title: "Dictionaries", message: "Manage custom dictionaries in a future update.")
    }
}

/// `LogsPlaceholderView` 展示日志列表的占位界面。
struct LogsPlaceholderView: View {
    var body: some View {
        ComingSoonContainer(title: "Logs", message: "Usage and error logs are being prepared.")
    }
}

/// `SettingsPlaceholderView` 展示设置面板的占位界面。
struct SettingsPlaceholderView: View {
    var body: some View {
        ComingSoonContainer(title: "Settings", message: "Configuration options will be added later.")
    }
}

private struct ComingSoonContainer: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Coming soon")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
