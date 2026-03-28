import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/habit.dart';
import 'package:try_your_best/screens/habit_detail_screen.dart';

void main() {
  group('HabitDetailScreen', () {
    testWidgets('renders screen with habit', (tester) async {
      final habit = Habit(
        id: '1',
        name: 'Test Habit',
        dailyGoal: 1,
        targetDays: 7,
        checkedDates: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: HabitDetailScreen(
            habit: habit,
            onDelete: () {},
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
