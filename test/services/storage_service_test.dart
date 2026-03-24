import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_best/services/storage_service.dart';
import 'package:try_your_best/models/habit.dart';

void main() {
  group('StorageService', () {
    late StorageService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = StorageService();
    });

    test('should return empty list when no data exists', () async {
      final habits = await service.loadHabits();
      expect(habits, isEmpty);
    });

    test('should save and load habits correctly', () async {
      final habits = [
        Habit(id: '1', name: 'Exercise', checkedDates: []),
        Habit(id: '2', name: 'Reading', checkedDates: ['2026-03-24']),
      ];

      await service.saveHabits(habits);
      final loaded = await service.loadHabits();

      expect(loaded.length, 2);
      expect(loaded[0].id, '1');
      expect(loaded[0].name, 'Exercise');
      expect(loaded[1].id, '2');
      expect(loaded[1].name, 'Reading');
    });

    test('should preserve habit properties when saving and loading', () async {
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        checkedDates: ['2026-03-24', '2026-03-23'],
        dailyGoal: 3,
        targetDays: 30,
        checkCounts: {'2026-03-24': 2},
      );

      await service.saveHabits([habit]);
      final loaded = await service.loadHabits();

      expect(loaded[0].dailyGoal, 3);
      expect(loaded[0].targetDays, 30);
      expect(loaded[0].checkCounts, {'2026-03-24': 2});
    });
  });
}
