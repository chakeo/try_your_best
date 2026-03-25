class TimeSession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  TimeSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  factory TimeSession.fromJson(Map<String, dynamic> json) {
    return TimeSession(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      durationMinutes: json['durationMinutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
    };
  }
}
