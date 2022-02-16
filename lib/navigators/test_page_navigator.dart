import 'package:amber/mash-up/collage.dart';
import 'package:amber/mash-up/crop.dart';
import 'package:amber/mash-up/draw.dart';
import 'package:flutter/material.dart';
import 'package:amber/screens/testing.dart';

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
                return const Testing();
              case Collage.id:
                return const Collage();
              case Crop.id:
                return const Crop();
              case Draw.id:
                return const Draw();
              default:
                return const Testing();
            }
          },
        );
      },
    );
  }
}