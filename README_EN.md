# Healing Footprints (愈迹)

English | [简体中文](README.md)

A Flutter application for mood tracking and mental health management.

## Project Overview

Healing Footprints is an application that helps users record, track, and analyze their daily mood changes. Through a simple and intuitive interface, users can record their emotional states, energy levels, and related notes to better understand their mental health.

## Features

- Mood Journal: Record daily emotional states
- Mood Statistics: View mood trends and statistical data
- Energy Level Tracking: Record daily energy and vitality levels
- Intuitive User Interface: Clean and easy-to-use design

## Project Structure

```
lib/
├── models/          # Data models
│   └── mood_entry.dart
├── providers/       # State management
│   └── mood_provider.dart
├── screens/         # Application screens
│   └── mood_journal/
│       ├── mood_entry_screen.dart
│       ├── mood_journal_screen.dart
│       └── mood_stats_screen.dart
├── services/        # Services layer
│   └── database_helper.dart
├── theme/           # Application theme
│   └── app_theme.dart
├── widgets/         # Reusable components
│   ├── empty_state.dart
│   ├── energy_level_slider.dart
│   ├── loading_indicator.dart
│   ├── mood_entry_card.dart
│   └── mood_selector.dart
└── main.dart        # Application entry point
```

## Development Environment

- Flutter
- Dart
- Provider (state management)
- SQLite (local data storage)

## Getting Started

1. Ensure Flutter development environment is installed
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to launch the application
