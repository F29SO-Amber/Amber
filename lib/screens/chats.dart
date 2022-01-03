import 'package:flutter/material.dart';
import 'package:amber/constants.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);
  static const id = '/chats';

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: createRandomColor(),
        body: Center(
          child: ElevatedButton(
            child: const Text('Chat'),
            onPressed: () {
              Navigator.pushNamed(context, '/chat2');
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
