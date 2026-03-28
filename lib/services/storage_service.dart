import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class StorageService {
  static const String _key = 'habits';

  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((json) => Habit.fromJson(json)).toList();
    } catch (e) {
      await prefs.remove(_key);
      return [];
    }
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_key, data);
  }
}
