import 'package:amber/authentication.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'dart:math' as math;

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);
  static const id = '/discover';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        body: Center(
          child: ElevatedButton(
            child: const Text('Discover'),
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
