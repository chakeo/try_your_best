import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/task.dart';

class TimeDistributionChart extends StatelessWidget {
  final List<Task> tasks;

  const TimeDistributionChart({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final todayData = _getTodayData();

    if (todayData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('今日暂无任务记录')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今日时间分布',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _PieChartPainter(todayData),
                child: Container(),
              ),
            ),
            const SizedBox(height: 16),
            ..._buildLegend(todayData),
          ],
        ),
      ),
    );
  }

  List<MapEntry<String, int>> _getTodayData() {
    final today = DateTime.now();
    final todayStr = DateTime(today.year, today.month, today.day);

    final Map<String, int> taskMinutes = {};

    for (var task in tasks) {
      int minutes = 0;
      for (var session in task.sessions) {
        final sessionDate = DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        );
        if (sessionDate == todayStr) {
          minutes += session.durationMinutes;
        }
      }
      if (minutes > 0) {
        taskMinutes[task.name] = minutes;
      }
    }

    final sorted = taskMinutes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }

  List<Widget> _buildLegend(List<MapEntry<String, int>> data) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final minutes = item.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: colors[index],
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(item.key)),
            Text('$minutes 分钟', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }).toList();
  }
}

class _PieChartPainter extends CustomPainter {
  final List<MapEntry<String, int>> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final total = data.fold(0, (sum, item) => sum + item.value);

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];

    double startAngle = -math.pi / 2;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}




