import Foundation

/// 定义分词引擎的基本能力协议，供视图模型调用。
public protocol TokenizerEngine {
    /// 根据传入的原始文本执行分词。
    /// - Parameter text: 待分词的原始文本内容。
    /// - Returns: 分词后的字符串数组，保持原始顺序。
    func tokenize(_ text: String) -> [String]
}
