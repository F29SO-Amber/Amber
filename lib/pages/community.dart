import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/models/community.dart';
import 'package:amber/widgets/post_type.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/widgets/number_and_label.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/custom_elevated_button.dart';
import 'package:amber/widgets/custom_outlined_button.dart';

class CommunityPage extends StatefulWidget {
  static const id = '/community';
  final String communityID;

  const CommunityPage({Key? key, required this.communityID}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService.getCommunity(widget.communityID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var community = snapshot.data as CommunityModel;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '@${community.ownerUsername}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              backgroundColor: kAppColor,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        ProfilePicture(side: 100, image: NetworkImage(community.communityPhotoURL)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('${community.name} ', style: kDarkLabelTextStyle),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 15),
                    child: Text(community.description, style: kLightLabelTextStyle),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      NumberAndLabel(number: '12', label: '  Posts  '),
                      NumberAndLabel(number: '128', label: 'Followers'),
                      NumberAndLabel(number: '2.4K', label: 'Likes'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomOutlinedButton(
                        buttonText: 'Message',
                        widthFactor: 0.45,
                        onPress: () {
                          // Navigator.of(context, rootNavigator: true).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => ChatPage(
                          //       chatID: user.email,
                          //       chatName: user.name,
                          //       url: user.profilePhotoURL,
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                      CustomElevatedButton(
                        buttonText: 'Join Community',
                        widthFactor: 0.45,
                        onPress: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      PostType(
                        numOfDivisions: 2,
                        bgColor: Colors.red[100]!,
                        icon: const Icon(FontAwesomeIcons.images),
                        index: 0,
                        currentTab: selectedTab,
                        onPress: () {
                          setState(() => selectedTab = 0);
                        },
                      ),
                      PostType(
                        numOfDivisions: 2,
                        bgColor: Colors.greenAccent[100]!,
                        icon: const Icon(FontAwesomeIcons.rocketchat),
                        index: 1,
                        currentTab: selectedTab,
                        onPress: () {
                          setState(() => selectedTab = 1);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
