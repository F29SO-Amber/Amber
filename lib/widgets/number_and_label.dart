import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';
import 'dart:ui' as ui;

class NumberAndLabel extends StatelessWidget {
  final String number;
  final String label;

  const NumberAndLabel({Key? key, required this.number, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: ui.TextDirection.ltr,
      children: [
        Text(
          number,
          style: kDarkLabelTextStyle,
          textDirection: ui.TextDirection.ltr,
        ),
        Text(
          label,
          style: kLightLabelTextStyle,
          textDirection: ui.TextDirection.ltr,
        ),
      ],
    );
  }
}
