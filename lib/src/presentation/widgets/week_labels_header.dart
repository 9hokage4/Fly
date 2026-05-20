import 'package:flutter/material.dart';

class WeekLabelsHeader extends StatelessWidget {
  const WeekLabelsHeader({super.key});

  static const List<String> labels = [
    'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (index) {
        return Expanded(
          child: Center(
            child: Text(
              labels[index],
              style: const TextStyle(color: Colors.black, fontSize: 10),
            ),
          ),
        );
      }),
    );
  }
}