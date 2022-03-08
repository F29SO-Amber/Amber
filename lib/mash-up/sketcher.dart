import 'dart:ui';
import 'drawing_area.dart';
import 'package:flutter/material.dart';

class Sketcher extends CustomPainter {
  List<DrawingArea?> points;

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
        canvas.drawLine(points[x]!.point, points[x + 1]!.point, paint);
      } else if (points[x] != null && points[x + 1] == null) {
        Paint paint = Paint()
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..color = Color(points[x]!.color)
          ..strokeWidth = points[x]!.strokeWidth;
        canvas.drawPoints(PointMode.points, [points[x]!.point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) => true;
}
