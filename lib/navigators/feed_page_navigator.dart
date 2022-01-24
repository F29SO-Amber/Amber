import 'package:flutter/material.dart';
import 'package:amber/screens/feed.dart';

//Creating mutable state for the Feed Page Navigator
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
        return MaterialPageRoute(settings: settings, builder: (_) => const FeedPage());
      },
    );
  }
}
