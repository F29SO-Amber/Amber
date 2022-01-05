import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberAndLabel extends StatelessWidget {
  const NumberAndLabel({Key? key, required this.number, required this.label})
      : super(key: key);

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: Colors.black38,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        )
      ],
    );
  }
}
