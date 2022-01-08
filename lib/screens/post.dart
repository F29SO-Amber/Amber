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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text(kAppName,
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      backgroundColor: createRandomColor(),
      body: Column(
        children: [],
      ),
    );
  }
}
