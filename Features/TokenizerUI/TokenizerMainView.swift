import SwiftUI

/// 负责展示分词器 UI 的主界面。
/// - Note: 当前仅作为占位，后续将绑定 `TokenizerViewModel` 显示实际数据。
struct TokenizerMainView: View {
    /// 占位视图模型实例，后续将通过依赖注入替换。
    @StateObject private var viewModel = TokenizerViewModel()

    var body: some View {
        Text(viewModel.tokens.isEmpty ? "Tokenizer UI 占位" : "分词结果占位")
            .padding()
    }
}

#Preview {
    TokenizerMainView()
}
