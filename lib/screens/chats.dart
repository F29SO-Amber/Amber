import 'dart:io';

import 'package:amber/services/auth_service.dart';
import 'package:amber/widgets/post_widget.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amber/screens/post.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);
  static const id = '/chats';

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
        title: const Text(
          kAppName,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const UserPost(),
          GestureDetector(
            child: const Center(child: Text('To be implemented!')),
          ),
        ],
      ),
    );
  }
}
