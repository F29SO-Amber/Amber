import 'package:amber/authentication.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'dart:math' as math;

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);
  static const id = '/post';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        body: Center(
          child: ElevatedButton(
            child: const Text('Post'),
            onPressed: () { Navigator.pushNamed(context, '/post2');},
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
