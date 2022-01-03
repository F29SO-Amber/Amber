import 'package:amber/Screens/extra.dart';
import 'package:amber/Screens/home.dart';
import 'package:flutter/material.dart';

class HomePageNavigator extends StatefulWidget {
  @override
  _HomePageNavigatorState createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return const HomePage();
                case '/home2':
                  return const ExtraPage(pageName: 'From Home Page');
              }
              return const HomePage();
            });
      },
    );
  }
}
