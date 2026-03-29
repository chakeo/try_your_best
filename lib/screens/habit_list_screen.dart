import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';
import '../widgets/add_habit_dialog.dart';
import '../widgets/header_widget.dart';
import '../widgets/habit_card.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final _storage = StorageService();
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await _storage.loadHabits();
    setState(() => _habits = habits);
  }

  Future<void> _saveHabits() async {
    await _storage.saveHabits(_habits);
  }

  Future<void> _addHabit() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddHabitDialog(),
    );
    if (result != null) {
      setState(() {
        _habits.add(
          Habit(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: result['name'],
            checkedDates: [],
            dailyGoal: result['dailyGoal'],
            targetDays: result['targetDays'],
          ),
        );
      });
      await _saveHabits();
    }
  }

  Future<void> _toggleCheck(int index) async {
    final habit = _habits[index];
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    setState(() {
      final currentCount = habit.checkCounts[todayStr] ?? 0;
      if (currentCount < habit.dailyGoal) {
        habit.checkCounts[todayStr] = currentCount + 1;
        if (!habit.checkedDates.contains(todayStr)) {
          habit.checkedDates.add(todayStr);
        }
      } else {
        habit.checkCounts.remove(todayStr);
        habit.checkedDates.remove(todayStr);
      }
    });
    await _saveHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(
            child: _habits.isEmpty
                ? const Center(child: Text('点击 + 添加第一个习惯'))
                : ReorderableListView(
                    children: _habits.asMap().entries.map((entry) {
                      final index = entry.key;
                      final habit = entry.value;
                      return HabitCard(
                        key: ValueKey(habit.id),
                        habit: habit,
                        index: index,
                        onToggleCheck: () => _toggleCheck(index),
                      );
                    }).toList(),
                    onReorder: (oldIndex, newIndex) async {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final habit = _habits.removeAt(oldIndex);
                        _habits.insert(newIndex, habit);
                      });
                      await _saveHabits();
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addHabit',
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
