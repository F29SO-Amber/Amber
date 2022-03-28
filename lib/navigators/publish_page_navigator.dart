import 'package:flutter/material.dart';

import 'package:amber/pages/error.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/screens/create/create.dart';
import 'package:amber/screens/create/publish_event.dart';
import 'package:amber/screens/create/publish_article.dart';
import 'package:amber/screens/create/publish_community.dart';
import 'package:amber/screens/create/publish_image.dart';

import '../screens/create/publish_thumbnail.dart';

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
                return const PublishImageScreen();
              case PublishEventScreen.id:
                return const PublishEventScreen();
              case PublishCommunityScreen.id:
                return const PublishCommunityScreen();
              case PublishArticleScreen.id:
                return const PublishArticleScreen();
              case PublishThumbnailScreen.id:
                return const PublishThumbnailScreen();
              default:
                return const ErrorScreen();
            }
          },
        );
      },
    );
  }
}
