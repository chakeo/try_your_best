import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_best/services/task_storage_service.dart';
import 'package:try_your_best/models/task.dart';

void main() {
  group('TaskStorageService', () {
    late TaskStorageService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = TaskStorageService();
    });

    test('should return empty list when no data exists', () async {
      final tasks = await service.loadTasks();
      expect(tasks, isEmpty);
    });

    test('should save and load tasks correctly', () async {
      final tasks = [
        Task(
          id: '1',
          name: '学习Flutter',
          targetMinutes: 600,
          deadline: DateTime(2026, 3, 31),
        ),
      ];

      await service.saveTasks(tasks);
      final loaded = await service.loadTasks();

      expect(loaded.length, 1);
      expect(loaded[0].id, '1');
      expect(loaded[0].name, '学习Flutter');
    });
  });
}
