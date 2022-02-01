import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatTemp extends StatefulWidget {
  const ChatTemp({Key? key}) : super(key: key);

  @override
  _ChatTempState createState() => _ChatTempState();
}

class _ChatTempState extends State<ChatTemp> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');

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
        backgroundColor: Colors.amber, // top bar color
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
      body: SafeArea(
        bottom: false,
        child: Chat(
          messages: _messages,
          user: _user,
          onSendPressed: _handleSendPressed,
        ),
      ),
    );
  }
}
