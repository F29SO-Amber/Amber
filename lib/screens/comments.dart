import 'package:amber/models/comment.dart';
import 'package:amber/models/user.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/utilities/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  final String postID;
  final String username;
  final String profilePhotoURL;

  const CommentsPage(
      {Key? key, required this.postID, required this.username, required this.profilePhotoURL})
      : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Comments', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
            stream: DatabaseService.commentsRef
                .doc(widget.postID)
                .collection('comments')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var list = (snapshot.data as QuerySnapshot).docs.toList();
                return Container(
                  child: list.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text('No comments'),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              reverse: true,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              itemCount: list.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                CommentModel comments = CommentModel.fromDocument(list[index]);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                      leading: CircleAvatar(
                                        radius: 20.0,
                                        backgroundImage: NetworkImage(comments.userProfilePhoto),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            '${comments.username}: ',
                                            style: const TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            comments.comment,
                                            style: const TextStyle(fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                      subtitle: Text(
                                        timeago.format(comments.timestamp.toDate()),
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                    const Divider()
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Container(
            color: Colors.amber.shade50,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
            child: TextFormField(
              controller: commentController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Write a comment...",
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.comment, color: kAppColor, size: 30),
                suffixIcon: GestureDetector(
                  onTap: () async {
                    if (commentController.text.trim().isNotEmpty) {
                      UserModel user = await DatabaseService.getUser(AuthService.currentUser.uid);
                      Map<String, Object?> map = {};
                      map['username'] = user.username;
                      map['text'] = commentController.text;
                      map['timestamp'] = Timestamp.now();
                      map['profilePhotoURL'] = user.profilePhotoURL;
                      await DatabaseService.commentsRef
                          .doc(widget.postID)
                          .collection('comments')
                          .doc()
                          .set(map);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Comment Posted!")));
                      commentController.text = '';
                      setState(() {});
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Icon(Icons.send, color: kAppColor, size: 30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
