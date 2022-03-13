import 'package:amber/screens/profile/post_types/articles.dart';
import 'package:amber/screens/profile/post_types/images.dart';
import 'package:amber/screens/profile/post_types/public_groups.dart';
import 'package:amber/widgets/post_type.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContentCreatorFooter extends StatefulWidget {
  final String userUID;

  const ContentCreatorFooter({Key? key, required this.userUID}) : super(key: key);

  @override
  _ContentCreatorFooterState createState() => _ContentCreatorFooterState();
}

class _ContentCreatorFooterState extends State<ContentCreatorFooter> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.red[100]!,
              icon: const Icon(FontAwesomeIcons.images),
              index: 0,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 0);
              },
            ),
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.greenAccent[100]!,
              icon: const Icon(FontAwesomeIcons.playCircle),
              index: 1,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 1);
              },
            ),
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.blue[100]!,
              icon: const Icon(FontAwesomeIcons.file),
              index: 2,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 2);
              },
            ),
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.brown[100]!,
              icon: const Icon(FontAwesomeIcons.rocketchat),
              index: 3,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 3);
              },
            ),
          ],
        ),
        const SizedBox(),
        if (selectedTab == 0) Posts(userUID: widget.userUID),
        if (selectedTab == 1)
          const Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: Center(child: Text('Thumbnails - To Be Implemented')),
          ),
        if (selectedTab == 2) Articles(userUID: widget.userUID),
        if (selectedTab == 3) PublicGroups(userUID: widget.userUID),
      ],
    );
  }
}
