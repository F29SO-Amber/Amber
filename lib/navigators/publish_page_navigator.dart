import 'package:flutter/material.dart';

import 'package:amber/screens/extra.dart';
import 'package:amber/screens/post.dart';

class PublishPageNavigator extends StatefulWidget {
  const PublishPageNavigator({Key? key}) : super(key: key);

  @override
  _PublishPageNavigatorState createState() => _PublishPageNavigatorState();
}

GlobalKey<NavigatorState> postNavigatorKey = GlobalKey<NavigatorState>();

class _PublishPageNavigatorState extends State<PublishPageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: postNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return const PostPage();
              case '/post2':
                return const ExtraPage(pageName: 'From Post Page');
              default:
                return const PostPage();
            }
          },
        );
      },
    );
  }
}
