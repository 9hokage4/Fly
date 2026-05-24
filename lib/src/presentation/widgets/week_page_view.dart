import 'package:flutter/material.dart';
import '../../controller/week_controller.dart';
import 'week_labels_header.dart';
import 'week_dates_row.dart';

class WeekPageView extends StatefulWidget {
  final WeekController weekController;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final Map<DateTime, String> taskStatuses; //  поле для статусов

  const WeekPageView({
    super.key,
    required this.weekController,
    required this.selectedDate,
    required this.onDaySelected,
    required this.taskStatuses, //  сохранено
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
        SizedBox(
          height: 50,
          child: PageView.builder(
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
                todayWeekday: todayWeekday,
              );
            },
          ),
        ),
      ],
    );
  }
}