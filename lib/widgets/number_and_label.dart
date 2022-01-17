import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/constants.dart';

class NumberAndLabel extends StatelessWidget {
  const NumberAndLabel({Key? key, required this.number, required this.label}) : super(key: key);

  final String number;
  final String label;

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
