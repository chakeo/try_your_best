import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/task.dart';
import 'package:try_your_best/models/subtask.dart';

void main() {
  test('should serialize and deserialize task with multiple subtasks', () {
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

    final json = task.toJson();
    final restored = Task.fromJson(json);

    expect(restored.subtasks.length, 3);
    expect(restored.subtasks[0].name, '小任务1');
    expect(restored.subtasks[1].name, '小任务2');
    expect(restored.subtasks[2].name, '小任务3');
  });
}
