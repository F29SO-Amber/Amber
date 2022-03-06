import 'package:amber/mash-up/drawn_line.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Sketcher extends CustomPainter {
  final List<DrawnLine?> lines;

  Sketcher({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < lines.length; ++i) {
      if (lines[i] == null) continue;
      for (int j = 0; j < lines[i]!.path.length - 1; ++j) {
        if (lines[i]!.path[j] != null && lines[i]!.path[j + 1] != null) {
          paint.color = lines[i]!.color;
          paint.strokeWidth = lines[i]!.width;
          canvas.drawLine(lines[i]!.path[j], lines[i]!.path[j + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    // return lines != oldDelegate.lines;
    return true;
  }
}

// class ImagePainter extends CustomPainter {
//   ImagePainter({required this.image, required this.pointsList});
//   ui.Image image;
//
//   List<DrawnLine?> pointsList;
//   List<Offset> offsetPoints = [];
//
//   List<Offset> points = [];
//
//   // final Paint painter = new Paint()
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // canvas.drawImage(this.image, Offset(0.0, 0.0), Paint());
//     final imageSize = Size(image.width.toDouble(), image.height.toDouble());
//     final src = Offset.zero & imageSize;
//     final dst = Offset.zero & size;
//     // canvas.pic
//     canvas.drawImageRect(this.image, src, dst, Paint());
//     // for (Offset offset in points) {
//     //   canvas.drawCircle(offset, 10, painter);
//     // }
//     pointsList = pointsList.map((e) {
//       if (e != null) {
//         if (e.points.dy <= dst.height) {
//           return e;
//         }
//       }
//
//       return null;
//     }).toList();
//     for (int i = 0; i < pointsList.length - 1; i++) {
//       if (pointsList[i] != null && pointsList[i + 1] != null) {
//         canvas.drawLine(pointsList[i].points, pointsList[i + 1].points, pointsList[i].paint);
//       } else if (pointsList[i] != null && pointsList[i + 1] == null) {
//         offsetPoints.clear();
//         offsetPoints.add(pointsList[i].points);
//         offsetPoints.add(Offset(pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
//         canvas.drawPoints(ui.PointMode.points, offsetPoints, pointsList[i].paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
