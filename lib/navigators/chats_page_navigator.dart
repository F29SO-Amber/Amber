import 'package:amber/screens/chat/rooms.dart';
import 'package:flutter/material.dart';

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
        return MaterialPageRoute(settings: settings, builder: (_) => const RoomsPage());
      },
    );
  }
}
