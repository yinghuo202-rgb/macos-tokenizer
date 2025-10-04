# TODO:项目目标说明
# 项目说明（macOS 分词工具）

## 项目目标
- 构建一个 macOS 原生分词工具
- UI 优先，先能展示输入与分词结果，再逐步接入更强的分词引擎
- 支持文本输入、文件拖拽、分词结果高亮、词频统计、CSV/JSON 导出

## 技术栈
- **语言**: Swift 5.9+
- **UI 框架**: SwiftUI，采用 MVVM 模式
- **构建工具**: Xcode，依赖管理用 SPM
- **初期分词引擎**: Apple 自带 `NaturalLanguage.NLTokenizer`
- **未来扩展**: 支持 cppjieba 或远程分词服务

## 项目分层
- `App/`：应用入口（App.swift、场景）
- `Core/`：核心逻辑（分词引擎、导出工具、数据模型、基础设施）
- `Features/`：功能模块（TokenizerUI）
- `Resources/`：静态资源（图标、本地化、示例文本）
- `Tests/`：单元测试与快照测试
- `.codex/`：Codex 协作说明与任务

## 平台说明
- 最终构建只能在 macOS + Xcode 下完成
- Windows 上可以编辑逻辑代码和说明文档，但不能直接运行应用
