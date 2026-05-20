import 'package:flutter/material.dart';

class AppConstants {
  // Акцентный цвет (фиолетовый)
  static const Color accentColor = Color(0xFFB989FE);

  // Фон кружков дат (светло-фиолетовый)
  static const Color dateCircleColor = Color(0xFFEADAFF);

  // Кружок сегодняшней даты (почти белый)
  static const Color todayCircleColor = Color(0xFFFCFAFF);

  // Фон области задач (светлый)
  static const Color taskBackgroundColor = Color(0xFFFCFAFF);

  // Отступы и радиусы
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double borderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}