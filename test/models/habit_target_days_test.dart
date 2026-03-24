import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/habit.dart';

void main() {
  test('Habit has targetDays field with default value 21', () {
    final habit = Habit(
      id: '1',
      name: 'Test',
      checkedDates: [],
    );

    expect(habit.targetDays, 21);
  });

  test('Habit can be created with custom targetDays', () {
    final habit = Habit(
      id: '1',
      name: 'Test',
      checkedDates: [],
      targetDays: 30,
    );

    expect(habit.targetDays, 30);
  });

  test('Habit serializes targetDays to JSON', () {
    final habit = Habit(
      id: '1',
      name: 'Test',
      checkedDates: [],
      targetDays: 30,
    );

    final json = habit.toJson();
    expect(json['targetDays'], 30);
  });

  test('Habit deserializes targetDays from JSON', () {
    final json = {
      'id': '1',
      'name': 'Test',
      'checkedDates': [],
      'targetDays': 30,
    };

    final habit = Habit.fromJson(json);
    expect(habit.targetDays, 30);
  });

  test('Habit uses default targetDays when not in JSON', () {
    final json = {
      'id': '1',
      'name': 'Test',
      'checkedDates': [],
    };

    final habit = Habit.fromJson(json);
    expect(habit.targetDays, 21);
  });
}
