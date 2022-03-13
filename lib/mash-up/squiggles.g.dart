// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'squiggles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Squiggles _$SquigglesFromJson(Map json) => Squiggles(
      (json['squiggles'] as List<dynamic>)
          .map((e) => e == null ? null : Squiggle.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$SquigglesToJson(Squiggles instance) => <String, dynamic>{
      'squiggles': instance._squiggles!.map((e) => e?.toJson()).toList(),
    };
