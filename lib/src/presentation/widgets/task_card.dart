import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../entity/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final Color backgroundColor;
  final Color markerColor;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.backgroundColor,
    required this.markerColor,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = task.time != null
        ? '${task.time!.hour.toString().padLeft(2, '0')}:${task.time!.minute.toString().padLeft(2, '0')}'
        : '--:--';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // увеличенные отступы
          child: Row(
            children: [
              // Время
              SizedBox(
                width: 56, // немного расширили
                child: Text(
                  timeString,
                  style: const TextStyle(
                    fontSize: 14, // было 12
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Название задачи
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Маркер выполнения
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: markerColor,
                      width: 2,
                    ),
                    color: task.isCompleted ? markerColor : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white) // иконка чуть крупнее
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}