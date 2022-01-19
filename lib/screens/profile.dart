import 'package:amber/widgets/custom_elevated_button.dart';
import 'package:amber/widgets/progress.dart';
import 'package:amber/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/utilities/constants.dart';
import 'package:amber/models/user.dart';
import 'package:amber/models/post.dart';
import 'package:amber/screens/login.dart';
import 'package:amber/widgets/post_type.dart';
import 'package:amber/screens/edit_profile.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/widgets/number_and_label.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/custom_outlined_button.dart';
// am2024@hw.ac.uk

class ProfilePage extends StatefulWidget {
  static const id = '/profile';
  final String userUID;

  const ProfilePage({Key? key, required this.userUID}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await DatabaseService.followersRef
        .doc(widget.userUID)
        .collection('userFollowers')
        .doc(AuthService.currentUser.uid)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  unfollowUser() async {
    setState(() => isFollowing = false);
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

  followUser() async {
    setState(() => isFollowing = true);
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
    return StreamBuilder(
      stream: DatabaseService.getUser(widget.userUID).asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var user = snapshot.data as UserModel;
          // print(DatabaseService.user?.name);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '@${user.username}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: (widget.userUID == AuthService.currentUser.uid)
                      ? GestureDetector(
                          child: const Icon(Icons.logout_outlined,
                              color: Colors.white),
                          onTap: () {
                            AuthService.signOutUser();
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                        )
                      : Container(),
                ),
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
                    child: ProfilePicture(
                        side: 100, image: NetworkImage(user.profilePhotoURL)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${user.name} ', style: kDarkLabelTextStyle),
                        const Icon(Icons.verified,
                            color: Colors.amber, size: 22),
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
                            .get()
                            .asStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return NumberAndLabel(
                              number:
                                  '${(snapshot.data as QuerySnapshot).docs.length}',
                              label: '   Posts   ',
                            );
                          } else {
                            return const NumberAndLabel(
                                number: '0', label: '   Posts   ');
                          }
                        },
                      ),
                      StreamBuilder(
                        stream: DatabaseService.followersRef
                            .doc(widget.userUID)
                            .collection('userFollowers')
                            .get()
                            .asStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return GestureDetector(
                                onTap: () {
                                  _navigateToNextScreen(context);
                                },
                                child: NumberAndLabel(
                                  number:
                                      '${(snapshot.data as QuerySnapshot).docs.length}',
                                  label: 'Followers',
                                ));
                          } else {
                            return const NumberAndLabel(
                                number: '0', label: 'Followers');
                          }
                        },
                      ),
                      StreamBuilder(
                        stream: DatabaseService.followingRef
                            .doc(widget.userUID)
                            .collection('userFollowing')
                            .get()
                            .asStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return GestureDetector(
                                onTap: () {
                                  _navigateTofollowingScreen(context);
                                },
                                child: NumberAndLabel(
                                  number:
                                      '${(snapshot.data as QuerySnapshot).docs.length}',
                                  label: 'Following',
                                ));
                          } else {
                            return const NumberAndLabel(
                                number: '0', label: 'Following');
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
                                builder: (context) =>
                                    EditProfileScreen(user: user),
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
                              onPress: () {},
                            ),
                            (isFollowing)
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
                  Row(
                    children: <Widget>[
                      PostType(
                        numOfDivisions: 3,
                        bgColor: Colors.red[100]!,
                        icon: const Icon(FontAwesomeIcons.images),
                        index: 0,
                        currentTab: selectedTab,
                        onPress: () {
                          setState(() => selectedTab = 0);
                        },
                      ),
                      PostType(
                        numOfDivisions: 3,
                        bgColor: Colors.greenAccent[100]!,
                        icon: const Icon(FontAwesomeIcons.playCircle),
                        index: 1,
                        currentTab: selectedTab,
                        onPress: () {
                          setState(() => selectedTab = 1);
                        },
                      ),
                      PostType(
                        numOfDivisions: 3,
                        bgColor: Colors.brown[100]!,
                        icon: const Icon(FontAwesomeIcons.userFriends),
                        index: 2,
                        currentTab: selectedTab,
                        onPress: () {
                          setState(() => selectedTab = 2);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(),
                  StreamBuilder(
                    stream: DatabaseService.postsRef
                        .where('authorId', isEqualTo: widget.userUID)
                        .orderBy('timestamp', descending: true)
                        .get()
                        .asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return GridView.builder(
                          padding:
                              const EdgeInsets.all(10).copyWith(bottom: 30),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            PostModel post = PostModel.fromDocument(
                                (snapshot.data! as dynamic).docs[index]);
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(post.imageURL),
                                    fit: BoxFit.cover),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(11.0),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No Posts'));
                      }
                    },
                  )
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

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => followers()));
  }

  void _navigateTofollowingScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => following()));
  }
}

Future<List<UserModel>> getFollowersUIDs() async {
  QuerySnapshot followers = await DatabaseService.followersRef
      .doc(AuthService.currentUser.uid)
      .collection('userFollowers')
      .get();

  List ids = followers.docs.map((e) => (e.id)).toList();
  List<UserModel> users = [];
  for (String x in ids) {
    users.add(await DatabaseService.getUser(x));
  }
  return users;
}

Future<List<UserModel>> getFollowingUID() async {
  QuerySnapshot following = await DatabaseService.followingRef
      .doc(AuthService.currentUser.uid)
      .collection('userFollowing')
      .get();

  List ids = following.docs.map((e) => (e.id)).toList();
  List<UserModel> users = [];
  for (String x in ids) {
    users.add(await DatabaseService.getUser(x));
  }
  return users;
}

class followers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(kAppName),
      ),
      body: FutureBuilder(
        future: getFollowersUIDs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<UserCard> list = [];
            var a = snapshot.data as List<UserModel>;
            for (UserModel user in a) {
              print(user.username);
              list.add(
                UserCard(
                  user: user,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(userUID: user.id)),
                    );
                  },
                ),
              );
            }
            return ListView(children: list);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class following extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(kAppName),
      ),
      body: FutureBuilder(
        future: getFollowingUID(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<UserCard> list = [];
            var a = snapshot.data as List<UserModel>;
            for (UserModel user in a) {
              print(user.username);
              list.add(
                UserCard(
                  user: user,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(userUID: user.id)),
                    );
                  },
                ),
              );
            }
            return ListView(children: list);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
