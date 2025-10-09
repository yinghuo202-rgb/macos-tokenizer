import XCTest
@testable import macos_tokenizer

final class TokenizationTests: XCTestCase {
    private var engine: TokenizerEngine!

    override func setUp() {
        super.setUp()
        engine = DefaultTokenizerEngine()
    }

    override func tearDown() {
        engine = nil
        super.tearDown()
    }

    func testEmptyInputProducesNoTokens() {
        let tokens = engine.tokenize("")
        XCTAssertTrue(tokens.isEmpty, "Empty input should yield no tokens")
        XCTAssertEqual(Set(tokens).count, 0)
    }

    func testMixedLanguageTokenization() {
        let input = "你好，world 123！"
        let tokens = engine.tokenize(input)

        XCTAssertTrue(tokens.contains("你好"), "Chinese phrase should be preserved as a token")
        XCTAssertTrue(tokens.contains("world"), "English words should be tokenized correctly")
        XCTAssertTrue(tokens.contains("123"), "Numbers should appear in the token list")

        XCTAssertTrue(tokens.contains("，"), "Chinese punctuation should be surfaced as a standalone token")
        XCTAssertTrue(tokens.contains("！"), "Full-width punctuation should also be exposed when present")

        XCTAssertEqual(tokens.count, 5, "Mixed input should produce five tokens, including punctuation marks")
        XCTAssertEqual(tokens.count, Set(tokens).count, "Unique token count should match the number of produced tokens")
    }

    func testLongEnglishParagraphTokenCounts() {
        let phrase = "SwiftUI tokenization reliability benchmark"
        let repetitions = 12
        let input = Array(repeating: phrase, count: repetitions).joined(separator: " ")

        let expectedTokensPerPhrase = phrase.split(separator: " ").count
        let tokens = engine.tokenize(input)

        XCTAssertEqual(tokens.count, expectedTokensPerPhrase * repetitions)
        XCTAssertEqual(Set(tokens).count, expectedTokensPerPhrase)
    }
}
