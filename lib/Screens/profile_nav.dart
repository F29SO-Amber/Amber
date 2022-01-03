import 'package:amber/Screens/extra.dart';
import 'package:amber/Screens/profile.dart';
import 'package:flutter/material.dart';

class ProfilePageNavigator extends StatefulWidget {
  @override
  _ProfilePageNavigatorState createState() => _ProfilePageNavigatorState();
}

GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey<NavigatorState>();

class _ProfilePageNavigatorState extends State<ProfilePageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: profileNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return const ProfilePage();
                case '/home2':
                  return const ExtraPage(pageName: 'From Profile Page');
              }
              return const ProfilePage();
            });
      },
    );
  }
}
