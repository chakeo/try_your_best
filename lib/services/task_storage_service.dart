import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorageService {
  static const String _key = 'tasks';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      // 如果数据格式不兼容，清除旧数据
      await prefs.remove(_key);
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_key, data);
  }

  Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
