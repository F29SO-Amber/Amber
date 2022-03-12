import 'package:amber/services/auth_service.dart';
import 'package:amber/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:timeago/timeago.dart' as timeago;

import 'package:amber/models/post.dart';
import 'package:amber/pages/article.dart';
import 'package:amber/models/article.dart';
import 'package:amber/pages/community.dart';
import 'package:amber/pages/user_posts.dart';
import 'package:amber/models/community.dart';
import 'package:amber/widgets/post_type.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/custom_outlined_button.dart';

class ArtistFooter extends StatefulWidget {
  final String userUID;

  const ArtistFooter({Key? key, required this.userUID}) : super(key: key);

  @override
  _ArtistFooterState createState() => _ArtistFooterState();
}

class _ArtistFooterState extends State<ArtistFooter> {
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
              icon: const Icon(FontAwesomeIcons.palette),
              index: 0,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 0);
              },
            ),
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.greenAccent[100]!,
              icon: const Icon(FontAwesomeIcons.file),
              index: 1,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 1);
              },
            ),
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.orange[100]!,
              icon: const Icon(FontAwesomeIcons.rocketchat),
              index: 2,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 2);
              },
            ),
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.brown[100]!,
              icon: const Icon(FontAwesomeIcons.userFriends),
              index: 3,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 3);
              },
            ),
          ],
        ),
        const SizedBox(),
        if (selectedTab == 0)
          StreamBuilder(
            stream: DatabaseService.postsRef
                .where('authorId', isEqualTo: widget.userUID)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                var list = (snapshot.data as QuerySnapshot).docs.toList();
                return list.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 120.0),
                        child: Center(child: Text('No art pieces to display!')),
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
                                    uid: widget.userUID,
                                    index: index,
                                    coll: 'authorId',
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
        if (selectedTab == 1)
          StreamBuilder(
            stream: DatabaseService.articlesRef
                .where('authorId', isEqualTo: widget.userUID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                var list = (snapshot.data as QuerySnapshot).docs.toList();
                return list.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 120.0),
                        child: Center(child: Text('No articles to display!')),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(10).copyWith(bottom: 30),
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          ArticleModel article = ArticleModel.fromDocument(list[index]);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImage(
                                        image: NetworkImage(article.imageURL),
                                        height: 50,
                                        width: 50,
                                        borderRadius: 5,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.authorUserName,
                                            style: const TextStyle(fontSize: 17),
                                          ),
                                          Text(
                                            timeago.format(article.timestamp.toDate()),
                                            style: kLightLabelTextStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    child: const Icon(Icons.open_in_new, size: 25),
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).push(
                                        MaterialPageRoute(
                                          builder: (context) => ArticleScreen(article: article),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        if (selectedTab == 2)
          StreamBuilder<List<types.Room>>(
            stream: FirebaseChatCore.instance.rooms(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                List list = snapshot.data!
                    .where((element) => element.type == types.RoomType.group)
                    .toList();
                return list.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 120.0),
                        child: Center(child: Text('No public groups to display!')),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(10).copyWith(bottom: 30),
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final room = list[index] as types.Room;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImage(
                                        image: NetworkImage(room.imageUrl!),
                                        height: 50,
                                        width: 50,
                                        borderRadius: 5,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            room.name!,
                                            style: const TextStyle(fontSize: 17),
                                          ),
                                          Text(
                                            '${room.users.length} members',
                                            style: kLightLabelTextStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    child: const Icon(Icons.add_circle, size: 30),
                                    onTap: () async {
                                      List users = room.users.map((e) => e.id).toList();
                                      await DatabaseService.roomsRef
                                          .doc(room.id)
                                          .update({'userIds': users});
                                      EasyLoading.showSuccess('Success!');
                                    },
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        if (selectedTab == 3)
          StreamBuilder(
            stream: DatabaseService.communityRef
                .where('ownerID', isEqualTo: widget.userUID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                var list = (snapshot.data as QuerySnapshot).docs.toList();
                return list.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 120.0),
                        child: Center(child: Text('No communities to display!')),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(10).copyWith(bottom: 30),
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          CommunityModel community = CommunityModel.fromDocument(list[index]);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImage(
                                        image: NetworkImage(community.communityPhotoURL),
                                        height: 50,
                                        width: 50,
                                        borderRadius: 5,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            community.name,
                                            style: const TextStyle(fontSize: 17),
                                          ),
                                          Text(
                                            community.description,
                                            style: kLightLabelTextStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    child: const Icon(Icons.add_circle, size: 30),
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).push(
                                        MaterialPageRoute(
                                          builder: (context) => CommunityPage(
                                            communityID: list[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
      ],
    );
  }
}
