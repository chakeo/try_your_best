import 'package:flutter/material.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _controller = TextEditingController();
  int _dailyGoal = 1;
  int _targetDays = 21;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加习惯'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: '输入习惯名称'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('每日目标：'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _dailyGoal,
                items: List.generate(10, (i) => i + 1)
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n 次')))
                    .toList(),
                onChanged: (value) => setState(() => _dailyGoal = value!),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('目标天数：'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _targetDays,
                items: [7, 14, 21, 30, 60, 90, 100]
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n 天')))
                    .toList(),
                onChanged: (value) => setState(() => _targetDays = value!),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              Navigator.pop(context, {
                'name': _controller.text.trim(),
                'dailyGoal': _dailyGoal,
                'targetDays': _targetDays,
              });
            }
          },
          child: const Text('确认'),
        ),
      ],
    );
  }
}
