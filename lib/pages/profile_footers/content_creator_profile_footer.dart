import 'package:amber/models/post.dart';
import 'package:amber/pages/user_posts.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/post_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          const Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: Center(child: Text('Thumbnails - To Be Implemented')),
          ),
        if (selectedTab == 2)
          const Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: Center(child: Text('Articles - To Be Implemented')),
          ),
        if (selectedTab == 3)
          const Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: Center(child: Text('Public Groups - To Be Implemented')),
          ),
      ],
    );
  }
}
