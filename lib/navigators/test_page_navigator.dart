// import 'package:amber/mash-up/drawing_page.dart';
import 'package:amber/pages/error.dart';
import 'package:flutter/material.dart';
import 'package:amber/screens/testing.dart';

import '../mash-up/drawing_page.dart';

class TestPageNavigator extends StatefulWidget {
  const TestPageNavigator({Key? key}) : super(key: key);

  @override
  _TestPageNavigatorState createState() => _TestPageNavigatorState();
}

GlobalKey<NavigatorState> testPageNavigatorKey = GlobalKey<NavigatorState>();

class _TestPageNavigatorState extends State<TestPageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: testPageNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            switch (settings.name) {
              case '/':
                return DrawingPage();
              default:
                return ErrorScreen();
            }
          },
        );
      },
    );
  }
}
