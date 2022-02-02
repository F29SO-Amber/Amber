import 'package:amber/pages/publish_community.dart';
import 'package:amber/pages/publish_event.dart';
import 'package:amber/screens/publish.dart';
import 'package:flutter/material.dart';
import 'package:amber/pages/publish_image.dart';
import 'package:amber/services/auth_service.dart';

//Creating mutable state for the Publish Page Navigator
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
          builder: (_) {
            switch (settings.name) {
              case '/':
                return const Publish();
              case PublishImageScreen.id:
                return const PublishImageScreen(mashUpDetails: null);
              case PublishEventScreen.id:
                return const PublishEventScreen();
              case PublishCommunityScreen.id:
                return const PublishCommunityScreen();
              default:
                return const Publish();
            }
          },
        );
      },
    );
  }
}
