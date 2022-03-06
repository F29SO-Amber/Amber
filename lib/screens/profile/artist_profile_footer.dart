import 'package:amber/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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
                                  builder: (context) =>
                                      CurrentUserPosts(uid: widget.userUID, index: index),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                leading: CustomImage(
                                  side: 100.0,
                                  image: NetworkImage(article.imageURL),
                                  borderRadius: 10,
                                ),
                                title: Text(
                                  article.authorUserName,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(
                                  '${article.timestamp}',
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                                trailing: CustomOutlinedButton(
                                  widthFactor: 0.19,
                                  onPress: () {
                                    Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(
                                        builder: (context) => ArticleScreen(article: article),
                                      ),
                                    );
                                  },
                                  buttonText: 'Read',
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
              } else {
                return Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 48.0,
                              height: 48.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 6,
                    ),
                  ),
                );
              }
            },
          ),
        if (selectedTab == 2)
          StreamBuilder(
            stream: DatabaseService.roomsRef
                .where('metadata', isEqualTo: {'createdBy': widget.userUID}).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                var list = (snapshot.data as QuerySnapshot).docs.toList();
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
                          // types.Room room = types.Room.fromJson(list[index]);
                          return Text(list[index]['name']);
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                leading: CustomImage(
                                  side: 100.0,
                                  image: NetworkImage(community.communityPhotoURL),
                                  borderRadius: 10,
                                ),
                                title: Text(
                                  community.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(
                                  community.description,
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                                trailing: CustomOutlinedButton(
                                  widthFactor: 0.1,
                                  onPress: () {
                                    Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(
                                        builder: (context) => CommunityPage(
                                          communityID: list[index].id,
                                        ),
                                      ),
                                    );
                                  },
                                  buttonText: 'Join',
                                ),
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
