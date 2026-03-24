import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/habit.dart';

void main() {
  group('Habit', () {
    test('should create instance with required fields', () {
      final habit = Habit(id: '1', name: 'Exercise', checkedDates: []);

      expect(habit.id, '1');
      expect(habit.name, 'Exercise');
      expect(habit.dailyGoal, 1);
      expect(habit.targetDays, 21);
    });

    test('should serialize to JSON correctly', () {
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        checkedDates: ['2026-03-24'],
        dailyGoal: 2,
        targetDays: 30,
        checkCounts: {'2026-03-24': 2},
      );

      final json = habit.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Exercise');
      expect(json['checkedDates'], ['2026-03-24']);
      expect(json['dailyGoal'], 2);
      expect(json['targetDays'], 30);
      expect(json['checkCounts'], {'2026-03-24': 2});
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': '1',
        'name': 'Exercise',
        'checkedDates': ['2026-03-24'],
        'dailyGoal': 2,
        'targetDays': 30,
        'checkCounts': {'2026-03-24': 2},
      };

      final habit = Habit.fromJson(json);

      expect(habit.id, '1');
      expect(habit.name, 'Exercise');
      expect(habit.checkedDates, ['2026-03-24']);
      expect(habit.dailyGoal, 2);
      expect(habit.targetDays, 30);
      expect(habit.checkCounts, {'2026-03-24': 2});
    });

    test('should return 0 streak for empty checkedDates', () {
      final habit = Habit(id: '1', name: 'Exercise', checkedDates: []);
      expect(habit.getStreakDays(), 0);
    });

    test('should calculate streak correctly for consecutive days', () {
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        checkedDates: ['2026-03-24', '2026-03-23', '2026-03-22'],
      );
      expect(habit.getStreakDays(), 3);
    });

    test('should return today check count', () {
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        checkedDates: [],
        checkCounts: {'2026-03-24': 3},
      );
      expect(habit.getTodayCheckCount(), 3);
    });

    test('should return true when checked today', () {
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        checkedDates: ['2026-03-24'],
        checkCounts: {'2026-03-24': 1},
      );
      expect(habit.isCheckedToday(), true);
    });
  });
}
