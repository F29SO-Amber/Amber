import 'package:flutter/material.dart';

import 'package:amber/screens/login.dart';
import 'package:amber/services/authentication.dart';
import 'package:amber/screens/profile_screen/profile.dart';

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
                return ProfilePage(profileID: Authentication.currentUser.uid);
              case LoginScreen.id:
                return LoginScreen();
              // case EditProfilePage.id:
              //   return const EditProfilePage();
              default:
                return ProfilePage(profileID: Authentication.currentUser.uid);
            }
          },
        );
      },
    );
  }
}
