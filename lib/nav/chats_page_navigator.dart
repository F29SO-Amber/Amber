import 'package:flutter/material.dart';

import 'package:amber/screens/extra.dart';
import 'package:amber/screens/chats.dart';

class ChatsPageNavigator extends StatefulWidget {
  const ChatsPageNavigator({Key? key}) : super(key: key);

  @override
  _ChatsPageNavigatorState createState() => _ChatsPageNavigatorState();
}

GlobalKey<NavigatorState> chatsNavigatorKey = GlobalKey<NavigatorState>();

class _ChatsPageNavigatorState extends State<ChatsPageNavigator> {
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
