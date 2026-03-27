# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

A Flutter app with two independent modules:
- **习惯打卡 (Habit Tracking)**: Daily habit check-ins with streak tracking
- **任务管理 (Task Management)**: Task tracking with time sessions and subtasks

## Development Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run specific test
flutter test test/<test_file>.dart

# Analyze code
flutter analyze
```

## Module Structure

**Habit Module** (see `.claude/habit.md` for details):
- `lib/models/habit.dart`
- `lib/services/storage_service.dart`
- `lib/screens/habit_detail_screen.dart`
- `lib/widgets/add_habit_dialog.dart`
- `HabitListScreen` in `lib/main.dart`

**Task Module** (see `.claude/task.md` for details):
- `lib/models/task.dart`, `subtask.dart`, `time_session.dart`
- `lib/services/task_storage_service.dart`
- `lib/screens/task_list_screen.dart`, `task_detail_screen.dart`
- `lib/widgets/add_task_dialog.dart`, `task_card.dart`

**Shared**:
- `lib/main.dart` - App entry and bottom navigation
- `lib/widgets/header_widget.dart`
