import 'package:json_annotation/json_annotation.dart';

part 'squiggle.g.dart';

@JsonSerializable(anyMap: true)
class Squiggle {
  final double dx;
  final double dy;
  final int color;
  final double strokeWidth;

  Squiggle({required this.dx, required this.dy, required this.strokeWidth, required this.color});

  Map<String, dynamic> toJson() => _$SquiggleToJson(this);
  factory Squiggle.fromJson(Map<String, dynamic> json) => _$SquiggleFromJson(json);
}
