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
        canvas.drawLine(points[x]!.point, points[x + 1]!.point, points[x]!.areaPaint);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[x]!.point], points[x]!.areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) => true;
}
