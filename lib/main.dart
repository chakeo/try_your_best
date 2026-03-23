import 'package:flutter/material.dart';
import 'models/habit.dart';
import 'services/storage_service.dart';
import 'widgets/add_habit_dialog.dart';
import 'screens/habit_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '习惯打卡',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HabitListScreen(),
    );
  }
}

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
        _habits.add(Habit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result['name'],
          checkedDates: [],
          dailyGoal: result['dailyGoal'],
        ));
      });
      await _saveHabits();
    }
  }

  Future<void> _toggleCheck(int index) async {
    final habit = _habits[index];
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

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
      appBar: AppBar(
        title: const Text('习惯打卡'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _habits.isEmpty
          ? const Center(child: Text('点击 + 添加第一个习惯'))
          : ReorderableListView.builder(
              itemCount: _habits.length,
              onReorder: (oldIndex, newIndex) async {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final habit = _habits.removeAt(oldIndex);
                  _habits.insert(newIndex, habit);
                });
                await _saveHabits();
              },
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return Card(
                  key: ValueKey(habit.id),
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(habit.name),
                    subtitle: Text('连续 ${habit.getStreakDays()} 天'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(habit.dailyGoal, (i) {
                        final checked = i < habit.getTodayCheckCount();
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            checked ? Icons.check_circle : Icons.circle_outlined,
                            color: checked ? Colors.green : Colors.grey,
                            size: 20,
                          ),
                        );
                      })..add(
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _toggleCheck(index),
                          iconSize: 24,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HabitDetailScreen(
                            habit: habit,
                            onDelete: () async {
                              setState(() => _habits.removeAt(index));
                              await _saveHabits();
                            },
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('删除习惯'),
                          content: Text('确定要删除"${habit.name}"吗？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                setState(() => _habits.removeAt(index));
                                await _saveHabits();
                              },
                              child: const Text('删除'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
