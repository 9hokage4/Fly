import 'package:flutter/material.dart';
import '../../entity/task.dart';

class TaskDetailDialog extends StatelessWidget {
  final Task task;
  final VoidCallback? onDelete;  // колбэк для удаления

  const TaskDetailDialog({
    super.key,
    required this.task,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = task.time != null
        ? '${task.time!.hour.toString().padLeft(2, '0')}:${task.time!.minute.toString().padLeft(2, '0')}'
        : '--:--';

    return AlertDialog(
      title: Text(task.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Время: $timeString'),
          const SizedBox(height: 8),
          const Text('Описание:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(task.description.isEmpty ? 'Нет описания' : task.description),
        ],
      ),
      actions: [
        if (onDelete != null)
          TextButton(
            onPressed: () {
              onDelete!();         // вызываем удаление
              Navigator.of(context).pop(); // закрываем диалог
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}