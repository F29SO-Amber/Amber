import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:amber/models/article.dart';
import 'package:amber/pages/article.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';

class Articles extends StatelessWidget {
  final String userUID;

  const Articles({Key? key, required this.userUID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService.articlesRef.where('authorId', isEqualTo: userUID).snapshots(),
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
                                    builder: (context) => ArticleScreen(articles: list),
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
          return Container();
        }
      },
    );
  }
}
