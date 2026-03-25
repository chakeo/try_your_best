import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _controller = TextEditingController();
  int _targetHours = 5;
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加任务'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: '输入任务名称'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('目标时长：'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _targetHours,
                items: List.generate(20, (i) => i + 1)
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n 小时')))
                    .toList(),
                onChanged: (value) => setState(() => _targetHours = value!),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('截止日期：'),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _deadline = date);
                },
                child: Text('${_deadline.month}-${_deadline.day}'),
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
                'targetHours': _targetHours,
                'deadline': _deadline,
              });
            }
          },
          child: const Text('确认'),
        ),
      ],
    );
  }
}

