// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'squiggle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Squiggle _$SquiggleFromJson(Map json) => Squiggle(
      dx: (json['dx'] as num).toDouble(),
      dy: (json['dy'] as num).toDouble(),
      strokeWidth: (json['strokeWidth'] as num).toDouble(),
      color: json['color'] as int,
    );

Map<String, dynamic> _$SquiggleToJson(Squiggle instance) => <String, dynamic>{
      'dx': instance.dx,
      'dy': instance.dy,
      'strokeWidth': instance.strokeWidth,
      'color': instance.color,
    };
