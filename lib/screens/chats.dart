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
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        elevation: 15.0,
        foregroundColor: Colors.black,
        //backgroundColor: Colors.deepPurpleAccent,
        leading: Text('profile button'),
        title: Text('Amber logo and branding'),
        actions: <Widget>[
        Text('New chat button')
        ],
      ),
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
    );
  }
}
