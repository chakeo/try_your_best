import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/task.dart';
import 'package:try_your_best/models/subtask.dart';

void main() {
  test('should display multiple subtasks correctly', () {
    final task = Task(
      id: '1',
      name: 'AI2',
      deadline: DateTime(2026, 3, 31),
      subtasks: [
        Subtask(id: '1-0', name: '小任务1', parentTaskId: '1'),
        Subtask(id: '1-1', name: '小任务2', parentTaskId: '1'),
      ],
    );

    expect(task.subtasks.length, 2);
    expect(task.subtasks[0].name, '小任务1');
    expect(task.subtasks[1].name, '小任务2');
  });

  test('should add new subtask to existing task', () {
    final task = Task(
      id: '1',
      name: 'AI2',
      deadline: DateTime(2026, 3, 31),
      subtasks: [
        Subtask(id: '1-0', name: '小任务1', parentTaskId: '1'),
      ],
    );

    final newSubtask = Subtask(id: '1-1', name: '小任务2', parentTaskId: '1');
    final updatedTask = task.copyWith(
      subtasks: [...task.subtasks, newSubtask],
    );

    expect(updatedTask.subtasks.length, 2);
  });

  test('should reorder subtasks', () {
    final task = Task(
      id: '1',
      name: 'AI2',
      deadline: DateTime(2026, 3, 31),
      subtasks: [
        Subtask(id: '1-0', name: '小任务1', parentTaskId: '1'),
        Subtask(id: '1-1', name: '小任务2', parentTaskId: '1'),
      ],
    );

    final reordered = List<Subtask>.from(task.subtasks);
    final item = reordered.removeAt(0);
    reordered.insert(1, item);

    expect(reordered[0].name, '小任务2');
    expect(reordered[1].name, '小任务1');
  });
}
