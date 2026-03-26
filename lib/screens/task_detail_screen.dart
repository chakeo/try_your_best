import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
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
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _startTimer() async {
    setState(() => _startTime = DateTime.now());
  }

  Future<void> _stopTimer() async {
    if (_startTime == null) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!).inMinutes;

    final session = TimeSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: _startTime!,
      endTime: endTime,
      durationMinutes: duration,
    );

    final updatedTask = _task.copyWith(
      sessions: [..._task.sessions, session],
    );

    final tasks = await _storage.loadTasks();
    final index = tasks.indexWhere((t) => t.id == _task.id);
    tasks[index] = updatedTask;
    await _storage.saveTasks(tasks);

    setState(() {
      _task = updatedTask;
      _startTime = null;
    });
  }

  Future<void> _updateStatus(TaskStatus status) async {
    final updatedTask = _task.copyWith(status: status);
    final tasks = await _storage.loadTasks();
    final index = tasks.indexWhere((t) => t.id == _task.id);
    tasks[index] = updatedTask;
    await _storage.saveTasks(tasks);
    setState(() => _task = updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _task.getProgress();
    final totalMinutes = _task.getTotalMinutes();
    final targetMinutes = _task.targetMinutes;
    final remainingMinutes = targetMinutes - totalMinutes;

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
              const PopupMenuItem(
                value: TaskStatus.abandoned,
                child: Text('标记为放弃'),
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
                    LinearProgressIndicator(
                      value: progress > 1.0 ? 1.0 : progress,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalMinutes / $targetMinutes 分钟 (${(progress * 100).toStringAsFixed(0)}%)',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '剩余: $remainingMinutes 分钟',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _startTime == null ? _startTimer : _stopTimer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: Text(_startTime == null ? '开始任务' : '结束任务'),
              ),
            ),
            if (_startTime != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '计时中...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              '时间记录',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_task.sessions.isEmpty)
              const Center(child: Text('暂无记录'))
            else
              ..._task.sessions.reversed.map((session) {
                final start = DateFormat('HH:mm').format(session.startTime);
                final end = DateFormat('HH:mm').format(session.endTime);
                final date = DateFormat('MM-dd').format(session.startTime);
                return Card(
                  child: ListTile(
                    title: Text('$date $start - $end'),
                    trailing: Text('${session.durationMinutes} 分钟'),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}


