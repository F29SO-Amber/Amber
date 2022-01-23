import 'dart:io';
import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';

class ChatsPage extends StatefulWidget {
  static const id = '/chats';

  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: createRandomColor(),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(kAppName, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: const Center(child: Text('To be implemented!')),
    );
  }
}
