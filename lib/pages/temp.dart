import 'package:amber/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatTemp extends StatefulWidget {
  const ChatTemp({Key? key, required this.chatID, required this.chatName}) : super(key: key);

  final String chatID;
  final String chatName;

  static const id = '/chat_temp';

  @override
  _ChatTempState createState() => _ChatTempState();
}

class _ChatTempState extends State<ChatTemp> {
  final List<types.Message> _messages = [];
  final _user = types.User(id: AuthService.currentUser.uid);

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: Colors.amber,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.02),
              child: const CircleAvatar(),
            ),
            const Text(
              'Testing',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('token', whereIn: [
              '${FirebaseAuth.instance.currentUser!.email}|${widget.chatID}',
              '${widget.chatID}|${FirebaseAuth.instance.currentUser!.email}'
            ])
            .orderBy('time2', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
            return SafeArea(
              bottom: false,
              child: Chat(
                messages: _messages,
                onSendPressed: _handleSendPressed,
                user: _user,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
