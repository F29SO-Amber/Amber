import 'package:amber/models/article.dart';
import 'package:amber/models/thumbnail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:amber/user_data.dart';
import 'package:amber/models/post.dart';
import 'package:amber/widgets/feed_entity.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

class FeedPage extends StatefulWidget {
  static const id = '/feed';

  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text(kAppName),
        titleTextStyle: const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 25.0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              size: 30,
            ),
            onPressed: () {
              showDialogFunc(context, "Presenting the Future of Live Collaboration, Amber!");
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: DatabaseService.timelineRef
            .doc(UserData.currentUser!.id)
            .collection('timelinePosts')
            .snapshots()
            .map((snapshot) => snapshot.docs.map((e) => PostModel.fromDocument(e))),
        builder: (context, snapshot1) {
          if (snapshot1.hasData) {
            return StreamBuilder(
                stream: DatabaseService.timelineRef
                    .doc(UserData.currentUser!.id)
                    .collection('timelineThumbnails')
                    .snapshots()
                    .map((snapshot) => snapshot.docs.map((e) => ThumbnailModel.fromDocument(e))),
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    return StreamBuilder(
                        stream: DatabaseService.timelineRef
                            .doc(UserData.currentUser!.id)
                            .collection('timelineArticles')
                            .snapshots()
                            .map((snapshot) =>
                                snapshot.docs.map((e) => ArticleModel.fromDocument(e))),
                        builder: (context, snapshot3) {
                          if (snapshot3.hasData) {
                            List list = [
                              ...(snapshot1.data as dynamic).toList(),
                              ...(snapshot2.data as dynamic).toList(),
                              ...(snapshot3.data as dynamic).toList()
                            ];
                            list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
                            list = list.reversed.toList();
                            return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) => FeedEntity(feedEntity: list[index]),
                            );
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return Container();
                  }
                });
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  child: ListView.builder(
                    itemCount: 9,
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 15.0,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 9 / 16,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
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
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

showDialogFunc(context, title) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              height: 700,
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StyledText(
                      text: """

<bold>Let's Get Started</bold>
The first page you are directed to is known as the "Feed Page". Here
you will be able to see posts from every Amber account that you Follow.
Do me a favor and try scrolling Horizontally on one of the Posts you see.

<bold><head>Our main features</head></bold>
<bold>Scroll a post Right to Mash-up!</bold>
The backbone of Project Amber is the opportunity to MashUp posts from accounts you follow either by yourself,
or with a group. This allows for seamless and enjoyable artistic ingenuity to flow from
every user on our platform.

<bold>Scroll a post Left to share your Thoughts!</bold>
Praise and kind words make our day dont they? Send those you follow some words of encouragement by
commenting on their posts. This allows for feedback and critiques on your work of art.

<bold>Click the arrows Up/Down!</bold>
These arrows tell the Account the general feedback to their work. Clicking the arrow pointing
upwards gives the post a positive score and the other lowers it by a point.



""",
                      tags: {
                        'bold': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
                        'head': StyledTextTag(style: TextStyle(fontSize: 20))
                      },
                    )
                  ],
                ),
              )),
        ),
      );
    },
  );
}
