import 'package:amber/screens/auth/login.dart';
import 'package:amber/pages/terms_of_service.dart';
import 'package:amber/pages/error.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  static const id = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      backgroundColor: Colors.amber.shade50,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SettingItem(
                  title: "Saved Posts",
                  leadingIcon: Icons.bookmark_outline,
                  bgIconColor: Colors.blue,
                  onTap: () {
                    // Get.toNamed('/space');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Divider(
                    height: 0,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
                SettingItem(
                  title: "Liked Posts",
                  leadingIcon: Icons.favorite_outline,
                  bgIconColor: Colors.green,
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Divider(
                    height: 0,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                  title: "Notifications and Sounds",
                  leadingIcon: Icons.notifications_on_outlined,
                  bgIconColor: Colors.red,
                  onTap: () {}),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                  title: "Privacy and Security",
                  leadingIcon: Icons.lock_outline,
                  bgIconColor: Colors.grey,
                  onTap: () {}),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                  title: "App Appearance",
                  leadingIcon: Icons.dark_mode_outlined,
                  bgIconColor: Colors.lightBlue,
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ErrorScreen()),
                    );
                  }),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Terms of Service",
                leadingIcon: Icons.rule,
                bgIconColor: Colors.amberAccent,
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const TermsofService()),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Log Out",
                leadingIcon: Icons.logout_outlined,
                bgIconColor: Colors.grey.shade400,
                onTap: () async {
                  AuthService.signOutUser();
                  await Hive.openBox('user');
                  Hive.box('user').put('status', 'logged-out');
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
