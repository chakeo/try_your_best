import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onStart;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final progress = task.getProgress();
    final totalHours = (task.getTotalMinutes() / 60).toStringAsFixed(1);
    final targetHours = (task.targetMinutes / 60).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress > 1.0 ? 1.0 : progress,
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$totalHours / $targetHours 小时',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '截止: ${DateFormat('MM-dd').format(task.deadline)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  ElevatedButton(
                    onPressed: task.status == TaskStatus.active ? onStart : null,
                    child: const Text('开始'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    String label;
    Color color;

    switch (task.status) {
      case TaskStatus.active:
        label = '进行中';
        color = Colors.blue;
        break;
      case TaskStatus.completed:
        label = '已完成';
        color = Colors.green;
        break;
      case TaskStatus.abandoned:
        label = '已放弃';
        color = Colors.grey;
        break;
    }

    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}

