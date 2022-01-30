import 'package:amber/models/post.dart';
import 'package:amber/pages/user_posts.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/post_type.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserFooter extends StatefulWidget {
  final String userUID;

  const UserFooter({Key? key, required this.userUID}) : super(key: key);

  @override
  _UserFooterState createState() => _UserFooterState();
}

class _UserFooterState extends State<UserFooter> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            PostType(
              numOfDivisions: 1,
              bgColor: Colors.red[100]!,
              icon: const Icon(FontAwesomeIcons.images),
              index: 0,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 0);
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