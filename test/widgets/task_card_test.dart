import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/task.dart';
import 'package:try_your_best/widgets/task_card.dart';

void main() {
  group('TaskCard', () {
    test('displays task name', () {
      final task = Task(
        id: '1',
        name: 'Test Task',
        deadline: DateTime.now().add(const Duration(days: 5)),
        subtasks: [],
      );

      expect(task.name, 'Test Task');
    });

    testWidgets('renders without error', (tester) async {
      final task = Task(
        id: '1',
        name: 'Test Task',
        deadline: DateTime.now().add(const Duration(days: 5)),
        subtasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: task,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Task'), findsOneWidget);
    });
  });
}
