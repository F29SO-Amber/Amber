import 'package:amber/screens/publish.dart';
import 'package:amber/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:amber/screens/post.dart';

class PublishPageNavigator extends StatefulWidget {
  const PublishPageNavigator({Key? key}) : super(key: key);

  @override
  _PublishPageNavigatorState createState() => _PublishPageNavigatorState();
}

GlobalKey<NavigatorState> postNavigatorKey = GlobalKey<NavigatorState>();

class _PublishPageNavigatorState extends State<PublishPageNavigator> {
  String currentUserId = AuthService.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: postNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            //switch (settings.name) {
            //case '/':
            //return PostPage(currentUser: Authentication.currentUser);
            // case '/post2':
            //   return const ExtraPage(pageName: 'From Post Page');
            //default:
            // return PostPage(currentUserId: currentUserId);
            return PublishScreen();
          },
        );
      },
    );
  }
}
