import 'package:amber/mash-up/squiggle.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'squiggles.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Squiggles extends ChangeNotifier {
  List<Squiggle?>? _squiggles;

  Squiggles(this._squiggles);

  Map<String, dynamic> toJson() => _$SquigglesToJson(this);
  factory Squiggles.fromJson(Map json) => _$SquigglesFromJson(json);

  get getSquiggles {
    return _squiggles;
  }

  set setSquiggles(List<Squiggle?>? lines) {
    _squiggles = lines;
  }

  void addSquiggle(Squiggle? squiggle) {
    _squiggles!.add(squiggle);
    notifyListeners();
  }
}
