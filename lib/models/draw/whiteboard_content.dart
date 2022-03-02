import 'package:json_annotation/json_annotation.dart';

import 'package:amber/models/draw/line.dart';

part 'whiteboard_content.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class WhiteboardContent {
  WhiteboardContent(this.id, this.lines);

  factory WhiteboardContent.fromJson(Map json) => _$WhiteboardContentFromJson(json);

  final String id;
  final List<Line> lines;

  Map<String, dynamic> toJson() => _$WhiteboardContentToJson(this);
}
