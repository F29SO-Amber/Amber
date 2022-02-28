// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whiteboard_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhiteboardContent _$WhiteboardContentFromJson(Map json) => WhiteboardContent(
      json['id'] as String,
      (json['lines'] as List<dynamic>)
          .map((e) => Line.fromJson(e as Map))
          .toList(),
    );

Map<String, dynamic> _$WhiteboardContentToJson(WhiteboardContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lines': instance.lines.map((e) => e.toJson()).toList(),
    };
