import 'package:amber/Screens/extra.dart';
import 'package:amber/Screens/post.dart';
import 'package:flutter/material.dart';

class PostPageNav extends StatefulWidget {
  @override
  _PostPageNavState createState() => _PostPageNavState();
}

GlobalKey<NavigatorState> postNavigatorKey = GlobalKey<NavigatorState>();

class _PostPageNavState extends State<PostPageNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: postNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return const PostPage();
                case '/post2':
                  return const ExtraPage(pageName: 'From Post Page');
              }
              return const PostPage();
            });
      },
    );
  }
}
