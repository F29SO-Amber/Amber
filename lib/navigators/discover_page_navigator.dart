import 'package:amber/screens/discover/discover_articles.dart';
import 'package:amber/screens/discover/discover_communities.dart';
import 'package:amber/screens/discover/discover_events.dart';
import 'package:amber/screens/discover/discover_hashtags.dart';
import 'package:amber/screens/discover/discover_images.dart';
import 'package:amber/screens/discover/discover_public_groups.dart';
import 'package:amber/screens/discover/discover_thumbnails.dart';
import 'package:flutter/material.dart';
import 'package:amber/screens/discover/discover.dart';

import '../pages/error.dart';

class DiscoverPageNavigator extends StatefulWidget {
  const DiscoverPageNavigator({Key? key}) : super(key: key);

  @override
  _DiscoverPageNavigatorState createState() => _DiscoverPageNavigatorState();
}

GlobalKey<NavigatorState> discoverNavigatorKey = GlobalKey<NavigatorState>();

class _DiscoverPageNavigatorState extends State<DiscoverPageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: discoverNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (_) {
              switch (settings.name) {
                case '/':
                  return const DiscoverPage();
                case DiscoverImages.id:
                  return const DiscoverImages();
                case DiscoverArticles.id:
                  return const DiscoverArticles();
                case DiscoverThumbnails.id:
                  return const DiscoverThumbnails();
                case DiscoverCommunities.id:
                  return const DiscoverCommunities();
                case DiscoverEvents.id:
                  return const DiscoverEvents();
                case DiscoverPublicGroups.id:
                  return const DiscoverPublicGroups();
                default:
                  return const ErrorScreen();
              }
            });
      },
    );
  }
}
