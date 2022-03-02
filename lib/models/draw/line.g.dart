// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Line _$LineFromJson(Map json) => Line(
      (json['points'] as List<dynamic>)
          .map((e) => Point.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'points': instance.points.map((e) => e.toJson()).toList(),
    };
