import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/widgets/add_task_dialog.dart';

void main() {
  group('AddTaskDialog', () {
    testWidgets('renders dialog with title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddTaskDialog(),
          ),
        ),
      );

      expect(find.text('添加任务'), findsOneWidget);
    });

    testWidgets('has task name input field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddTaskDialog(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });
  });
}
