import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../services/task_storage_service.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _storage = TaskStorageService();
  List<Task> _tasks = [];
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _storage.loadTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _deleteTask(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除任务"${task.name}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _tasks.removeWhere((t) => t.id == task.id);
      await _storage.saveTasks(_tasks);
      setState(() {});
    }
  }

  Future<void> _addTask() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddTaskDialog(),
    );

    if (result != null) {
      final taskId = DateTime.now().millisecondsSinceEpoch.toString();
      final subtasks = (result['subtaskNames'] as List<String>)
          .asMap()
          .entries
          .map((entry) => Subtask(
                id: '$taskId-${entry.key}',
                name: entry.value,
                parentTaskId: taskId,
              ))
          .toList();

      final task = Task(
        id: taskId,
        name: result['name'],
        deadline: result['deadline'],
        subtasks: subtasks,
      );

      _tasks.add(task);
      await _storage.saveTasks(_tasks);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final inProgress = _tasks.where((t) => t.status == TaskStatus.inProgress).toList();
    final notStarted = _tasks.where((t) => t.status == TaskStatus.notStarted).toList();
    final completed = _tasks.where((t) => t.status == TaskStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('任务管理'),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _showCompleted = !_showCompleted),
            icon: Icon(_showCompleted ? Icons.visibility_off : Icons.visibility),
            label: Text(_showCompleted ? '隐藏已完成' : '显示已完成'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('暂无任务，点击右下角添加'))
          : ListView(
              children: [
                if (inProgress.isNotEmpty) _buildSection('进行中', inProgress, Colors.blue),
                if (notStarted.isNotEmpty) _buildSection('未开始', notStarted, Colors.grey),
                if (_showCompleted && completed.isNotEmpty) _buildSection('已完成', completed, Colors.green),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addTask',
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection(String title, List<Task> tasks, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                color: color,
                margin: const EdgeInsets.only(right: 8),
              ),
              Text(
                '$title (${tasks.length})',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
        ...tasks.map((task) => TaskCard(
              task: task,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
                );
                _loadTasks();
              },
              onDelete: () => _deleteTask(task),
            )),
      ],
    );
  }
}
