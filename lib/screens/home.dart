import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:amber/navigators/home_page_navigator.dart';
import 'package:amber/navigators/chats_page_navigator.dart';
import 'package:amber/navigators/publish_page_navigator.dart';
import 'package:amber/navigators/profile_page_navigator.dart';
import 'package:amber/navigators/discover_page_navigator.dart';

class HomePage extends StatefulWidget {
  static const id = '/main_screen';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    homePageNavigatorKey,
    discoverNavigatorKey,
    postNavigatorKey,
    chatsNavigatorKey,
    profileNavigatorKey,
  ];

  Future<bool> _systemBackButtonPressed() async {
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
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
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
          initialActiveIndex: _selectedIndex,
          curve: Curves.bounceInOut,
          backgroundColor: Colors.amber,
          controller: _tabController,
          onTap: (int i) => setState(() => _selectedIndex = i),
        ),
      ),
      onWillPop: _systemBackButtonPressed,
    );
  }
}
