# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Flutter habit tracking app (习惯打卡) that allows users to create habits with daily goals, track check-ins, and view streak statistics. Data persists locally using SharedPreferences.

## Development Commands

```bash
# Get dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Run on specific device
flutter run -d <device-id>

# Build for release
flutter build apk          # Android
flutter build ios          # iOS
flutter build macos        # macOS

# Run tests
flutter test

# Run a single test file
flutter test test/<test_file>.dart

# Analyze code
flutter analyze
```

## Architecture

**Data Flow:**
- `StorageService` handles all persistence via SharedPreferences, storing habits as JSON
- `Habit` model contains check-in logic (streak calculation, daily goal tracking)
- Main screen (`HabitListScreen`) manages the habit list and coordinates between UI and storage

**Key Components:**
- `lib/models/habit.dart` - Core data model with streak calculation and check-in counting
- `lib/services/storage_service.dart` - Persistence layer using SharedPreferences
- `lib/main.dart` - Main screen with habit list, reordering, and check-in UI
- `lib/screens/habit_detail_screen.dart` - Detail view for individual habits
- `lib/widgets/add_habit_dialog.dart` - Dialog for creating new habits

**Data Model:**
- Each habit has a `dailyGoal` (number of check-ins per day)
- `checkCounts` map tracks check-ins per date (format: 'YYYY-MM-DD')
- `checkedDates` list stores dates with at least one check-in
- Streak calculation counts consecutive days from today backwards
