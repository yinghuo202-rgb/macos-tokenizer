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

        let punctuation = CharacterSet.punctuationCharacters
        XCTAssertFalse(tokens.contains { token in
            token.rangeOfCharacter(from: punctuation) != nil
        }, "Tokens should not include punctuation marks")

        XCTAssertTrue((3...4).contains(tokens.count), "Mixed input should produce between three and four tokens depending on locale segmentation")
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
