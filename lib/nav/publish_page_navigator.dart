import 'package:flutter/material.dart';

import 'package:amber/screens/extra.dart';
import 'package:amber/screens/post.dart';

class PostPageNav extends StatefulWidget {
  const PostPageNav({Key? key}) : super(key: key);

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
              default:
                return const PostPage();
            }
          },
        );
      },
    );
  }
}
