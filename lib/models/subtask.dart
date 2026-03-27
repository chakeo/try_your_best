import 'time_session.dart';

class Subtask {
  final String id;
  final String name;
  final String parentTaskId;
  final List<TimeSession> sessions;

  Subtask({
    required this.id,
    required this.name,
    required this.parentTaskId,
    List<TimeSession>? sessions,
  }) : sessions = sessions ?? [];

  int getTotalMinutes() {
    return sessions.fold(0, (sum, s) => sum + s.durationMinutes);
  }

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: json['id'],
      name: json['name'],
      parentTaskId: json['parentTaskId'],
      sessions: (json['sessions'] as List)
          .map((s) => TimeSession.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentTaskId': parentTaskId,
      'sessions': sessions.map((s) => s.toJson()).toList(),
    };
  }

  Subtask copyWith({
    String? id,
    String? name,
    String? parentTaskId,
    List<TimeSession>? sessions,
  }) {
    return Subtask(
      id: id ?? this.id,
      name: name ?? this.name,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      sessions: sessions ?? this.sessions,
    );
  }
}
