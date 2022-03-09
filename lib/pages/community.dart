import 'package:amber/pages/user_list.dart';
import 'package:amber/pages/user_posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

import '../models/post.dart';
import '../services/auth_service.dart';

// TODO: Create communities

class CommunityPage extends StatefulWidget {
  static const id = '/community';
  final String communityID;

  const CommunityPage({Key? key, required this.communityID}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int selectedTab = 0;
  bool isFollowing = false;
  String? followerCount;

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  Future<void> checkIfFollowing() async {
    DocumentSnapshot doc = await DatabaseService.followersRef
        .doc(widget.communityID)
        .collection('communityFollowers')
        .doc(AuthService.currentUser.uid)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  Future<void> unfollowCommunity() async {
    setState(() => isFollowing = false);
    //remove follower
    DatabaseService.followersRef
        .doc(widget.communityID)
        .collection('communityFollowers')
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
        .collection('userCommunities')
        .doc(widget.communityID)
        .get()
        .then(
      (doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      },
    );
  }

  Future<void> followCommunity() async {
    setState(() => isFollowing = true);
    //updates the followers collection of the followed user
    DatabaseService.followersRef
        .doc(widget.communityID)
        .collection('communityFollowers')
        .doc(AuthService.currentUser.uid)
        .set({});
    //updates the following collection of the currentUser
    DatabaseService.followingRef
        .doc(AuthService.currentUser.uid)
        .collection('userCommunities')
        .doc(widget.communityID)
        .set({});
  }

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
                    child: CustomImage(side: 100, image: NetworkImage(community.communityPhotoURL)),
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
                    children: [
                      StreamBuilder(
                        stream: DatabaseService.postsRef
                            .where('forCommunity', isEqualTo: widget.communityID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return NumberAndLabel(
                              number: '${(snapshot.data as QuerySnapshot).docs.length}',
                              label: '   Posts   ',
                            );
                          } else {
                            return const NumberAndLabel(number: '0', label: '  Posts  ');
                          }
                        },
                      ),
                      StreamBuilder(
                        stream: DatabaseService.followersRef
                            .doc(widget.communityID)
                            .collection('communityFollowers')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            followerCount = '${(snapshot.data as QuerySnapshot).docs.length}';
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        UserList(userUID: widget.communityID, followers: true),
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
                      const NumberAndLabel(number: '2.4K', label: 'Likes'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomOutlinedButton(
                        buttonText: 'Message Creator',
                        widthFactor: 0.45,
                        onPress: () {},
                      ),
                      (isFollowing) // TODO: Avoid entire widget tree rebuild
                          ? CustomElevatedButton(
                              buttonText: 'Leave Community',
                              widthFactor: 0.45,
                              onPress: unfollowCommunity,
                            )
                          : CustomElevatedButton(
                              buttonText: 'Join Community',
                              widthFactor: 0.45,
                              onPress: followCommunity,
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PostType(
                    numOfDivisions: 1,
                    bgColor: Colors.red[100]!,
                    icon: const Icon(FontAwesomeIcons.images),
                    index: 0,
                    currentTab: selectedTab,
                    onPress: () {
                      // setState(() => selectedTab = 0);
                    },
                  ),
                  StreamBuilder(
                    stream: DatabaseService.postsRef
                        .where('forCommunity', isEqualTo: widget.communityID)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var list = (snapshot.data as QuerySnapshot).docs.toList();
                        return list.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 120.0),
                                child: Center(child: Text('No posts to display!')),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(10).copyWith(bottom: 30),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (snapshot.data! as dynamic).docs.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  PostModel post = PostModel.fromDocument(list[index]);
                                  return GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(post.imageURL), fit: BoxFit.cover),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(11.0),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CurrentUserPosts(
                                            coll: 'forCommunity',
                                            uid: widget.communityID,
                                            index: index,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                      } else {
                        return Container();
                      }
                    },
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
