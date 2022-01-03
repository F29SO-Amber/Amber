import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const id = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0),
      body: Center(
        child: ElevatedButton(
          child: const Text('Home'),
          onPressed: () {
            Navigator.pushNamed(context, '/home2');
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.amber, // background
            onPrimary: Colors.black, // foreground
          ),
        ),
      ),
    );
  }
}
