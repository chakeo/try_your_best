import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/task.dart';
import 'package:try_your_best/models/time_session.dart';

void main() {
  group('Task', () {
    test('should create task with required fields in minutes', () {
      final task = Task(
        id: '1',
        name: '学习Flutter',
        targetMinutes: 120,
        deadline: DateTime(2026, 3, 31),
      );

      expect(task.id, '1');
      expect(task.name, '学习Flutter');
      expect(task.targetMinutes, 120);
      expect(task.status, TaskStatus.active);
    });

    test('should calculate progress correctly with minutes', () {
      final task = Task(
        id: '1',
        name: '学习Flutter',
        targetMinutes: 120,
        deadline: DateTime(2026, 3, 31),
        sessions: [
          TimeSession(
            id: '1',
            startTime: DateTime(2026, 3, 24, 9, 0),
            endTime: DateTime(2026, 3, 24, 10, 0),
            durationMinutes: 60,
          ),
        ],
      );

      expect(task.getProgress(), 0.5);
    });

    test('should calculate total minutes correctly', () {
      final task = Task(
        id: '1',
        name: '学习Flutter',
        targetMinutes: 180,
        deadline: DateTime(2026, 3, 31),
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

      expect(task.getTotalMinutes(), 150);
    });

    test('should serialize to JSON correctly', () {
      final task = Task(
        id: '1',
        name: '学习Flutter',
        targetMinutes: 120,
        deadline: DateTime(2026, 3, 31),
        status: TaskStatus.active,
      );

      final json = task.toJson();

      expect(json['id'], '1');
      expect(json['name'], '学习Flutter');
      expect(json['targetMinutes'], 120);
      expect(json['status'], 0);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': '1',
        'name': '学习Flutter',
        'targetMinutes': 120,
        'deadline': '2026-03-31T00:00:00.000',
        'status': 0,
        'sessions': [],
      };

      final task = Task.fromJson(json);

      expect(task.id, '1');
      expect(task.name, '学习Flutter');
      expect(task.targetMinutes, 120);
      expect(task.status, TaskStatus.active);
    });
  });
}


