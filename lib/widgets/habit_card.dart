import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggleCheck;
  final int index;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggleCheck,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(habit.id),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '连续 ${habit.getStreakDays()} 天 | 目标 ${habit.targetDays} 天',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: List.generate(habit.dailyGoal, (i) {
                    final checked = i < habit.getTodayCheckCount();
                    return GestureDetector(
                      onTap: onToggleCheck,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          checked ? Icons.check_circle : Icons.circle_outlined,
                          color: checked ? const Color(0xFF4CAF50) : Colors.grey,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(
                Icons.drag_handle,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
