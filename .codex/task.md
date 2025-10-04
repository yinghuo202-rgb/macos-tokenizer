# TODO:任务清单
# Codex 首批任务清单

## A-01 初始化 Xcode 工程
- 目标：在仓库根目录生成一个 macOS SwiftUI 工程
- 修改范围：Xcode 工程文件 + App.swift
- 验收标准：
  - 可以在 Xcode 构建并运行一个空白窗口
  - 工程名为 "macos-tokenizer"
  - 部署目标 macOS 13.0+
  - 无编译警告
- 交付物：文件清单、运行步骤说明

## A-02 映射目录到 Xcode 分组
- 目标：将现有物理目录 (App, Core, Features, Resources, Tests) 映射为 Xcode 工程分组
- 修改范围：Xcode 工程文件
- 验收标准：
  - 分组结构与目录一致
  - 禁止新建未定义目录
- 交付物：分组结构说明

## A-03 创建 MVVM 占位文件
- 目标：在 Features/TokenizerUI/ 与 Core/Tokenization/ 中创建空壳文件
- 修改范围：Swift 文件（空实现 + 注释）
- 验收标准：
  - 编译通过
  - 注释写清楚文件用途与输入/输出
- 交付物：文件清单 + 注释

## A-04 添加菜单占位
- 目标：在 App 中添加菜单项（打开文件、导出结果、清空），功能暂时可空
- 修改范围：App.swift
- 验收标准：
  - 菜单能显示在 macOS 菜单栏
  - 快捷键可触发（仅打印日志）
- 交付物：用户操作路径 + 预期行为说明

# Codex 任务清单（B 阶段）

## B 阶段目标
在 A 阶段（基础工程与结构）之上，构建一个“最小可用”的 macOS 分词工具：
- 支持 `.txt` 与 `.xlsx` 文件导入；
- 实时分词展示与词频统计；
- 支持导出 CSV / JSON；
- 具备空态提示、基本搜索高亮；
- 保持 0 警告、不联网、不引入非批准依赖。

允许引入：
- CoreXLSX（MIT License）——仅用于解析 `.xlsx` 文件。

---

## B-01 串联 UI 与分词引擎（最小可用视图）
**目标**
- 把 `Features/TokenizerUI/View` 与 `ViewModel`、`Core/Tokenization/TokenizerEngine` 连接起来；
- 输入框中的文字实时分词并展示在右侧；
- 右侧同时显示词数与唯一词数统计。

**修改范围**
- `Features/TokenizerUI/*` （View、ViewModel）
- `Core/Tokenization/*` （TokenizerEngine 实现）

**验收标准**
- 输入变更即触发分词；
- 界面实时刷新；
- 显示总词数与唯一词数；
- 0 警告；
- 提供运行步骤说明。

**交付物**
- 变更清单；
- 新增/修改文件内容；
- 运行步骤说明；
- commit message：`feat: 串联 UI 与分词引擎 (B-01)`

---

## B-02 文件导入 / 导出（支持 txt 与 xlsx）
**目标**
- 支持通过菜单或拖拽导入 `.txt` 与 `.xlsx` 文件；
- 解析文件内容并显示在输入框；
- 导出分词结果为 `.csv` 与 `.json`；
- 不支持的格式需弹窗提示。

**修改范围**
- `Core/FileImporter/*`（新增）
- `Core/Export/*`
- `Features/TokenizerUI/*`（集成导入导出逻辑）

**验收标准**
- 打开 / 拖入 `.txt` 或 `.xlsx` 能正确显示；
- 识别文件类型自动解析；
- 导出功能可用；
- 无崩溃；
- 0 警告；
- 提供运行说明。

**交付物**
- 变更清单；
- 文件内容；
- 运行步骤；
- commit message：`feat: 文件导入导出与多格式支持 (B-02)`

---

## B-03 空态与搜索高亮
**目标**
- 在输入为空时显示空态占位；
- 在结果区添加搜索框，可高亮匹配的 token；
- 清空搜索框时恢复原状态；
- 搜索结果显示匹配数量。

**修改范围**
- `Features/TokenizerUI/*`（View 与 ViewModel）

**验收标准**
- 空态提示友好；
- 搜索高亮可见；
- 匹配数准确；
- 0 警告；
- 提供运行步骤。

**交付物**
- 变更清单；
- 文件内容；
- 运行步骤；
- commit message：`feat: 空态与搜索高亮 (B-03)`

---

## B-04 错误提示与健壮性
**目标**
- 对打开、解析、导出失败等场景，提供用户友好的提示；
- 保证任何错误都不会导致应用崩溃；
- 所有异常路径打印日志并提示 alert。

**修改范围**
- `Core/FileImporter/*`
- `Features/TokenizerUI/*`

**验收标准**
- 错误提示清晰（弹窗或 alert）；
- 不崩溃；
- 控制台有详细日志；
- 0 警告。

**交付物**
- 变更清单；
- 文件内容；
- 运行步骤；
- commit message：`fix: 增加错误提示与异常防护 (B-04)`

# Codex 任务清单（B+ 阶段：UI 优化）

## B+-01 建立 AppShell 与侧边栏
- 目标：实现通用应用壳层（侧边栏 + 顶栏 + 内容容器），侧边栏包含：首页、单文分析、批量、词典、日志、设置。
- 修改范围：Features/Components/AppShell/*，Features/Shell/*
- 验收标准：
  - 侧边栏图标+文字；选中态；内容区域显示占位页面（先写“Coming soon”）
  - 0 警告；不改业务逻辑
- 交付物：变更清单、文件内容、运行步骤、commit message（`feat: AppShell 与侧边栏框架 (B+-01)`）

---

## B+-02 卡片与统计组件
- 目标：实现 Card/StatCard/KeyValueCard/Badge 组件，并集中管理 Design Tokens（颜色、圆角、阴影、间距）。
- 修改范围：Features/Components/*，Core/Infra/DesignSystem.swift
- 验收标准：
  - 统一风格的卡片；支持标题、副标题、右上角动作插槽
  - StatCard 显示大数字；Badge 有 Success/Warning/Error/Info 四种状态色
  - 0 警告
- 交付物：变更清单、文件内容、运行步骤、commit message（`feat: 通用卡片与统计组件 (B+-02)`）

---

## B+-03 首页 Dashboard（占位数据）
- 目标：实现首页网格布局（3 列自适应），填入占位卡片：统计 3 张、Top-N 词频表（假数据）、最近文件列表、快速开始卡。
- 修改范围：Features/Dashboard/*，Features/Components/*
- 验收标准：
  - 自适应网格（窗口变宽收缩）
  - 卡片间距一致；标题与动作对齐
  - 假数据占位；0 警告
- 交付物：变更清单、文件内容、运行步骤、commit message（`feat: 首页 Dashboard 网格与占位内容 (B+-03)`）

---

## B+-04 Sparkline 趋势组件（可选）
- 目标：使用 Charts 框架实现火花线图，用于“最近处理耗时/词数趋势”。
- 修改范围：Features/Components/SparklineView.swift
- 验收标准：
  - 单色线图；禁用图例；支持外部传入数据
  - 0 警告
- 交付物：变更清单、文件内容、运行步骤、commit message（`feat: Sparkline 趋势组件 (B+-04)`）

---

## B+-05 单文分析页卡片化布局
- 目标：把现有 Analyze 页替换为卡片化布局：左侧“输入与设置”卡 + 右侧“结果高亮”卡 + “词频表”卡 + 顶部工具条。
- 修改范围：Features/TokenizerUI/*
- 验收标准：
  - 视觉风格与 Dashboard 统一
  - 功能与 B 阶段一致（输入→分词、导入、导出）
  - 0 警告
- 交付物：变更清单、文件内容、运行步骤、commit message（`refactor: 分析页卡片化布局 (B+-05)`）

---

## B+-06 DropZone 与文件导入 UX 优化
- 目标：统一拖拽视觉（虚线边框 + 提示文案），支持 .txt / .xlsx 文件。
- 修改范围：Features/Components/DropZone.swift，Features/TokenizerUI/*
- 验收标准：
  - 拖入悬浮样式变化
  - 不支持格式时弹出提示（不崩溃）
  - 0 警告
- 交付物：变更清单、文件内容、运行步骤、commit message（`feat: DropZone 与导入 UX 优化 (B+-06)`）

---

## B+-07 主题与暗色支持
- 目标：实现浅色 / 暗色两套 Design Tokens，支持跟随系统或手动切换。
- 修改范围：Core/Infra/DesignSystem.swift，App 入口
- 验收标准：
  - 浅色与暗色下均可读；颜色/阴影/分隔线适配
  - 0 警告
- 交付物：变更清单、文件内容、运行步骤、commit message（`feat: 主题系统与暗色支持 (B+-07)`）
