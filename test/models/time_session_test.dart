import 'package:flutter_test/flutter_test.dart';
import 'package:try_your_best/models/time_session.dart';

void main() {
  group('TimeSession', () {
    test('creates instance with required fields', () {
      final startTime = DateTime(2026, 3, 28, 10, 0);
      final endTime = DateTime(2026, 3, 28, 10, 30);

      final session = TimeSession(
        id: '1',
        startTime: startTime,
        endTime: endTime,
        durationMinutes: 30,
      );

      expect(session.id, '1');
      expect(session.startTime, startTime);
      expect(session.endTime, endTime);
      expect(session.durationMinutes, 30);
    });

    test('serializes to JSON correctly', () {
      final session = TimeSession(
        id: '1',
        startTime: DateTime(2026, 3, 28, 10, 0),
        endTime: DateTime(2026, 3, 28, 10, 30),
        durationMinutes: 30,
      );

      final json = session.toJson();

      expect(json['id'], '1');
      expect(json['startTime'], '2026-03-28T10:00:00.000');
      expect(json['endTime'], '2026-03-28T10:30:00.000');
      expect(json['durationMinutes'], 30);
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'id': '1',
        'startTime': '2026-03-28T10:00:00.000',
        'endTime': '2026-03-28T10:30:00.000',
        'durationMinutes': 30,
      };

      final session = TimeSession.fromJson(json);

      expect(session.id, '1');
      expect(session.startTime, DateTime(2026, 3, 28, 10, 0));
      expect(session.endTime, DateTime(2026, 3, 28, 10, 30));
      expect(session.durationMinutes, 30);
    });
  });
}
