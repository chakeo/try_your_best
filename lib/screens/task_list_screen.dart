import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_storage_service.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_card.dart';
import '../widgets/time_distribution_chart.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _storage = TaskStorageService();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _storage.loadTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _addTask() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddTaskDialog(),
    );

    if (result != null) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: result['name'],
        targetMinutes: result['targetHours'] * 60,
        deadline: result['deadline'],
      );

      _tasks.add(task);
      await _storage.saveTasks(_tasks);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务管理')),
      body: _tasks.isEmpty
          ? const Center(child: Text('暂无任务，点击右下角添加'))
          : Column(
              children: [
                TimeDistributionChart(tasks: _tasks),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: task),
                            ),
                          );
                          _loadTasks();
                        },
                        onStart: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: task),
                            ),
                          );
                          _loadTasks();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}


