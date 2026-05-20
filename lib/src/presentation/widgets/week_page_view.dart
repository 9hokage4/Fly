import 'package:flutter/material.dart';
import '../../controller/week_controller.dart';
import '../../entity/week.dart';
import 'week_row.dart';

class WeekPageView extends StatefulWidget {
  final WeekController weekController;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const WeekPageView({
    super.key,
    required this.weekController,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  State<WeekPageView> createState() => _WeekPageViewState();
}

class _WeekPageViewState extends State<WeekPageView> {
  late PageController _pageController;
  int _currentPage = 1; // 0 = прошлая, 1 = текущая (по offset), 2 = следующая

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    widget.weekController.addListener(_syncFromController);
  }

  @override
  void dispose() {
    widget.weekController.removeListener(_syncFromController);
    _pageController.dispose();
    super.dispose();
  }

  void _syncFromController() {
    // Когда контроллер меняет неделю программно, перелистываем PageView
    final newOffset = widget.weekController.weekOffset;
    final targetPage = newOffset + 1; // offset -1 -> page 0, offset 0 -> page 1, etc.
    if (_currentPage != targetPage) {
      _pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage = targetPage);
    }
  }

  void _onPageChanged(int page) {
    if (page == _currentPage) return;
    final offsetDelta = page - 1; // page 0 -> -1, page 1 -> 0, page 2 -> +1
    widget.weekController.setWeekOffset(offsetDelta);
    setState(() => _currentPage = page);
  }

  Week _weekForOffset(int offset) {
    // Передаём offset относительно базовой недели контроллера
    // Используем метод, который даст неделю для заданного смещения.
    final currentOffset = widget.weekController.weekOffset;
    final diff = offset - currentOffset;
    final base = widget.weekController.currentWeek;
    if (diff == 0) return base;
    return Week(base.startMonday.add(Duration(days: 7 * diff)));
  }

  @override
  Widget build(BuildContext context) {
    final currentOffset = widget.weekController.weekOffset;

    return SizedBox(
      height: 80, // примерно высота строки недели
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: 3,
        itemBuilder: (context, index) {
          final offset = index - 1; // -1, 0, 1 относительно currentOffset
          final week = _weekForOffset(currentOffset + offset);
          return WeekRow(
            week: week,
            selectedDate: widget.selectedDate,
            onDaySelected: widget.onDaySelected,
          );
        },
      ),
    );
  }
}