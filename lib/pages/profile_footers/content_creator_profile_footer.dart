import 'package:amber/models/post.dart';
import 'package:amber/pages/user_posts.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/post_type.dart';
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
        StreamBuilder(
          stream: DatabaseService.postsRef
              .where('authorId', isEqualTo: widget.userUID)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
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
                  PostModel post = PostModel.fromDocument((snapshot.data! as dynamic).docs[index]);
                  return GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        image:
                            DecorationImage(image: NetworkImage(post.imageURL), fit: BoxFit.cover),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(11.0),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CurrentUserPosts(uid: widget.userUID, index: index),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No Posts'));
            }
          },
        ),
      ],
    );
  }
}
