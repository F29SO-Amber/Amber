import 'package:amber/Screens/extra.dart';
import 'package:amber/Screens/chats.dart';
import 'package:flutter/material.dart';

class ChatNav extends StatefulWidget {
  @override
  _ChatNavState createState() => _ChatNavState();
}

class _ChatNavState extends State<ChatNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return const ChatsPage();
                case '/chat2':
                  return const ExtraPage(pageName: 'From Chat Page');
              }
              return const ChatsPage();
            });
      },
    );
  }
}