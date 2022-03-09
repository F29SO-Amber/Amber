import 'package:flutter/material.dart';

class DrawingArea {
  final Offset point;
  final double strokeWidth;
  final int color;

  DrawingArea({required this.point, required this.strokeWidth, required this.color});

  Map<String, dynamic> toJson() => {
        'x': point.dx,
        'y': point.dy,
        'color': color,
        'strokeWidth': strokeWidth,
      };

  DrawingArea? fromJson(Map<String, dynamic> json) {
    return json.isEmpty
        ? null
        : DrawingArea(
            point: Offset(json['x'], json['y']),
            strokeWidth: json['strokeWidth'],
            color: json['color']);
  }
}
