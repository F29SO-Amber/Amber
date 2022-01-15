import 'package:flutter/material.dart';

import 'package:amber/screens/extra.dart';
import 'package:amber/screens/chats.dart';
import 'package:amber/screens/chat.dart';

class ChatPageNavigator extends StatefulWidget {
  const ChatPageNavigator({Key? key}) : super(key: key);

  @override
  _ChatPageNavigatorState createState() => _ChatPageNavigatorState();
}

GlobalKey<NavigatorState> chatNavigatorKey = GlobalKey<NavigatorState>();

class _ChatPageNavigatorState extends State<ChatPageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: chatNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return const ChatsPage();
              case '/chat2':
                return const ExtraPage(pageName: 'From Chat Page');
              default:
                return const ChatPage();
            }
          },
        );
      },
    );
  }
}