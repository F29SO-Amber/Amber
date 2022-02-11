import 'package:amber/pages/publish_community.dart';
import 'package:amber/pages/publish_event.dart';
import 'package:amber/screens/create.dart';
import 'package:flutter/material.dart';
import 'package:amber/pages/publish_image.dart';
import 'package:amber/services/auth_service.dart';

//Creating mutable state for the Publish Page Navigator
class CreatePageNavigator extends StatefulWidget {
  const CreatePageNavigator({Key? key}) : super(key: key);

  @override
  _CreatePageNavigatorState createState() => _CreatePageNavigatorState();
}

GlobalKey<NavigatorState> createNavigatorKey = GlobalKey<NavigatorState>();

class _CreatePageNavigatorState extends State<CreatePageNavigator> {
  String currentUserId = AuthService.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: createNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            switch (settings.name) {
              case '/':
                return const Create();
              case PublishImageScreen.id:
                return const PublishImageScreen(mashUpDetails: null);
              case PublishEventScreen.id:
                return const PublishEventScreen();
              case PublishCommunityScreen.id:
                return const PublishCommunityScreen();
              default:
                return const Create();
            }
          },
        );
      },
    );
  }
}
