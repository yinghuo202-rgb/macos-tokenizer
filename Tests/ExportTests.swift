import XCTest
@testable import macos_tokenizer

final class ExportTests: XCTestCase {
    private var exportService: TokenExportService!
    private var temporaryDirectory: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        exportService = TokenExportService()
        temporaryDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: temporaryDirectory)
        exportService = nil
        temporaryDirectory = nil
        try super.tearDownWithError()
    }

    func testCSVExportEscapesSpecialCharacters() throws {
        let tokens = [
            "hello",
            "value,with,comma",
            "value,with,comma",
            "value\"quote"
        ]
        let destination = temporaryDirectory.appendingPathComponent("tokens").appendingPathExtension("csv")

        try exportService.export(tokens: tokens, to: destination, format: .csv)

        let csv = try String(contentsOf: destination, encoding: .utf8)
        let rows = csv.split(separator: "\n").map(String.init)

        XCTAssertEqual(rows.first, "token,freq")
        XCTAssertEqual(rows.count, 4)
        XCTAssertTrue(rows.contains("hello,1"))
        XCTAssertTrue(rows.contains("\"value,with,comma\",2"))
        XCTAssertTrue(rows.contains("\"value\"\"quote\",1"))
    }

    func testJSONExportContainsTokensAndFrequencies() throws {
        let tokens = ["你", "好", "world", "123", "你"]
        let destination = temporaryDirectory.appendingPathComponent("tokens").appendingPathExtension("json")

        try exportService.export(tokens: tokens, to: destination, format: .json)

        let data = try Data(contentsOf: destination)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

        guard let dictionary = jsonObject as? [String: Any] else {
            XCTFail("Root JSON object should be a dictionary")
            return
        }

        guard let exportedTokens = dictionary["tokens"] as? [String] else {
            XCTFail("Tokens array missing from JSON output")
            return
        }

        XCTAssertEqual(exportedTokens, tokens)

        guard let frequencyObject = dictionary["frequencies"] as? [String: Any] else {
            XCTFail("Frequencies dictionary missing from JSON output")
            return
        }

        let frequencies = frequencyObject.reduce(into: [String: Int]()) { partialResult, element in
            if let number = element.value as? NSNumber {
                partialResult[element.key] = number.intValue
            }
        }

        XCTAssertEqual(frequencies.count, Set(tokens).count)
        XCTAssertEqual(frequencies["你"], 2)
        XCTAssertEqual(frequencies["好"], 1)
        XCTAssertEqual(frequencies["world"], 1)
        XCTAssertEqual(frequencies["123"], 1)
    }
}
