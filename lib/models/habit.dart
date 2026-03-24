class Habit {
  final String id;
  final String name;
  final List<String> checkedDates;
  final int dailyGoal;
  final int targetDays;
  final Map<String, int> checkCounts;

  Habit({
    required this.id,
    required this.name,
    required this.checkedDates,
    this.dailyGoal = 1,
    this.targetDays = 21,
    Map<String, int>? checkCounts,
  }) : checkCounts = checkCounts ?? {};

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      checkedDates: List<String>.from(json['checkedDates']),
      dailyGoal: json['dailyGoal'] ?? 1,
      targetDays: json['targetDays'] ?? 21,
      checkCounts: json['checkCounts'] != null
          ? Map<String, int>.from(json['checkCounts'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'checkedDates': checkedDates,
      'dailyGoal': dailyGoal,
      'targetDays': targetDays,
      'checkCounts': checkCounts,
    };
  }

  int getStreakDays() {
    if (checkedDates.isEmpty) return 0;

    final sortedDates = checkedDates.map((d) => DateTime.parse(d)).toList()
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayStr = DateTime(today.year, today.month, today.day);

    int streak = 0;
    DateTime checkDate = todayStr;

    for (var date in sortedDates) {
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (dateOnly == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (dateOnly.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }

  int getTodayCheckCount() {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return checkCounts[todayStr] ?? 0;
  }

  bool isCheckedToday() {
    return getTodayCheckCount() > 0;
  }
}
