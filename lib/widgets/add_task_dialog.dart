import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _taskController = TextEditingController();
  final List<String> _subtaskNames = [];
  final _subtaskController = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _taskController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  void _addSubtask() {
    if (_subtaskController.text.trim().isNotEmpty) {
      setState(() {
        _subtaskNames.add(_subtaskController.text.trim());
        _subtaskController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加任务'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(hintText: '大任务名称'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('截止日期：'),
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
              const Divider(),
              const Text('小任务列表', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_subtaskNames.isNotEmpty)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _subtaskNames.length,
                    itemBuilder: (context, index) {
                      final name = _subtaskNames[index];
                      return ListTile(
                        title: Text(name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => setState(() => _subtaskNames.removeAt(index)),
                        ),
                      );
                    },
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subtaskController,
                      decoration: const InputDecoration(hintText: '小任务名称'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addSubtask,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_taskController.text.trim().isNotEmpty) {
              // 自动添加文本框中未提交的子任务
              if (_subtaskController.text.trim().isNotEmpty) {
                _subtaskNames.add(_subtaskController.text.trim());
              }
              Navigator.pop(context, {
                'name': _taskController.text.trim(),
                'deadline': _deadline,
                'subtaskNames': _subtaskNames,
              });
            }
          },
          child: const Text('确认'),
        ),
      ],
    );
  }
}
