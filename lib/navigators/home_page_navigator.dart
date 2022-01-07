import 'package:flutter/material.dart';

import 'package:amber/screens/home.dart';
import 'package:amber/screens/extra.dart';

class HomePageNavigator extends StatefulWidget {
  const HomePageNavigator({Key? key}) : super(key: key);

  @override
  _HomePageNavigatorState createState() => _HomePageNavigatorState();
}

GlobalKey<NavigatorState> homePageNavigatorKey = GlobalKey<NavigatorState>();

class _HomePageNavigatorState extends State<HomePageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homePageNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return const HomePage();
              case '/home2':
                return const ExtraPage(pageName: 'From Home Page');
              default:
                return const HomePage();
            }
          },
        );
      },
    );
  }
}
