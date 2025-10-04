import SwiftUI

/// 负责展示分词器 UI 的主界面。
struct TokenizerMainView: View {
    @StateObject private var viewModel: TokenizerViewModel

    init(viewModel: TokenizerViewModel = TokenizerViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        HStack(spacing: 0) {
            inputSection
            Divider()
            resultSection
        }
        .frame(minWidth: 700, minHeight: 400)
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("输入文本")
                .font(.headline)
            TextEditor(text: $viewModel.inputText)
                .font(.body)
                .padding(8)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
            Spacer()
        }
        .padding()
        .frame(minWidth: 320)
    }

    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            tokenList
        }
        .padding()
        .frame(minWidth: 320, maxWidth: .infinity, alignment: .leading)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("分词结果")
                .font(.headline)
            HStack(spacing: 16) {
                Label("总词数：\(viewModel.totalTokenCount)", systemImage: "number")
                Label("唯一词数：\(viewModel.uniqueTokenCount)", systemImage: "circle.grid.cross")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private var tokenList: some View {
        Group {
            if viewModel.tokens.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "text.magnifyingglass")
                        .font(.system(size: 42))
                        .foregroundStyle(.secondary)
                    Text("暂无结果")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Text("请输入文本以查看分词结果")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(Array(viewModel.tokens.enumerated()), id: \.offset) { index, token in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 32, alignment: .trailing)
                        Text(token)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    TokenizerMainView(viewModel: TokenizerViewModel(initialText: "Hello SwiftUI tokenizer!"))
}
