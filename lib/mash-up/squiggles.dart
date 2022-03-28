import 'package:flutter/material.dart';
import 'package:amber/mash-up/squiggle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'squiggles.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Squiggles extends ChangeNotifier {
  List<Squiggle?>? _squiggles;

  Squiggles(this._squiggles);

  get getSquiggles => _squiggles;
  set setSquiggles(List<Squiggle?>? lines) => _squiggles = lines;

  Map<String, dynamic> toJson() => _$SquigglesToJson(this);
  factory Squiggles.fromJson(Map json) => _$SquigglesFromJson(json);

  void addSquiggle(Squiggle? squiggle) {
    _squiggles!.add(squiggle);
    notifyListeners();
  }
}
