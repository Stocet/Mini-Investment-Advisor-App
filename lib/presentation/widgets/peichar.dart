import 'dart:math';

import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  final Map<String, double> percentages;

  PieChartPainter({required this.percentages});

  @override
  void paint(Canvas canvas, Size size) {
    final double total = percentages.values.fold(0, (sum, item) => sum + item);
    final double radius = min(size.width, size.height) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Paint stockPaint = Paint()..color = Colors.green;
    final Paint bondPaint = Paint()..color = Colors.blue;
    final Paint cashPaint = Paint()..color = Colors.yellow;

    double startAngle = -pi / 2;
    final double sweepAngleStock = 2 * pi * (percentages['stock']! / total);
    final double sweepAngleBond = 2 * pi * (percentages['bond']! / total);
    final double sweepAngleCash = 2 * pi * (percentages['cash']! / total);

    // Draw the stock slice
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleStock,
      true,
      stockPaint,
    );
    startAngle += sweepAngleStock;

    // Draw the bond slice
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleBond,
      true,
      bondPaint,
    );
    startAngle += sweepAngleBond;

    // Draw the cash slice
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleCash,
      true,
      cashPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
