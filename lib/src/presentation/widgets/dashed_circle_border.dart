import 'dart:math';
import 'package:flutter/material.dart';

class DashedCircleBorder extends StatelessWidget {
  final Widget child;
  final double size;
  final Color borderColor;
  final double strokeWidth;

  const DashedCircleBorder({
    super.key,
    required this.child,
    required this.size,
    this.borderColor = Colors.grey,
    this.strokeWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCirclePainter(
        color: borderColor,
        strokeWidth: strokeWidth,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(child: child),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DashedCirclePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final radius = size.width / 2 - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Рисуем пунктирную окружность: чередуем дуги и пропуски
    const dashLength = 6.0;  // длина штриха
    const gapLength = 4.0;   // длина пропуска
    final circumference = 2 * pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).ceil();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashLength + gapLength)) / radius;
      final sweepAngle = dashLength / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}