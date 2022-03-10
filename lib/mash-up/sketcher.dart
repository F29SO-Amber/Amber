import 'dart:ui';
import 'squiggle.dart';
import 'package:flutter/material.dart';

class Sketcher extends CustomPainter {
  List<Squiggle?> points;

  Sketcher({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        Paint paint = Paint()
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..color = Color(points[x]!.color)
          ..strokeWidth = points[x]!.strokeWidth;
        canvas.drawLine(Offset(points[x]!.dx, points[x]!.dy),
            Offset(points[x + 1]!.dx, points[x + 1]!.dy), paint);
      } else if (points[x] != null && points[x + 1] == null) {
        Paint paint = Paint()
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..color = Color(points[x]!.color)
          ..strokeWidth = points[x]!.strokeWidth;
        canvas.drawPoints(PointMode.points, [Offset(points[x]!.dx, points[x]!.dy)], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) => true;
}
