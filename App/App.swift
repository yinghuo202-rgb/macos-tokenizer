import SwiftUI

/// `MacosTokenizerApp` 是应用入口，负责启动并管理主窗口场景。
@main
struct MacosTokenizerApp: App {
    @StateObject private var viewModel = TokenizerViewModel()
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            AppShellView(tokenizerViewModel: viewModel)
                .environmentObject(themeManager)
        }
        .commands {
            CommandMenu("文件操作") {
                Button("打开文件") {
                    viewModel.handleOpenFileCommand()
                }
                .keyboardShortcut("o", modifiers: .command)

                Button("导出 CSV") {
                    viewModel.handleExportCSV()
                }
                .keyboardShortcut("e", modifiers: [.command, .shift])
                .disabled(viewModel.isBusy)

                Button("导出 JSON") {
                    viewModel.handleExportJSON()
                }
                .keyboardShortcut("j", modifiers: [.command, .shift])
                .disabled(viewModel.isBusy)

                Button("清空") {
                    viewModel.handleClear()
                }
                .keyboardShortcut("k", modifiers: .command)
            }
        }
    }
}
