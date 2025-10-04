import SwiftUI

/// `MacosTokenizerApp` 是应用入口，负责启动并管理主窗口场景。
@main
struct MacosTokenizerApp: App {
    /// 菜单动作：记录打开文件指令触发。
    private func handleOpenFileCommand() {
        print("[菜单] 打开文件占位指令")
    }

    /// 菜单动作：记录导出结果指令触发。
    private func handleExportCommand() {
        print("[菜单] 导出结果占位指令")
    }

    /// 菜单动作：记录清空指令触发。
    private func handleClearCommand() {
        print("[菜单] 清空内容占位指令")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandMenu("文件操作") {
                Button("打开文件") {
                    handleOpenFileCommand()
                }
                .keyboardShortcut("o", modifiers: .command)

                Button("导出结果") {
                    handleExportCommand()
                }
                .keyboardShortcut("e", modifiers: [.command, .shift])

                Button("清空") {
                    handleClearCommand()
                }
                .keyboardShortcut("k", modifiers: .command)
            }
        }
    }
}

/// `ContentView` 展示初始界面，仅显示欢迎文案。
struct ContentView: View {
    var body: some View {
        Text("欢迎使用 macos-tokenizer")
            .padding()
    }
}
