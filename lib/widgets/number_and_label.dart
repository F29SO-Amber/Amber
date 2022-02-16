import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';

class NumberAndLabel extends StatelessWidget {
  final String number;
  final String label;

  const NumberAndLabel({Key? key, required this.number, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(number, style: kDarkLabelTextStyle),
        Text(label, style: kLightLabelTextStyle),
      ],
    );
  }
}
