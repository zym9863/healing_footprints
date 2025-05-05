# 愈迹 (Healing Footprints)

[English](README_EN.md) | 简体中文

一款情绪追踪与心理健康管理的Flutter应用。

## 项目概述

愈迹是一个帮助用户记录、追踪和分析日常情绪变化的应用程序。通过简单直观的界面，用户可以记录自己的情绪状态、能量水平和相关笔记，从而更好地了解自己的心理健康状况。

## 功能特点

- 情绪日记：记录每日情绪状态
- 情绪统计：查看情绪变化趋势和统计数据
- 能量水平追踪：记录每日精力和活力水平
- 直观的用户界面：简洁易用的设计

## 项目结构

```
lib/
├── models/          # 数据模型
│   └── mood_entry.dart
├── providers/       # 状态管理
│   └── mood_provider.dart
├── screens/         # 应用界面
│   └── mood_journal/
│       ├── mood_entry_screen.dart
│       ├── mood_journal_screen.dart
│       └── mood_stats_screen.dart
├── services/        # 服务层
│   └── database_helper.dart
├── theme/           # 应用主题
│   └── app_theme.dart
├── widgets/         # 可复用组件
│   ├── empty_state.dart
│   ├── energy_level_slider.dart
│   ├── loading_indicator.dart
│   ├── mood_entry_card.dart
│   └── mood_selector.dart
└── main.dart        # 应用入口
```

## 开发环境

- Flutter
- Dart
- Provider (状态管理)
- SQLite (本地数据存储)

## 开始使用

1. 确保已安装Flutter开发环境
2. 克隆此仓库
3. 运行 `flutter pub get` 安装依赖
4. 运行 `flutter run` 启动应用
