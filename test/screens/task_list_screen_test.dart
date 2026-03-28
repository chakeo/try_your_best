import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen', () {
    testWidgets('renders screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TaskListScreen(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
