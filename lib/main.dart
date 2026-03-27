import 'package:flutter/material.dart';
import 'models/habit.dart';
import 'services/storage_service.dart';
import 'widgets/add_habit_dialog.dart';
import 'widgets/header_widget.dart';
import 'screens/task_list_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B8DEE),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HabitListScreen(),
          TaskListScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: '习惯',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: '任务',
          ),
        ],
      ),
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
                                    children: List.generate(habit.dailyGoal, (
                                      i,
                                    ) {
                                      final checked =
                                          i < habit.getTodayCheckCount();
                                      return GestureDetector(
                                        onTap: () => _toggleCheck(index),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4,
                                          ),
                                          child: Icon(
                                            checked
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            color: checked
                                                ? const Color(0xFF4CAF50)
                                                : Colors.grey,
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
