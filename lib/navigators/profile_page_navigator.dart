import 'package:flutter/material.dart';

import 'package:amber/screens/extra.dart';
import 'package:amber/screens/login.dart';
import 'package:amber/screens/profile_screen/profile.dart';
import 'package:amber/services/authentication.dart';

class ProfilePageNavigator extends StatefulWidget {
  const ProfilePageNavigator({Key? key}) : super(key: key);

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
                return ProfilePage(
                  profileID: Authentication.currentUser.uid,
                );
              case '/home2':
                return const ExtraPage(pageName: 'From Profile Page');
              case LoginScreen.id:
                return const LoginScreen();
              default:
                return ProfilePage(
                  profileID: Authentication.currentUser.uid,
                );
            }
          },
        );
      },
    );
  }
}
