import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/subtask.dart';
import 'package:try_your_best/models/time_session.dart';

void main() {
  group('Subtask', () {
    test('should create subtask with required fields', () {
      final subtask = Subtask(
        id: '1',
        name: '编写代码',
        parentTaskId: 'task1',
      );

      expect(subtask.id, '1');
      expect(subtask.name, '编写代码');
      expect(subtask.parentTaskId, 'task1');
    });

    test('should calculate total minutes correctly', () {
      final subtask = Subtask(
        id: '1',
        name: '编写代码',
        parentTaskId: 'task1',
        sessions: [
          TimeSession(
            id: '1',
            startTime: DateTime(2026, 3, 24, 9, 0),
            endTime: DateTime(2026, 3, 24, 10, 0),
            durationMinutes: 60,
          ),
          TimeSession(
            id: '2',
            startTime: DateTime(2026, 3, 24, 14, 0),
            endTime: DateTime(2026, 3, 24, 15, 30),
            durationMinutes: 90,
          ),
        ],
      );

      expect(subtask.getTotalMinutes(), 150);
    });
  });
}
