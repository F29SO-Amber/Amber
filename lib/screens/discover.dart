import 'package:amber/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:amber/models/user.dart';
import 'package:amber/screens/profile.dart';
import 'package:amber/widgets/user_card.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

class DiscoverPage extends StatefulWidget {
  static const id = '/discover';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

/*
  Discover Page helps users to discover various other users and communities that
  they might be interested in following or having a glance at.
*/
class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber, //sets the color to amber
        title: const Text(kAppName), //Title of the app
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Posts', style: kDarkLabelTextStyle.copyWith(fontSize: 30)),
            ),
            FutureBuilder(
              future: DatabaseService.postsRef.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: ((MediaQuery.of(context).size.width * 0.8) * 9) / 10,
                    child: Swiper(
                      outer: true,
                      fade: 0.8,
                      viewportFraction: 0.85,
                      scale: 0.9,
                      itemBuilder: (c, i) {
                        var post = PostModel.fromDocument((snapshot.data! as dynamic).docs[i]);
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(post.imageURL), fit: BoxFit.cover),
                            shape: BoxShape.rectangle,
                          ),
                        );
                      },
                      pagination: const SwiperPagination(alignment: Alignment.topCenter),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Users', style: kDarkLabelTextStyle.copyWith(fontSize: 30)),
            ),
            StreamBuilder(
              stream: DatabaseService.usersRef.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var list = (snapshot.data as QuerySnapshot).docs.toList();
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user = UserModel.fromDocument(list[index]);
                      return UserCard(
                        user: user,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(userUID: user.id)));
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
                // //Show a list of the current users in the app
                // List<UserCard> list = [];
                // snapshot.data?.docs.forEach((doc) {
                //   UserModel user = UserModel.fromDocument(doc);
                //   if (user.id != AuthService.currentUser.uid) {
                //     list.add(
                //       UserCard(
                //         user: user,
                //         onPress: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => ProfilePage(userUID: user.id)));
                //         },
                //       ),
                //     );
                //   }
                // });
                // return ListView(children: list);
              },
            ),
          ],
        ),
      ),
    );
  }
}
