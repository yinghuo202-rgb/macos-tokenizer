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
