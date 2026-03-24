import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/widgets/add_habit_dialog.dart';

void main() {
  group('AddHabitDialog', () {
    testWidgets('should display dialog with input fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AddHabitDialog())),
      );

      expect(find.text('添加习惯'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('每日目标：'), findsOneWidget);
      expect(find.text('目标天数：'), findsOneWidget);
    });

    testWidgets('should return null when cancel is pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => const AddHabitDialog(),
                  );
                  expect(result, isNull);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
    });

    testWidgets('should return habit data when confirmed with valid input', (
      tester,
    ) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (_) => const AddHabitDialog(),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '跑步');
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!['name'], '跑步');
      expect(result!['dailyGoal'], 1);
      expect(result!['targetDays'], 21);
    });

    testWidgets('should not return data when confirmed with empty input', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => const AddHabitDialog(),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('确认'));
      await tester.pump();

      expect(find.text('添加习惯'), findsOneWidget);
    });
  });
}
