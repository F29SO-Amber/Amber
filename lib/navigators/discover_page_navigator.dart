import 'package:flutter/material.dart';

import 'package:amber/screens/extra.dart';
import 'package:amber/screens/discover.dart';

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
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return const DiscoverPage();
              case '/discover2':
                return const ExtraPage(pageName: 'From Discover Page');
              default:
                return const DiscoverPage();
            }
          },
        );
      },
    );
  }
}
