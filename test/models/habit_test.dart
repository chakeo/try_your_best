import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/habit.dart';

void main() {
  group('Habit', () {
    late String todayStr;
    late String yesterdayStr;
    late String twoDaysAgoStr;

    setUp(() {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final yesterday = today.subtract(const Duration(days: 1));
      yesterdayStr = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

      final twoDaysAgo = today.subtract(const Duration(days: 2));
      twoDaysAgoStr = '${twoDaysAgo.year}-${twoDaysAgo.month.toString().padLeft(2, '0')}-${twoDaysAgo.day.toString().padLeft(2, '0')}';
    });

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
        checkedDates: [todayStr],
        dailyGoal: 2,
        targetDays: 30,
        checkCounts: {todayStr: 2},
      );

      final json = habit.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Exercise');
      expect(json['checkedDates'], [todayStr]);
      expect(json['dailyGoal'], 2);
      expect(json['targetDays'], 30);
      expect(json['checkCounts'], {todayStr: 2});
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': '1',
        'name': 'Exercise',
        'checkedDates': [todayStr],
        'dailyGoal': 2,
        'targetDays': 30,
        'checkCounts': {todayStr: 2},
      };

      final habit = Habit.fromJson(json);

      expect(habit.id, '1');
      expect(habit.name, 'Exercise');
      expect(habit.checkedDates, [todayStr]);
      expect(habit.dailyGoal, 2);
      expect(habit.targetDays, 30);
      expect(habit.checkCounts, {todayStr: 2});
    });

    test('should return 0 streak for empty checkedDates', () {
      final habit = Habit(id: '1', name: 'Exercise', checkedDates: []);
      expect(habit.getStreakDays(), 0);
    });

    test('should calculate streak correctly for consecutive days', () {
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        checkedDates: [todayStr, yesterdayStr, twoDaysAgoStr],
      );
      expect(habit.getStreakDays(), 3);
    });

    test('should return today check count', () {
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        checkedDates: [],
        checkCounts: {todayStr: 3},
      );
      expect(habit.getTodayCheckCount(), 3);
    });

    test('should return true when checked today', () {
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        checkedDates: [todayStr],
        checkCounts: {todayStr: 1},
      );
      expect(habit.isCheckedToday(), true);
    });
  });
}
