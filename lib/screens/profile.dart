import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService.getUser(widget.userUID).asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var user = snapshot.data as UserModel;
          return Scaffold(
            appBar: AppBar(
              title: Text('@${user.username}',
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: (widget.userUID == Authentication.currentUser.uid)
                      ? GestureDetector(
                          child: const Icon(Icons.logout_outlined, color: Colors.white),
                          onTap: () {
                            Authentication.signOutUser();
                            Navigator.of(context, rootNavigator: true).pushReplacement(
                              MaterialPageRoute(builder: (context) => LoginScreen()),
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
                    child: ProfilePicture(side: 100, image: user.profilePhoto),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${user.name} ', style: kDarkLabelTextStyle),
                        const Icon(Icons.verified, color: Colors.amber, size: 22),
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
                          if (snapshot.hasData &&
                              snapshot.connectionState == ConnectionState.done) {
                            return NumberAndLabel(
                              number: '${(snapshot.data as QuerySnapshot).docs.length}',
                              label: '   Posts   ',
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      const NumberAndLabel(number: '524', label: 'Followers'),
                      const NumberAndLabel(number: '343', label: 'Following'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  (widget.userUID == Authentication.currentUser.uid)
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
                              onPress: () {},
                            ),
                            ElevatedButton(
                              child: const Text('Follow'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(MediaQuery.of(context).size.width * 0.45, 43),
                                primary: Colors.amber.shade300,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
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
                  FutureBuilder(
                    future: DatabaseService.postsRef
                        .where('authorId', isEqualTo: widget.userUID)
                        .orderBy('timestamp', descending: true)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(10),
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            PostModel post =
                                PostModel.fromDocument((snapshot.data! as dynamic).docs[index]);
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(image: post.image, fit: BoxFit.cover),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(11.0),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
