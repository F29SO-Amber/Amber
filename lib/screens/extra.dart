import 'package:flutter/material.dart';

import 'package:amber/constants.dart';

class ExtraPage extends StatelessWidget {
  const ExtraPage({Key? key, required this.pageName}) : super(key: key);
  static const id = '/extra';
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: createRandomColor(),
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
    );
  }
}
