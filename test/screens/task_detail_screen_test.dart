import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/task.dart';
import 'package:try_your_best/models/subtask.dart';
import 'package:try_your_best/screens/task_detail_screen.dart';

void main() {
  testWidgets('should display all subtasks', (WidgetTester tester) async {
    final task = Task(
      id: '1',
      name: '测试任务',
      deadline: DateTime(2026, 3, 31),
      subtasks: [
        Subtask(id: '1', name: '小任务1', parentTaskId: '1'),
        Subtask(id: '2', name: '小任务2', parentTaskId: '1'),
        Subtask(id: '3', name: '小任务3', parentTaskId: '1'),
      ],
    );

    await tester.pumpWidget(MaterialApp(
      home: TaskDetailScreen(task: task),
    ));

    expect(find.text('小任务1'), findsOneWidget);
    expect(find.text('小任务2'), findsOneWidget);
    expect(find.text('小任务3'), findsOneWidget);
  });
}
