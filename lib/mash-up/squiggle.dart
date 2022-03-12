import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'squiggle.g.dart';

@JsonSerializable(anyMap: true)
class Squiggle {
  final double dx;
  final double dy;
  // final Offset point;
  final double strokeWidth;
  final int color;

  Squiggle({required this.dx, required this.dy, required this.strokeWidth, required this.color});

  factory Squiggle.fromJson(Map<String, dynamic> json) => _$SquiggleFromJson(json);

  Map<String, dynamic> toJson() => _$SquiggleToJson(this);

  // Map<String, dynamic> toJson() => {
  //       'x': point.dx,
  //       'y': point.dy,
  //       'color': color,
  //       'strokeWidth': strokeWidth,
  //     };
  //
  // Squiggle? fromJson(Map<String, dynamic> json) {
  //   return json == {}
  //       ? null
  //       : Squiggle(
  //           point: Offset(json['x'], json['y']),
  //           strokeWidth: json['strokeWidth'],
  //           color: json['color']);
  // }
}
