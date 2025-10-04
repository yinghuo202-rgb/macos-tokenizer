import SwiftUI

/// 负责展示分词器 UI 的主界面。
struct TokenizerMainView: View {
    @StateObject private var viewModel: TokenizerViewModel

    init(viewModel: TokenizerViewModel = TokenizerViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    toolbarCard

                    HStack(alignment: .top, spacing: DesignSystem.Spacing.lg) {
                        inputColumn
                            .frame(width: leftColumnWidth(for: proxy.size))

                        resultsColumn
                            .frame(width: rightColumnWidth(for: proxy.size))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.vertical, DesignSystem.Spacing.lg)
                .frame(minHeight: proxy.size.height, alignment: .top)
            }
            .frame(width: proxy.size.width)
            .background(DesignSystem.Colors.background)
        }
        .frame(minWidth: 900, minHeight: 600)
        .alert(item: $viewModel.activeAlert) { alert in
            Alert(title: Text("提示"), message: Text(alert.message), dismissButton: .default(Text("好的")))
        }
    }

    private var toolbarCard: some View {
        Card(title: "分析工具", subtitle: "导入、导出或切换分词引擎") {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Button {
                    viewModel.handleOpenFileCommand()
                } label: {
                    Label("导入文本", systemImage: "tray.and.arrow.down")
                        .font(DesignSystem.Typography.body)
                }
                .buttonStyle(.borderedProminent)
                .tint(DesignSystem.Colors.accent)

                if !viewModel.inputText.isEmpty {
                    DropZone(
                        icon: "tray.and.arrow.down.fill",
                        title: "拖拽导入",
                        message: "拖入 .txt/.xlsx",
                        size: .compact,
                        isLoading: viewModel.isBusy,
                        loadingMessage: viewModel.busyStatusMessage,
                        onOpen: {
                            viewModel.handleOpenFileCommand()
                        },
                        onDrop: { providers in
                            viewModel.handleDrop(providers: providers)
                        }
                    )
                    .frame(width: DesignSystem.Spacing.lg * 9)
                }

                Menu {
                    Button("导出 CSV") {
                        viewModel.handleExportCSV()
                    }
                    Button("导出 JSON") {
                        viewModel.handleExportJSON()
                    }
                } label: {
                    Label("导出结果", systemImage: "square.and.arrow.up")
                        .font(DesignSystem.Typography.body)
                }
                .menuStyle(.borderedButton)

                Button {
                    viewModel.handleClear()
                } label: {
                    Label("清空输入", systemImage: "trash")
                        .font(DesignSystem.Typography.body)
                }
                .buttonStyle(.bordered)
                .tint(DesignSystem.Colors.textSecondary)

                Spacer(minLength: DesignSystem.Spacing.md)

                Menu {
                    ForEach(viewModel.engineOptions) { option in
                        Button(option.displayName) {
                            viewModel.selectEngine(option)
                        }
                        .disabled(!option.isAvailable)
                    }
                } label: {
                    Label(viewModel.selectedEngine.displayName, systemImage: "gearshape.2.fill")
                        .font(DesignSystem.Typography.body)
                }
                .menuStyle(.borderedButton)
            }
        }
    }

    private var inputColumn: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Card(title: "输入文本", subtitle: "支持粘贴、拖拽或导入文件") {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    if viewModel.inputText.isEmpty {
                        DropZone(
                            icon: "square.and.arrow.down.on.square.fill",
                            title: "拖拽文件以导入",
                            message: "拖拽 .txt/.xlsx 或按 ⌘O 打开",
                            size: .large,
                            isLoading: viewModel.isBusy,
                            loadingMessage: viewModel.busyStatusMessage,
                            onOpen: {
                                viewModel.handleOpenFileCommand()
                            },
                            onDrop: { providers in
                                viewModel.handleDrop(providers: providers)
                            }
                        )
                    }

                    inputEditor

                    Divider()
                        .background(DesignSystem.Colors.divider)

                    settingsSection
                }
            }
        }
    }

    private var inputEditor: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(DesignSystem.Colors.background)

            TextEditor(text: $viewModel.inputText)
                .font(DesignSystem.Typography.body)
                .padding(DesignSystem.Spacing.sm)
                .background(Color.clear)
                .frame(minHeight: 320)

            if viewModel.inputText.isEmpty {
                Text("粘贴文本、拖入 .txt/.xlsx，或按 ⌘O 打开文件开始分词。")
                    .font(DesignSystem.Typography.body)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .padding(.top, DesignSystem.Spacing.sm)
                    .padding(.horizontal, DesignSystem.Spacing.sm)
                    .allowsHitTesting(false)
            }
        }
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("分析设置")
                .font(DesignSystem.Typography.label)
                .foregroundStyle(DesignSystem.Colors.textSecondary)

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                settingRow(title: "语言", value: "自动检测")
                settingRow(title: "粒度", value: "按单词切分")
                settingRow(title: "导入提示", value: "支持 TXT/XLSX 拖拽")
            }

            HStack(spacing: DesignSystem.Spacing.sm) {
                Text("实时状态")
                    .font(DesignSystem.Typography.body)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                Badge(style: viewModel.isBusy ? .warning : .success, text: statusText)
                Spacer()
            }
        }
    }

    private var statusText: String {
        if viewModel.isBusy {
            return viewModel.busyStatusMessage ?? "处理中"
        }
        return "实时分词"
    }

    private var resultsColumn: some View {
        ZStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                resultCard
                frequencyCard
                statsGrid
            }

            if viewModel.isBusy {
                Color.black.opacity(0.05)
                    .ignoresSafeArea()

                ProgressView(viewModel.busyStatusMessage ?? "处理中…")
                    .progressViewStyle(.circular)
                    .controlSize(.large)
                    .padding(DesignSystem.Spacing.lg)
                    .background(DesignSystem.Colors.card)
                    .cornerRadius(DesignSystem.CornerRadius.card)
                    .shadow(
                        color: DesignSystem.Shadows.card.color,
                        radius: DesignSystem.Shadows.card.radius,
                        x: DesignSystem.Shadows.card.x,
                        y: DesignSystem.Shadows.card.y
                    )
            }
        }
    }

    private var resultCard: some View {
        Card(title: "分词结果", subtitle: resultSubtitle) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                searchBar

                Divider()
                    .background(DesignSystem.Colors.divider)

                if viewModel.tokens.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            ForEach(Array(viewModel.tokens.enumerated()), id: \.offset) { index, token in
                                tokenRow(index: index, token: token)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    .frame(minHeight: 240)
                }
            }
        }
    }

    private var resultSubtitle: String {
        if viewModel.tokens.isEmpty {
            return "等待输入以展示分词结果"
        }
        return "共 \(viewModel.totalTokenCount) 个词元"
    }

    private var emptyState: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(DesignSystem.Colors.textSecondary)
            Text("还没有分词结果")
                .font(DesignSystem.Typography.title)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
            Text("粘贴文本、拖入文件或按 ⌘O 打开文档开始分析。")
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 240)
    }

    private func tokenRow(index: Int, token: String) -> some View {
        let isMatched = viewModel.isTokenMatched(index: index)
        return HStack(alignment: .top, spacing: DesignSystem.Spacing.sm) {
            Text(String(format: "#%03d", index + 1))
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .frame(width: 56, alignment: .leading)

            Text(token)
                .font(DesignSystem.Typography.body)
                .foregroundStyle(isMatched ? DesignSystem.Colors.accent : DesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.leading)

            Spacer(minLength: DesignSystem.Spacing.sm)

            if let frequency = viewModel.tokenFrequencies[token] {
                Text("\(frequency) 次")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }
        }
        .padding(.vertical, DesignSystem.Spacing.xs)
        .padding(.horizontal, DesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isMatched ? DesignSystem.Colors.accent.opacity(0.12) : DesignSystem.Colors.background)
        )
    }

    private var searchBar: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                TextField(
                    "搜索分词",
                    text: Binding(
                        get: { viewModel.searchQuery },
                        set: { viewModel.updateSearch(query: $0) }
                    )
                )
                .textFieldStyle(.plain)
                .font(DesignSystem.Typography.body)

                if !viewModel.searchQuery.isEmpty {
                    Button {
                        viewModel.updateSearch(query: "")
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("清除搜索")
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .background(DesignSystem.Colors.background)
            .cornerRadius(12)

            if !viewModel.searchQuery.isEmpty {
                Badge(style: .info, text: "命中 \(viewModel.matchCount)")
            }

            Spacer()
        }
    }

    private var frequencyCard: some View {
        Card(title: "词频 Top 20", subtitle: "按照出现次数排序") {
            if topTokenFrequencies.isEmpty {
                Text("暂无词频统计，先输入文本开始分析。")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            } else {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    ForEach(Array(topTokenFrequencies.enumerated()), id: \.element.token) { index, item in
                        if index > 0 {
                            Divider()
                                .background(DesignSystem.Colors.divider)
                        }

                        HStack(alignment: .center, spacing: DesignSystem.Spacing.sm) {
                            Text(String(format: "#%02d", index + 1))
                                .font(DesignSystem.Typography.label)
                                .foregroundStyle(DesignSystem.Colors.textSecondary)
                                .frame(width: 52, alignment: .leading)

                            Text(item.token)
                                .font(DesignSystem.Typography.body)
                                .foregroundStyle(DesignSystem.Colors.textPrimary)
                                .lineLimit(2)

                            Spacer()

                            Text("\(item.count) 次")
                                .font(DesignSystem.Typography.body)
                                .foregroundStyle(DesignSystem.Colors.textSecondary)
                        }
                    }
                }
            }
        }
    }

    private var statsGrid: some View {
        let columns = [
            GridItem(.adaptive(minimum: 220), spacing: DesignSystem.Spacing.lg, alignment: .top)
        ]

        return LazyVGrid(columns: columns, alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            StatCard(
                title: "总词数",
                value: "\(viewModel.totalTokenCount)",
                icon: "number",
                footnote: "包含重复项"
            )

            StatCard(
                title: "唯一词数",
                value: "\(viewModel.uniqueTokenCount)",
                icon: "circle.grid.cross",
                footnote: "去重后统计"
            )

            StatCard(
                title: "处理耗时",
                value: formattedDuration,
                icon: "timer",
                footnote: "最近一次分词"
            )
        }
    }

    private var formattedDuration: String {
        guard viewModel.processingDuration > 0 else { return "--" }
        return String(format: "%.2f 秒", viewModel.processingDuration)
    }

    private var topTokenFrequencies: [(token: String, count: Int)] {
        let sorted = viewModel.tokenFrequencies.sorted { lhs, rhs in
            if lhs.value == rhs.value {
                return lhs.key < rhs.key
            }
            return lhs.value > rhs.value
        }
        return Array(sorted.prefix(20))
            .map { (token: $0.key, count: $0.value) }
    }

    private func settingRow(title: String, value: String) -> some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(DesignSystem.Typography.body)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
            Spacer()
            Text(value)
                .font(DesignSystem.Typography.body)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
        }
    }

    private func leftColumnWidth(for size: CGSize) -> CGFloat {
        max(size.width * 0.32, 320)
    }

    private func rightColumnWidth(for size: CGSize) -> CGFloat {
        max(size.width - leftColumnWidth(for: size) - DesignSystem.Spacing.lg, 480)
    }
}

#Preview {
    TokenizerMainView(viewModel: TokenizerViewModel(initialText: "Hello SwiftUI tokenizer!"))
}
