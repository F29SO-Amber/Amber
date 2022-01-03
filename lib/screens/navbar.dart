import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:amber/nav/chats_page_navigator.dart';
import 'package:amber/nav/discover_page_navigator.dart';
import 'package:amber/nav/publish_page_navigator.dart';
import 'package:amber/nav/profile_page_navigator.dart';
import 'package:amber/nav/home_page_navigator.dart';

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
    homePageNavigatorKey,
    discoverNavigatorKey,
    postNavigatorKey,
    chatsNavigatorKey,
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
          appBar: AppBar(
            title: const Text('ConvexAppBar'),
            backgroundColor: Colors.amber,
          ),
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: _selectedIndex,
              children: const <Widget>[
                HomePageNavigator(),
                DiscoverPageNavigator(),
                PublishPageNavigator(),
                ChatsPageNavigator(),
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
        onWillPop: _systemBackButtonPressed);
  }
}
