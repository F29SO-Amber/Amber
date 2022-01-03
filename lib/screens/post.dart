import 'package:flutter/material.dart';
import 'dart:math' as math;

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);
  static const id = '/post';

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        body: Center(
          child: ElevatedButton(
            child: const Text('Post'),
            onPressed: () {
              Navigator.pushNamed(context, '/post2');
            },
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
