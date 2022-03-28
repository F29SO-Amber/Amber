import 'package:flutter/material.dart';

import 'package:amber/pages/error.dart';
import 'package:amber/pages/settings.dart';
import 'package:amber/screens/auth/login.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/screens/profile/profile.dart';

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
          builder: (_) {
            switch (settings.name) {
              case '/':
                return ProfilePage(userUID: AuthService.currentUser.uid);
              case LoginScreen.id:
                return const LoginScreen();
              case SettingsPage.id:
                return const SettingsPage();
              default:
                return const ErrorScreen();
            }
          },
        );
      },
    );
  }
}
