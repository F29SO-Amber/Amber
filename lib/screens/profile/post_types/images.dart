import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:amber/models/post.dart';
import 'package:amber/pages/user_posts.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/screens/profile/profile_footers/artist_profile_footer.dart';

class Posts extends StatelessWidget {
  final String userUID;

  const Posts({Key? key, required this.userUID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService.postsRef
          .where('authorId', isEqualTo: userUID)
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
                              uid: userUID,
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
    );
  }
}
