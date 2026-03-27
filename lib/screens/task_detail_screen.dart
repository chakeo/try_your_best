import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../models/time_session.dart';
import '../services/task_storage_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _storage = TaskStorageService();
  late Task _task;
  String? _activeSubtaskId;
  DateTime? _startTime;
  final _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  Future<void> _toggleTimer(Subtask subtask) async {
    if (_activeSubtaskId == subtask.id) {
      // 结束计时
      final endTime = DateTime.now();
      final duration = endTime.difference(_startTime!).inMinutes;

      // 如果未达到30分钟，弹出确认对话框
      if (duration < 30) {
        final shouldDiscard = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('提示'),
            content: Text('计时未达到30分钟（当前 $duration 分钟），确定停止吗？停止后将不保留此次记录。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('确定停止'),
              ),
            ],
          ),
        );

        if (shouldDiscard != true) return;

        // 确认停止，不保存记录，直接重置状态
        setState(() {
          _activeSubtaskId = null;
          _startTime = null;
        });
        return;
      }

      // 达到30分钟，正常保存记录
      final session = TimeSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startTime: _startTime!,
        endTime: endTime,
        durationMinutes: duration,
      );

      final updatedSubtask = subtask.copyWith(
        sessions: [...subtask.sessions, session],
      );

      final updatedSubtasks = _task.subtasks.map((st) {
        return st.id == subtask.id ? updatedSubtask : st;
      }).toList();

      final updatedTask = _task.copyWith(
        subtasks: updatedSubtasks,
        status: TaskStatus.inProgress,
      );

      await _saveTask(updatedTask);
      setState(() {
        _task = updatedTask;
        _activeSubtaskId = null;
        _startTime = null;
      });
    } else {
      // 开始计时
      setState(() {
        _activeSubtaskId = subtask.id;
        _startTime = DateTime.now();
      });
    }
  }

  Future<void> _saveTask(Task task) async {
    final tasks = await _storage.loadTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    tasks[index] = task;
    await _storage.saveTasks(tasks);
  }

  Future<void> _updateStatus(TaskStatus status) async {
    final updatedTask = _task.copyWith(status: status);
    await _saveTask(updatedTask);
    setState(() => _task = updatedTask);
  }

  Future<void> _addSubtask() async {
    if (_subtaskController.text.trim().isEmpty) return;

    final newSubtask = Subtask(
      id: '${_task.id}-${_task.subtasks.length}',
      name: _subtaskController.text.trim(),
      parentTaskId: _task.id,
    );

    final updatedTask = _task.copyWith(
      subtasks: [..._task.subtasks, newSubtask],
    );

    await _saveTask(updatedTask);
    setState(() {
      _task = updatedTask;
      _subtaskController.clear();
    });
  }

  void _reorderSubtasks(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final subtasks = List<Subtask>.from(_task.subtasks);
      final item = subtasks.removeAt(oldIndex);
      subtasks.insert(newIndex, item);
      _task = _task.copyWith(subtasks: subtasks);
    });
    _saveTask(_task);
  }

  @override
  Widget build(BuildContext context) {
    final totalMinutes = _task.getTotalMinutes();

    return Scaffold(
      appBar: AppBar(
        title: Text(_task.name),
        actions: [
          PopupMenuButton<TaskStatus>(
            onSelected: _updateStatus,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TaskStatus.completed,
                child: Text('标记为完成'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '总耗时: $totalMinutes 分钟',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDailyChart(),
            const SizedBox(height: 16),
            const Text(
              '小任务列表',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subtaskController,
                    decoration: const InputDecoration(hintText: '添加小任务'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addSubtask,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _task.subtasks.length,
              onReorder: _reorderSubtasks,
              itemBuilder: (context, index) => _buildSubtaskCard(_task.subtasks[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtaskCard(Subtask subtask) {
    final isActive = _activeSubtaskId == subtask.id;
    final minutes = subtask.getTotalMinutes();

    return Card(
      key: ValueKey(subtask.id),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(subtask.name, style: const TextStyle(fontSize: 16))),
                Text('$minutes 分钟', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _toggleTimer(subtask),
              child: Text(isActive ? '结束' : '开始'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChart() {
    final dailyData = _getDailyData();
    if (dailyData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('暂无数据'),
        ),
      );
    }

    final maxMinutes = dailyData.values.reduce((a, b) => a > b ? a : b);
    if (maxMinutes == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('暂无数据'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('每日耗时', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: dailyData.entries.map((entry) {
                  final height = (entry.value / maxMinutes) * 150;
                  return Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${entry.value}分', style: const TextStyle(fontSize: 10)),
                        const SizedBox(height: 4),
                        Container(
                          width: 40,
                          height: height,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 4),
                        Text(entry.key, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _getDailyData() {
    final Map<String, int> dailyMinutes = {};

    for (var subtask in _task.subtasks) {
      for (var session in subtask.sessions) {
        final date = DateFormat('MM-dd').format(session.startTime);
        dailyMinutes[date] = (dailyMinutes[date] ?? 0) + session.durationMinutes;
      }
    }

    final sorted = dailyMinutes.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Map.fromEntries(sorted.take(7));
  }
}
