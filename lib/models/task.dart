import 'time_session.dart';

enum TaskStatus {
  active,
  completed,
  abandoned,
}

class Task {
  final String id;
  final String name;
  final int targetMinutes;
  final DateTime deadline;
  final TaskStatus status;
  final List<TimeSession> sessions;

  Task({
    required this.id,
    required this.name,
    required this.targetMinutes,
    required this.deadline,
    this.status = TaskStatus.active,
    List<TimeSession>? sessions,
  }) : sessions = sessions ?? [];

  double getProgress() {
    int totalMinutes = getTotalMinutes();
    return totalMinutes / targetMinutes;
  }

  int getTotalMinutes() {
    return sessions.fold(0, (sum, s) => sum + s.durationMinutes);
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      targetMinutes: json['targetMinutes'],
      deadline: DateTime.parse(json['deadline']),
      status: TaskStatus.values[json['status']],
      sessions: (json['sessions'] as List)
          .map((s) => TimeSession.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetMinutes': targetMinutes,
      'deadline': deadline.toIso8601String(),
      'status': status.index,
      'sessions': sessions.map((s) => s.toJson()).toList(),
    };
  }

  Task copyWith({
    String? id,
    String? name,
    int? targetMinutes,
    DateTime? deadline,
    TaskStatus? status,
    List<TimeSession>? sessions,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
    );
  }
}

