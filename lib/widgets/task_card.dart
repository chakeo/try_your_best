import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final totalMinutes = task.getTotalMinutes();
    final completedCount = task.subtasks.where((s) => s.sessions.isNotEmpty).length;
    final totalCount = task.subtasks.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;
    final daysLeft = task.deadline.difference(DateTime.now()).inDays;

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
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: onDelete,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(totalMinutes),
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.calendar_today, size: 16, color: _getDeadlineColor(daysLeft)),
                  const SizedBox(width: 4),
                  Text(
                    _formatDeadline(daysLeft),
                    style: TextStyle(color: _getDeadlineColor(daysLeft), fontSize: 14),
                  ),
                  const Spacer(),
                  if (totalCount > 0)
                    Text(
                      '$completedCount/$totalCount',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                ],
              ),
              if (totalCount > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(_getProgressColor(progress)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int minutes) {
    if (minutes < 60) return '$minutes 分钟';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '$hours 小时 $mins 分钟' : '$hours 小时';
  }

  String _formatDeadline(int daysLeft) {
    if (daysLeft < 0) return '已逾期 ${-daysLeft} 天';
    if (daysLeft == 0) return '今天截止';
    if (daysLeft == 1) return '明天截止';
    return '剩余 $daysLeft 天';
  }

  Color _getDeadlineColor(int daysLeft) {
    if (daysLeft < 0) return Colors.red;
    if (daysLeft <= 1) return Colors.orange;
    if (daysLeft <= 3) return Colors.amber;
    return Colors.grey[600]!;
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.blue;
    return Colors.orange;
  }
}
