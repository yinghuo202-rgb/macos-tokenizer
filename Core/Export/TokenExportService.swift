import Foundation

/// 导出分词结果可能遇到的错误，用于给用户展示友好提示。
public enum TokenExportError: LocalizedError {
    case writeFailed(underlying: Error)

    public var errorDescription: String? {
        switch self {
        case .writeFailed(let underlying):
            return "导出失败：\(underlying.localizedDescription)"
        }
    }
}

/// 支持的导出格式枚举。
public enum TokenExportFormat {
    case csv
    case json
}

/// 提供 CSV 与 JSON 导出的服务类。
public final class TokenExportService {
    public init() {}

    /// 将 tokens 与词频写出到指定地址。
    /// - Parameters:
    ///   - tokens: 已分词的字符串数组。
    ///   - url: 用户选择的导出文件地址。
    ///   - format: 导出格式（CSV/JSON）。
    public func export(tokens: [String], to url: URL, format: TokenExportFormat) throws {
        let frequencies = buildFrequencyMap(from: tokens)
        let data: Data

        switch format {
        case .csv:
            data = buildCSVData(tokens: tokens, frequencies: frequencies)
        case .json:
            data = try buildJSONData(tokens: tokens, frequencies: frequencies)
        }

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            throw TokenExportError.writeFailed(underlying: error)
        }
    }

    private func buildFrequencyMap(from tokens: [String]) -> [String: Int] {
        var map: [String: Int] = [:]
        for token in tokens {
            map[token, default: 0] += 1
        }
        return map
    }

    private func buildCSVData(tokens: [String], frequencies: [String: Int]) -> Data {
        var rows: [String] = ["token,freq"]
        var visited: Set<String> = []
        for token in tokens where !visited.contains(token) {
            visited.insert(token)
            let escapedToken = csvEscaped(token)
            let freq = frequencies[token, default: 0]
            rows.append("\(escapedToken),\(freq)")
        }
        let csvString = rows.joined(separator: "\n")
        return Data(csvString.utf8)
    }

    private func csvEscaped(_ value: String) -> String {
        var escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
        if escaped.contains(",") || escaped.contains("\n") || escaped.contains("\r") || escaped.contains("\"") {
            escaped = "\"\(escaped)\""
        }
        return escaped
    }

    private func buildJSONData(tokens: [String], frequencies: [String: Int]) throws -> Data {
        let jsonObject: [String: Any] = [
            "tokens": tokens,
            "frequencies": frequencies
        ]
        do {
            return try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        } catch {
            throw TokenExportError.writeFailed(underlying: error)
        }
    }
}
