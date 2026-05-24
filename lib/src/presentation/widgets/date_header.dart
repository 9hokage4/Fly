import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/settings_model.dart';
import '../../framework/date_formatter.dart';

class DateHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onCalendarTap;
  final VoidCallback onSettingsTap;

  const DateHeader({
    super.key,
    required this.selectedDate,
    required this.onCalendarTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.watch<SettingsModel>().accentColor;

    return Container(
      color: accentColor, // динамический фон
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: onSettingsTap,
          ),
          Expanded(
            child: Text(
              DateFormatter.dayMonth(selectedDate),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: onCalendarTap,
          ),
        ],
      ),
    );
  }
}