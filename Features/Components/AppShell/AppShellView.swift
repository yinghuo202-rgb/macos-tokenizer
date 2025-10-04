import SwiftUI

/// `AppShellView` 构建应用壳层，提供统一的侧边栏导航与顶部工具栏。
struct AppShellView: View {
    @ObservedObject var tokenizerViewModel: TokenizerViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var systemColorScheme
    @StateObject private var dashboardViewModel = DashboardViewModel()
    @State private var selection: AppRoute? = .analyze

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailContainer
        }
        .navigationSplitViewStyle(.balanced)
        .preferredColorScheme(themeManager.currentColorScheme)
        .onAppear(perform: syncTheme)
        .onChange(of: systemColorScheme) { _ in
            syncTheme()
        }
        .onChange(of: themeManager.mode) { _ in
            syncTheme()
        }
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
        .scrollContentBackground(.hidden)
        .background(DesignSystem.Colors.background)
        .navigationTitle("macOS Tokenizer")
    }

    private var detailContainer: some View {
        let activeRoute = selection ?? .analyze
        return VStack(spacing: 0) {
            topBar(for: activeRoute)
            Divider()
                .background(DesignSystem.Colors.separator)
            detailContent(for: activeRoute)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(DesignSystem.Colors.background)
        }
        .background(DesignSystem.Colors.background)
    }

    private func topBar(for route: AppRoute) -> some View {
        HStack(spacing: 16) {
            Label(route.title, systemImage: route.systemImageName)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            Spacer()
            HStack(spacing: 12) {
                themeMenu
                // 右侧预留操作区域，后续放入导入/导出等按钮。
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(DesignSystem.Colors.card)
    }

    @ViewBuilder
    private func detailContent(for route: AppRoute) -> some View {
        switch route {
        case .dashboard:
            DashboardView(viewModel: dashboardViewModel)
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

    private func syncTheme() {
        themeManager.updateSystemColorScheme(systemColorScheme)
        DesignSystem.Colors.use(themeManager.activePalette)
        DesignSystem.Shadows.use(themeManager.activeShadows)
    }

    private var themeMenu: some View {
        Menu {
            ForEach(ThemeMode.allCases) { mode in
                Button {
                    themeManager.apply(mode)
                } label: {
                    Label(mode.displayName, systemImage: mode.symbolName)
                    if themeManager.mode == mode {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Label(themeManager.mode.displayName, systemImage: themeManager.mode.symbolName)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .menuStyle(.borderlessButton)
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
            .foregroundStyle(isSelected ? DesignSystem.Colors.accent : DesignSystem.Colors.textPrimary)
            .onHover { hovering in
                isHovered = hovering
            }
    }

    private var background: some View {
        Group {
            if isSelected {
                DesignSystem.Colors.accent.opacity(0.18)
            } else if isHovered {
                DesignSystem.Colors.elevatedCard.opacity(0.6)
            } else {
                Color.clear
            }
        }
    }
}

#Preview {
    AppShellView(tokenizerViewModel: TokenizerViewModel())
}
