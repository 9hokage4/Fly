import 'package:flutter/material.dart';
import '../../controller/week_controller.dart';
import 'week_labels_header.dart';
import 'week_dates_row.dart';

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
  int _currentPage = 1;

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
    final targetPage = widget.weekController.weekOffset + 1; // 1 при сбросе
    if (_currentPage != targetPage) {
      // Если разница больше чем на 1 страницу, мгновенно переходим без анимации
      if ((_currentPage - targetPage).abs() > 1) {
        _pageController.jumpToPage(targetPage);
      } else {
        _pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      setState(() => _currentPage = targetPage);
    }
  }

  void _onPageChanged(int page) {
    if (page == _currentPage) return;
    final offset = page - 1;
    widget.weekController.setWeekOffset(offset);
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentWeek = widget.weekController.weekOffset == 0;
    final todayWeekday = DateTime.now().weekday; // 1..7

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeekLabelsHeader(
          isCurrentWeek: widget.weekController.weekOffset == 0,
          todayWeekday: todayWeekday,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = constraints.maxWidth / 7;
            return SizedBox(
              height: 50,
              child: Stack(
                children: [
                  // Статичный кружок на фиксированной позиции
                  Positioned(
                    left: (todayWeekday - 1) * cellWidth,
                    width: cellWidth,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrentWeek ? Colors.grey : Colors.white,
                          border: !isCurrentWeek
                              ? Border.all(color: Colors.grey.shade300)
                              : null,
                        ),
                      ),
                    ),
                  ),
                  // Анимированные даты поверх кружка
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final offset = index - 1 + widget.weekController.weekOffset;
                      final week = widget.weekController.getWeekAtOffset(offset);
                      return WeekDatesRow(
                        week: week,
                        selectedDate: widget.selectedDate,
                        onDaySelected: widget.onDaySelected,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}