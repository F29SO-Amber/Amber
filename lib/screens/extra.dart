import 'package:flutter/material.dart';
import 'dart:math' as math;

class ExtraPage extends StatelessWidget {
  const ExtraPage({Key? key, required this.pageName}) : super(key: key);
  static const id = '/extra';
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        body: Center(
          child: ElevatedButton(
            child: Text(pageName),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.amber, // background
              onPrimary: Colors.black, // foreground
            ),
          ),
        ),
      ),
    );
  }
}
