import 'package:amber/models/event.dart';
import 'package:amber/models/post.dart';
import 'package:amber/pages/user_posts.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/post_type.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BrandMarketerFooter extends StatefulWidget {
  final String userUID;

  const BrandMarketerFooter({Key? key, required this.userUID}) : super(key: key);

  @override
  _BrandMarketerFooterState createState() => _BrandMarketerFooterState();
}

class _BrandMarketerFooterState extends State<BrandMarketerFooter> {
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
              icon: const Icon(FontAwesomeIcons.file),
              index: 1,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 1);
              },
            ),
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.brown[100]!,
              icon: const Icon(FontAwesomeIcons.calendarCheck),
              index: 2,
              currentTab: selectedTab,
              onPress: () {
                setState(() => selectedTab = 2);
              },
            ),
            PostType(
              numOfDivisions: 4,
              bgColor: Colors.blue[100]!,
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
                        child: Center(child: Text('No marketing posts to display!')),
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
          const Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: Center(child: Text('Articles - To Be Implemented')),
          ),
        if (selectedTab == 2)
          StreamBuilder(
            stream: DatabaseService.eventsRef
                .where('userID', isEqualTo: widget.userUID)
                // .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                var list = (snapshot.data as QuerySnapshot).docs.toList();
                return list.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 120.0),
                        child: Center(child: Text('No events to display!')),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(10).copyWith(bottom: 30),
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          EventModel event = EventModel.fromDocument(list[index]);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                leading: CustomImage(
                                  side: 100.0,
                                  image: NetworkImage(event.eventPhotoURL),
                                  borderRadius: 10,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      event.description,
                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  '${event.venue} - ${event.startingTime}',
                                  style: const TextStyle(fontSize: 12.0),
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
        if (selectedTab == 3)
          const Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: Center(child: Text('Public Groups - To Be Implemented')),
          ),
      ],
    );
  }
}
