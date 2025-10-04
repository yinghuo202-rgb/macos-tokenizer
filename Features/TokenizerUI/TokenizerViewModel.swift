import AppKit
import Combine
import Foundation
import UniformTypeIdentifiers

/// 用于展示提示弹窗的数据模型。
struct TokenizerAlert: Identifiable {
    let id = UUID()
    let message: String
}

/// 负责协调 UI 与分词引擎的视图模型。
@MainActor
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

    /// token 对应的词频映射。
    @Published private(set) var tokenFrequencies: [String: Int] = [:]

    /// 当前需要展示的提示信息。
    @Published var activeAlert: TokenizerAlert?

    /// 搜索框输入的关键字，驱动分词结果高亮。
    @Published var searchQuery: String = ""

    /// 当前搜索关键字匹配到的 token 数量。
    @Published var matchCount: Int = 0

    private let engine: TokenizerEngine
    private let fileImportService: FileImportService
    private let exportService: TokenExportService
    private let searchQueue = DispatchQueue(label: "com.macos-tokenizer.search", qos: .userInitiated)
    private var searchWorkItem: DispatchWorkItem?
    private var normalizedSearchQuery: String = ""

    /// 当前匹配到的 token 索引集合，用于驱动列表高亮。
    @Published private(set) var matchedTokenIndices: Set<Int> = []

    /// 创建视图模型实例。
    /// - Parameters:
    ///   - initialText: 初始输入文本，默认空字符串。
    ///   - engine: 分词引擎，默认使用 `DefaultTokenizerEngine`。
    ///   - fileImportService: 文件导入服务。
    ///   - exportService: 导出服务。
    init(initialText: String = "", engine: TokenizerEngine = DefaultTokenizerEngine(), fileImportService: FileImportService = FileImportService(), exportService: TokenExportService = TokenExportService()) {
        self.engine = engine
        self.fileImportService = fileImportService
        self.exportService = exportService
        self.inputText = initialText
        processInput()
    }

    private func processInput() {
        let result = engine.tokenize(inputText)
        tokens = result
        totalTokenCount = result.count
        uniqueTokenCount = Set(result).count
        tokenFrequencies = buildFrequencyMap(from: result)
        refreshSearchResultsForCurrentQuery()
    }

    private func buildFrequencyMap(from tokens: [String]) -> [String: Int] {
        var map: [String: Int] = [:]
        for token in tokens {
            map[token, default: 0] += 1
        }
        return map
    }

    /// 菜单动作：展示打开文件面板并导入内容。
    public func handleOpenFileCommand() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["txt", "xlsx"]
        panel.allowsMultipleSelection = false
        panel.begin { [weak panel] response in
            guard response == .OK, let url = panel?.url else { return }
            self.importFile(from: url)
        }
    }

    /// 菜单动作：导出为 CSV。
    public func handleExportCSV() {
        presentSavePanel(for: .csv)
    }

    /// 菜单动作：导出为 JSON。
    public func handleExportJSON() {
        presentSavePanel(for: .json)
    }

    /// 菜单动作：清空输入内容。
    public func handleClear() {
        inputText = ""
        activeAlert = TokenizerAlert(message: "已清空输入内容。")
    }

    /// 处理拖拽进入窗口的文件。
    /// - Parameter providers: 拖拽提供的项目列表。
    /// - Returns: 是否接管本次拖拽。
    public func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) }) else {
            presentError(message: "暂不支持该文件类型，请拖入 TXT 或 XLSX。", error: nil)
            return false
        }

        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
            if let error {
                DispatchQueue.main.async {
                    self.presentError(message: "读取拖拽文件失败。", error: error)
                }
                return
            }

            if let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                DispatchQueue.main.async {
                    self.importFile(from: url)
                }
            } else if let url = item as? URL {
                DispatchQueue.main.async {
                    self.importFile(from: url)
                }
            } else {
                DispatchQueue.main.async {
                    self.presentError(message: "无法识别拖入的文件地址。", error: nil)
                }
            }
        }

        return true
    }

    private func presentSavePanel(for format: TokenExportFormat) {
        guard !tokens.isEmpty else {
            activeAlert = TokenizerAlert(message: "暂无可导出的分词结果。")
            return
        }

        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        switch format {
        case .csv:
            panel.allowedFileTypes = ["csv"]
            panel.nameFieldStringValue = defaultFileName(withExtension: "csv")
        case .json:
            panel.allowedFileTypes = ["json"]
            panel.nameFieldStringValue = defaultFileName(withExtension: "json")
        }

        panel.begin { [weak panel] response in
            guard response == .OK, let url = panel?.url else { return }
            self.export(to: url, format: format)
        }
    }

    private func defaultFileName(withExtension ext: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        return "tokenizer-result-\(formatter.string(from: Date())).\(ext)"
    }

    private func importFile(from url: URL) {
        print("[导入] 准备读取文件: \(url.path)")
        let service = fileImportService
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let content = try service.importFile(at: url)
                DispatchQueue.main.async {
                    self.inputText = content
                    self.activeAlert = TokenizerAlert(message: "已导入 \(url.lastPathComponent)")
                    print("[导入] 成功: \(url.lastPathComponent)")
                }
            } catch {
                DispatchQueue.main.async {
                    self.presentError(message: (error as? LocalizedError)?.errorDescription ?? "导入失败。", error: error)
                }
            }
        }
    }

    private func export(to url: URL, format: TokenExportFormat) {
        let tokens = self.tokens
        let service = exportService
        print("[导出] 写入文件: \(url.path)")
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try service.export(tokens: tokens, to: url, format: format)
                DispatchQueue.main.async {
                    self.activeAlert = TokenizerAlert(message: "已导出至 \(url.lastPathComponent)")
                    print("[导出] 成功: \(url.lastPathComponent)")
                }
            } catch {
                DispatchQueue.main.async {
                    self.presentError(message: (error as? LocalizedError)?.errorDescription ?? "导出失败。", error: error)
                }
            }
        }
    }

    private func presentError(message: String, error: Error?) {
        if let error {
            print("[错误] \(message) -> \(error)")
        } else {
            print("[错误] \(message)")
        }
        activeAlert = TokenizerAlert(message: message)
    }

    /// 更新搜索关键字，使用去抖控制匹配刷新频率。
    /// - Parameter query: 最新输入的搜索关键字。
    public func updateSearch(query: String) {
        searchWorkItem?.cancel()
        searchQuery = query
        normalizedSearchQuery = normalize(query: query)
        matchedTokenIndices = []
        matchCount = 0

        guard !normalizedSearchQuery.isEmpty else { return }

        scheduleSearch(for: normalizedSearchQuery, delay: 0.2)
    }

    /// 判断指定位置的 token 是否匹配当前搜索。
    /// - Parameter index: token 在结果列表中的索引。
    /// - Returns: 是否为匹配项。
    public func isTokenMatched(index: Int) -> Bool {
        matchedTokenIndices.contains(index)
    }

    private func normalize(query: String) -> String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func scheduleSearch(for query: String, delay: TimeInterval) {
        let currentTokens = tokens
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            let (indices, count) = self.performSearch(tokens: currentTokens, query: query)
            DispatchQueue.main.async {
                guard self.normalizedSearchQuery == query else { return }
                self.matchedTokenIndices = indices
                self.matchCount = count
            }
        }
        searchWorkItem = workItem
        searchQueue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    private func performSearch(tokens: [String], query: String) -> (Set<Int>, Int) {
        guard !query.isEmpty else { return ([], 0) }
        var matchedIndices: Set<Int> = []
        var count = 0
        for (index, token) in tokens.enumerated() {
            if token.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil {
                matchedIndices.insert(index)
                count += 1
            }
        }
        return (matchedIndices, count)
    }

    private func refreshSearchResultsForCurrentQuery() {
        searchWorkItem?.cancel()
        guard !normalizedSearchQuery.isEmpty else {
            matchedTokenIndices = []
            matchCount = 0
            return
        }
        scheduleSearch(for: normalizedSearchQuery, delay: 0)
    }
}
