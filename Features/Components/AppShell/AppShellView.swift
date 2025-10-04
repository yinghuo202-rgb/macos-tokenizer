import SwiftUI

/// `AppShellView` 构建应用壳层，提供统一的侧边栏导航与顶部工具栏。
struct AppShellView: View {
    @ObservedObject var tokenizerViewModel: TokenizerViewModel
    @State private var selection: AppRoute? = .analyze

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailContainer
        }
        .navigationSplitViewStyle(.balanced)
    }

    private var sidebar: some View {
        List(selection: $selection) {
            ForEach(AppRoute.allCases) { route in
                SidebarItem(route: route, isSelected: selection == route)
                    .tag(route)
                    .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("macOS Tokenizer")
    }

    private var detailContainer: some View {
        let activeRoute = selection ?? .analyze
        return VStack(spacing: 0) {
            topBar(for: activeRoute)
            Divider()
            detailContent(for: activeRoute)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(nsColor: .underPageBackgroundColor))
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private func topBar(for route: AppRoute) -> some View {
        HStack(spacing: 16) {
            Label(route.title, systemImage: route.systemImageName)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            HStack(spacing: 12) {
                // 右侧预留操作区域，后续放入导入/导出等按钮。
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private func detailContent(for route: AppRoute) -> some View {
        switch route {
        case .dashboard:
            DashboardPlaceholderView()
        case .analyze:
            AnalyzeWorkspaceView(viewModel: tokenizerViewModel)
        case .batch:
            BatchPlaceholderView()
        case .dictionaries:
            DictionariesPlaceholderView()
        case .logs:
            LogsPlaceholderView()
        case .settings:
            SettingsPlaceholderView()
        }
    }
}

private struct SidebarItem: View {
    let route: AppRoute
    let isSelected: Bool
    @State private var isHovered: Bool = false

    var body: some View {
        Label(route.title, systemImage: route.systemImageName)
            .font(.body)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
            .onHover { hovering in
                isHovered = hovering
            }
    }

    private var background: some View {
        Group {
            if isSelected {
                Color.accentColor.opacity(0.15)
            } else if isHovered {
                Color.secondary.opacity(0.1)
            } else {
                Color.clear
            }
        }
    }
}

#Preview {
    AppShellView(tokenizerViewModel: TokenizerViewModel())
}
