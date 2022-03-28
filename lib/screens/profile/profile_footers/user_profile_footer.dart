import 'package:amber/screens/profile/post_types/images.dart';
import 'package:amber/widgets/post_type.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserFooter extends StatefulWidget {
  final String userUID;

  const UserFooter({Key? key, required this.userUID}) : super(key: key);

  @override
  _UserFooterState createState() => _UserFooterState();
}

class _UserFooterState extends State<UserFooter> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            PostType(
              numOfDivisions: 1,
              bgColor: Colors.red[100]!,
              icon: const Icon(FontAwesomeIcons.images),
              index: 0,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 0);
              },
            ),
          ],
        ),
        const SizedBox(),
        Posts(userUID: widget.userUID),
      ],
    );
  }
}
