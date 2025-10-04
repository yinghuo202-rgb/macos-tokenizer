import SwiftUI

/// `MacosTokenizerApp` 是应用入口，负责启动并管理主窗口场景。
@main
struct MacosTokenizerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
