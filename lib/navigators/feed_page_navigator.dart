import 'package:flutter/material.dart';

import 'package:amber/pages/error.dart';
import 'package:amber/screens/feed/feed.dart';
import 'package:amber/pages/mash_up.dart';

class FeedPageNavigator extends StatefulWidget {
  const FeedPageNavigator({Key? key}) : super(key: key);

  @override
  _FeedPageNavigatorState createState() => _FeedPageNavigatorState();
}

GlobalKey<NavigatorState> homePageNavigatorKey = GlobalKey<NavigatorState>();

class _FeedPageNavigatorState extends State<FeedPageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homePageNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            switch (settings.name) {
              case '/':
                return const FeedPage();
              case MashUpScreen.id:
                return const MashUpScreen();
              default:
                return const ErrorScreen();
            }
          },
        );
      },
    );
  }
}
