import 'package:amber/Screens/chats.dart';
import 'package:amber/Screens/chats_nav.dart';
import 'package:amber/Screens/discover.dart';
import 'package:amber/Screens/discover_navigator.dart';
import 'package:amber/Screens/home.dart';
import 'package:amber/Screens/post.dart';
import 'package:amber/Screens/post_navigator.dart';
import 'package:amber/Screens/profile.dart';
import 'package:amber/Screens/profile_nav.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page_navigator.dart';

class ConvexAppBarDemo extends StatefulWidget {
  const ConvexAppBarDemo({Key? key}) : super(key: key);
  static const id = '/navbar';

  @override
  _ConvexAppBarDemoState createState() => _ConvexAppBarDemoState();
}

class _ConvexAppBarDemoState extends State<ConvexAppBarDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    chatsNavigatorKey,
    discoverNavigatorKey,
    homePageNavigatorKey,
    postNavigatorKey,
    profileNavigatorKey,
  ];

  Future<bool> _systemBackButtonPressed() {
    if (_navigatorKeys[_selectedIndex].currentState!.canPop()) {
      _navigatorKeys[_selectedIndex]
          .currentState!
          .pop(_navigatorKeys[_selectedIndex].currentContext);
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
    throw '';
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Scaffold(
            appBar: AppBar(
              title: const Text('ConvexAppBar'),
              backgroundColor: Colors.amber,
            ),
            body: SafeArea(
              top: false,
              child: IndexedStack(
                index: _selectedIndex,
                children: <Widget>[
                  HomePageNavigator(),
                  DiscoverPageNavigator(),
                  PostPageNav(),
                  ChatNav(),
                  ProfilePageNavigator(),
                ],
              ),
            ),
            bottomNavigationBar: ConvexAppBar(
              items: const [
                TabItem<IconData>(icon: Icons.home, title: 'Home'),
                TabItem<IconData>(icon: Icons.map, title: "Discovery"),
                TabItem<IconData>(icon: Icons.publish, title: "Publish"),
                TabItem<IconData>(icon: Icons.message, title: 'Message'),
                TabItem<IconData>(icon: Icons.people, title: 'Profile'),
              ],
              // height: 50,
              // top: -25,
              style: TabStyle.react,
              curve: Curves.bounceInOut,
              backgroundColor: Colors.amber,
              gradient: null,
              controller: _tabController,
              onTap: (int i) => setState(() {
                _selectedIndex = i;
              }),
            ),
          ),
        ),
        onWillPop: _systemBackButtonPressed);
  }
}
