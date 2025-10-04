import Foundation
import CoreXLSX

/// 文件导入过程中可能出现的错误类型，需反馈给 UI 进行提示。
public enum FileImportError: LocalizedError {
    case unsupportedType
    case readFailed(underlying: Error)
    case unsupportedEncoding
    case emptyWorkbook
    case unsupportedCell
    case parseFailed(underlying: Error)

    public var errorDescription: String? {
        switch self {
        case .unsupportedType:
            return "暂不支持该文件格式，请选择 TXT 或 XLSX 文件。"
        case .readFailed(let underlying):
            return "文件读取失败：\(underlying.localizedDescription)"
        case .unsupportedEncoding:
            return "无法识别文本编码，请确认文件为 UTF-8 等常见格式。"
        case .emptyWorkbook:
            return "Excel 文件没有可读取的工作表或单元格。"
        case .unsupportedCell:
            return "Excel 文件包含无法转换为文本的单元格。"
        case .parseFailed(let underlying):
            return "文件解析失败：\(underlying.localizedDescription)"
        }
    }
}

/// 统一的文件导入协议，便于扩展更多格式。
public protocol FileImporting {
    /// 判断当前导入器是否可以处理指定 URL。
    /// - Parameter url: 待检查的文件地址。
    func canHandle(_ url: URL) -> Bool

    /// 读取并解析文件内容。
    /// - Parameter url: 待导入的文件地址。
    /// - Returns: 解析出的纯文本内容。
    func importContents(from url: URL) throws -> String
}

/// 将多个具体导入器组合的总服务，负责自动选择并导入。
public final class FileImportService {
    private let importers: [FileImporting]

    /// 创建文件导入服务。
    /// - Parameter importers: 支持的导入器列表，默认包含 TXT 与 XLSX。
    public init(importers: [FileImporting] = [TextFileImporter(), ExcelFileImporter()]) {
        self.importers = importers
    }

    /// 根据文件类型自动选择导入器并返回文本内容。
    /// - Parameter url: 用户选择或拖入的文件地址。
    /// - Throws: `FileImportError` 及底层错误。
    /// - Returns: 导入得到的纯文本。
    public func importFile(at url: URL) throws -> String {
        guard let importer = importers.first(where: { $0.canHandle(url) }) else {
            throw FileImportError.unsupportedType
        }
        return try importer.importContents(from: url)
    }
}

/// 负责读取 UTF-8 文本文件的导入器。
public struct TextFileImporter: FileImporting {
    public init() {}

    public func canHandle(_ url: URL) -> Bool {
        url.pathExtension.lowercased() == "txt"
    }

    public func importContents(from url: URL) throws -> String {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw FileImportError.readFailed(underlying: error)
        }

        let encodings: [String.Encoding] = [
            .utf8,
            .utf16,
            .unicode,
            .utf16LittleEndian,
            .utf16BigEndian,
            .utf32LittleEndian,
            .utf32BigEndian
        ]

        for encoding in encodings {
            if let content = String(data: data, encoding: encoding) {
                return content
            }
        }

        throw FileImportError.unsupportedEncoding
    }
}

/// 负责解析 XLSX 文件并转换为纯文本的导入器。
public struct ExcelFileImporter: FileImporting {
    public init() {}

    public func canHandle(_ url: URL) -> Bool {
        url.pathExtension.lowercased() == "xlsx"
    }

    public func importContents(from url: URL) throws -> String {
        guard let file = XLSXFile(filepath: url.path) else {
            throw FileImportError.parseFailed(underlying: CocoaError(.fileReadCorruptFile))
        }

        do {
            let sharedStrings = try file.parseSharedStrings()
            let workbooks = try file.parseWorkbooks()
            guard !workbooks.isEmpty else {
                throw FileImportError.emptyWorkbook
            }

            var lines: [String] = []
            var hasReadableCell = false

            for workbook in workbooks {
                for (_, path) in try file.parseWorksheetPaths(workbook: workbook) {
                    let worksheet = try file.parseWorksheet(at: path)
                    let rows = worksheet.data?.rows ?? []
                    for row in rows {
                        var values: [String] = []
                        for cell in row.cells {
                            if let stringValue = cell.stringValue(sharedStrings) {
                                hasReadableCell = true
                                values.append(stringValue)
                            } else if let rawValue = cell.value {
                                hasReadableCell = true
                                values.append(rawValue)
                            } else if let inline = cell.inlineString?.text {
                                hasReadableCell = true
                                values.append(inline)
                            }
                        }

                        let trimmed = values.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        if trimmed.allSatisfy({ $0.isEmpty }) {
                            continue
                        }
                        lines.append(trimmed.joined(separator: "\t"))
                    }
                }
            }

            guard hasReadableCell else {
                throw FileImportError.unsupportedCell
            }

            return lines.joined(separator: "\n")
        } catch let error as FileImportError {
            throw error
        } catch {
            throw FileImportError.parseFailed(underlying: error)
        }
    }
}
