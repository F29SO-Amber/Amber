import 'package:flutter/material.dart';
import 'package:amber/constants.dart';

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
        backgroundColor: createRandomColor(),
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
