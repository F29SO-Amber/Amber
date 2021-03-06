import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:amber/models/user.dart';
import 'package:amber/pages/settings.dart';
import 'package:amber/pages/user_list.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/widgets/number_and_label.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/screens/profile/edit_profile.dart';
import 'package:amber/widgets/custom_outlined_button.dart';
import 'package:amber/widgets/custom_elevated_button.dart';
import 'package:amber/screens/profile/profile_footers/user_profile_footer.dart';
import 'package:amber/screens/profile/profile_footers/artist_profile_footer.dart';
import 'package:amber/screens/profile/profile_footers/student_profile_footer.dart';
import 'package:amber/screens/profile/profile_footers/brand_marketer_profile_footer.dart';
import 'package:amber/screens/profile/profile_footers/content_creator_profile_footer.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../chat/chat.dart';

class ProfilePage extends StatefulWidget {
  static const id = '/profile';
  final String userUID;

  const ProfilePage({Key? key, required this.userUID}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  String? followerCount;

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  Future<void> checkIfFollowing() async {
    DocumentSnapshot doc = await DatabaseService.followersRef
        .doc(widget.userUID)
        .collection('userFollowers')
        .doc(AuthService.currentUser.uid)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  Future<void> unfollowUser() async {
    setState(() {
      isFollowing = false;
    });
    //remove follower
    DatabaseService.followersRef
        .doc(widget.userUID)
        .collection('userFollowers')
        .doc(AuthService.currentUser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //remove following
    DatabaseService.followingRef
        .doc(AuthService.currentUser.uid)
        .collection('userFollowing')
        .doc(widget.userUID)
        .get()
        .then(
      (doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      },
    );
  }

  Future<void> followUser() async {
    setState(() {
      isFollowing = true;
    });
    //updates the followers collection of the followed user
    DatabaseService.followersRef
        .doc(widget.userUID)
        .collection('userFollowers')
        .doc(AuthService.currentUser.uid)
        .set({});
    //updates the following collection of the currentUser
    DatabaseService.followingRef
        .doc(AuthService.currentUser.uid)
        .collection('userFollowing')
        .doc(widget.userUID)
        .set({});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService.getUser(widget.userUID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          var user = snapshot.data as UserModel;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '@${user.username}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              actions: [
                (widget.userUID == AuthService.currentUser.uid)
                    ? IconButton(
                        onPressed: () => Navigator.pushNamed(context, SettingsPage.id),
                        icon: const Icon(Icons.settings),
                      )
                    : Container(),
              ],
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
                    child: CustomImage(
                      side: 80,
                      image: NetworkImage(user.imageUrl),
                      borderRadius: 25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${user.firstName} ', style: kDarkLabelTextStyle),
                        (followerCount != null && (followerCount?.length)! > 3)
                            ? const Icon(Icons.verified, color: Colors.amber, size: 22)
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 15),
                    child: Text(user.accountType, style: kLightLabelTextStyle),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: DatabaseService.postsRef
                            .where('authorId', isEqualTo: widget.userUID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return NumberAndLabel(
                              number: '${(snapshot.data as QuerySnapshot).docs.length}',
                              label: '   Posts   ',
                            );
                          } else {
                            return const NumberAndLabel(number: '0', label: '   Posts   ');
                          }
                        },
                      ),
                      StreamBuilder(
                        stream: DatabaseService.followersRef
                            .doc(widget.userUID)
                            .collection('userFollowers')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            followerCount = '${(snapshot.data as QuerySnapshot).docs.length}';
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        UserList(userUID: widget.userUID, followers: true),
                                  ),
                                );
                              },
                              child: NumberAndLabel(
                                number: '${(snapshot.data as QuerySnapshot).docs.length}',
                                label: 'Followers',
                              ),
                            );
                          } else {
                            return const NumberAndLabel(number: '0', label: 'Followers');
                          }
                        },
                      ),
                      StreamBuilder(
                        stream: DatabaseService.followingRef
                            .doc(widget.userUID)
                            .collection('userFollowing')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        UserList(userUID: widget.userUID, followers: false),
                                  ),
                                );
                              },
                              child: NumberAndLabel(
                                number: '${(snapshot.data as QuerySnapshot).docs.length}',
                                label: 'Following',
                              ),
                            );
                          } else {
                            return const NumberAndLabel(number: '0', label: 'Following');
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  (widget.userUID == AuthService.currentUser.uid)
                      ? CustomOutlinedButton(
                          buttonText: 'Edit Profile',
                          widthFactor: 0.9,
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(user: user),
                              ),
                            ).then((value) => setState(() {}));
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CustomOutlinedButton(
                              buttonText: 'Message',
                              widthFactor: 0.45,
                              onPress: () async {
                                List<types.User> users =
                                    await FirebaseChatCore.instance.users().first;
                                types.User user =
                                    users.where((element) => element.id == widget.userUID).first;
                                final room = await FirebaseChatCore.instance.createRoom(user);
                                // Navigator.pop(context);
                                await Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(builder: (context) => ChatPage(room: room)),
                                );
                              },
                            ),
                            (isFollowing) // TODO: Avoid entire widget tree rebuild
                                ? CustomElevatedButton(
                                    buttonText: 'Unfollow',
                                    widthFactor: 0.45,
                                    onPress: unfollowUser,
                                  )
                                : CustomElevatedButton(
                                    buttonText: 'Follow',
                                    widthFactor: 0.45,
                                    onPress: followUser,
                                  ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  if (user.accountType == 'Artist') ArtistFooter(userUID: widget.userUID),
                  if (user.accountType == 'Student') StudentFooter(userUID: widget.userUID),
                  if (user.accountType == 'Brand Marketer')
                    BrandMarketerFooter(userUID: widget.userUID),
                  if (user.accountType == 'Content Creator')
                    ContentCreatorFooter(userUID: widget.userUID),
                  if (user.accountType == 'Personal') UserFooter(userUID: widget.userUID),
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
