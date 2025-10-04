import Combine
import Foundation

/// 负责协调 UI 与分词引擎的视图模型。
/// - Note: 当前仅包含占位属性，后续将引入实际的业务逻辑与状态。
final class TokenizerViewModel: ObservableObject {
    /// 占位输入文本，后续将与界面输入框绑定。
    @Published var inputText: String = ""

    /// 占位输出结果列表，后续将展示在界面上。
    @Published var tokens: [String] = []
}
