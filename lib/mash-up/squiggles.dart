import 'package:amber/mash-up/squiggle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'squiggles.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Squiggles {
  final List<Squiggle?> squiggles;

  Squiggles(this.squiggles);

  Map<String, dynamic> toJson() => _$SquigglesToJson(this);

  factory Squiggles.fromJson(Map json) => _$SquigglesFromJson(json);
}
