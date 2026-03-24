import 'package:flutter/material.dart';
import 'package:lunar/lunar.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lunar = Lunar.fromDate(now);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('新的一天', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${now.year}年${now.month}月${now.day}日', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          const Text('加油哟', style: TextStyle(fontSize: 16)),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('农历${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
