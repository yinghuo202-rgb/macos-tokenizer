import Foundation
import NaturalLanguage

/// 定义分词引擎的基本能力协议，供视图模型调用。
public protocol TokenizerEngine {
    /// 根据传入的原始文本执行分词。
    /// - Parameter text: 待分词的原始文本内容。
    /// - Returns: 分词后的字符串数组，保持原始顺序。
    func tokenize(_ text: String) -> [String]
}

/// 默认分词引擎实现，基于 `NaturalLanguage.NLTokenizer`。
public struct DefaultTokenizerEngine: TokenizerEngine {
    private let unit: NLTokenUnit

    /// 创建默认的分词引擎实例。
    /// - Parameter unit: 分词粒度，默认按单词分割。
    public init(unit: NLTokenUnit = .word) {
        self.unit = unit
    }

    public func tokenize(_ text: String) -> [String] {
        guard !text.isEmpty else {
            return []
        }

        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = text

        let fullRange = text.startIndex..<text.endIndex
        let tokens = tokenizer.tokens(for: fullRange).map { range in
            text[range]
        }
        .map { substring -> String in
            substring.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        .filter { !$0.isEmpty }

        return tokens
    }
}
