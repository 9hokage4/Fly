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
  static const int _centerPage = 1000;
  late PageController _pageController;
  int _currentPage = _centerPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _centerPage);
    widget.weekController.addListener(_syncFromController);
  }

  @override
  void dispose() {
    widget.weekController.removeListener(_syncFromController);
    _pageController.dispose();
    super.dispose();
  }

  void _syncFromController() {
    final targetPage = widget.weekController.weekOffset + _centerPage;
    if (targetPage != _currentPage) {
      // Если прыжок больше чем на 1 неделю — мгновенно, без анимации
      if ((targetPage - _currentPage).abs() > 1) {
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
    if (page != _currentPage) {
      widget.weekController.setWeekOffset(page - _centerPage);
      setState(() => _currentPage = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentWeek = widget.weekController.weekOffset == 0;
    final todayWeekday = DateTime.now().weekday;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeekLabelsHeader(
          isCurrentWeek: isCurrentWeek,
          todayWeekday: todayWeekday,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = constraints.maxWidth / 7;
            return SizedBox(
              height: 50,
              child: Stack(
                children: [
                  // Статичный кружок
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
                  // Бесконечный скролл дат
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: 2001,
                    itemBuilder: (context, index) {
                      final offset = index - _centerPage;
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