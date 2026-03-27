import 'subtask.dart';

enum TaskStatus {
  notStarted,
  inProgress,
  completed,
}

class Task {
  final String id;
  final String name;
  final DateTime deadline;
  final TaskStatus status;
  final List<Subtask> subtasks;

  Task({
    required this.id,
    required this.name,
    required this.deadline,
    this.status = TaskStatus.notStarted,
    List<Subtask>? subtasks,
  }) : subtasks = subtasks ?? [];

  int getTotalMinutes() {
    return subtasks.fold(0, (sum, st) => sum + st.getTotalMinutes());
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      deadline: DateTime.parse(json['deadline']),
      status: TaskStatus.values[json['status']],
      subtasks: (json['subtasks'] as List)
          .map((s) => Subtask.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'deadline': deadline.toIso8601String(),
      'status': status.index,
      'subtasks': subtasks.map((s) => s.toJson()).toList(),
    };
  }

  Task copyWith({
    String? id,
    String? name,
    DateTime? deadline,
    TaskStatus? status,
    List<Subtask>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}

