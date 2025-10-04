import Combine
import Foundation

/// 负责协调 UI 与分词引擎的视图模型。
final class TokenizerViewModel: ObservableObject {
    /// 用户输入文本，与界面左侧输入框双向绑定。
    @Published var inputText: String {
        didSet {
            processInput()
        }
    }

    /// 当前分词结果列表，保持输入顺序。
    @Published private(set) var tokens: [String] = []

    /// 分词后的总词数。
    @Published private(set) var totalTokenCount: Int = 0

    /// 分词后的唯一词数。
    @Published private(set) var uniqueTokenCount: Int = 0

    private let engine: TokenizerEngine

    /// 创建视图模型实例。
    /// - Parameters:
    ///   - initialText: 初始输入文本，默认空字符串。
    ///   - engine: 分词引擎，默认使用 `DefaultTokenizerEngine`。
    init(initialText: String = "", engine: TokenizerEngine = DefaultTokenizerEngine()) {
        self.engine = engine
        self.inputText = initialText
        processInput()
    }

    private func processInput() {
        let result = engine.tokenize(inputText)
        tokens = result
        totalTokenCount = result.count
        uniqueTokenCount = Set(result).count
    }
}
