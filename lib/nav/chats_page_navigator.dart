import 'package:flutter/material.dart';

import 'package:amber/screens/extra.dart';
import 'package:amber/screens/chats.dart';

class ChatNav extends StatefulWidget {
  const ChatNav({Key? key}) : super(key: key);

  @override
  _ChatNavState createState() => _ChatNavState();
}

GlobalKey<NavigatorState> chatsNavigatorKey = GlobalKey<NavigatorState>();

class _ChatNavState extends State<ChatNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: chatsNavigatorKey,
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
                return const ChatsPage();
            }
          },
        );
      },
    );
  }
}
