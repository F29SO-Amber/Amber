import 'package:amber/models/hashtag.dart';
import 'package:amber/models/post.dart';
import 'package:amber/pages/posts.dart';
import 'package:amber/pages/search.dart';
import 'package:amber/widgets/post_widget.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:amber/models/user.dart';
import 'package:amber/screens/profile.dart';
import 'package:amber/widgets/user_card.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverPage extends StatefulWidget {
  static const id = '/discover';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

/*
  Discover Page helps users to discover various other users and communities that
  they might be interested in following or having a glance at.
*/
class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber, //sets the color to amber
        title: const Text(kAppName), //Title of the app
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
            onTap: () => Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(builder: (context) =>  Search()),
                            )
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Highlights', style: GoogleFonts.dmSans(fontSize: 20)),
            ),
            FutureBuilder(
              future: DatabaseService.postsRef.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: ((MediaQuery.of(context).size.width * 0.8) * 9) / 10,
                    child: Swiper(
                      outer: true,
                      fade: 0.8,
                      viewportFraction: 0.85,
                      scale: 0.9,
                      itemBuilder: (c, i) {
                        var post = PostModel.fromDocument((snapshot.data! as dynamic).docs[i]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return Scaffold(
                                appBar: AppBar(
                                  backgroundColor: Colors.amber, //sets the color to amber
                                  title: const Text(kAppName), //Title of the app
                                ),
                                body: UserPost(post: post),
                              );
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(post.imageURL), fit: BoxFit.cover),
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        );
                      },
                      pagination: const SwiperPagination(alignment: Alignment.topCenter),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Discover Users', style: GoogleFonts.dmSans(fontSize: 20)),
            ),
            StreamBuilder(
              stream: DatabaseService.usersRef.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var list = (snapshot.data as QuerySnapshot).docs.toList();
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    height: 181,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          UserModel user = UserModel.fromDocument(list[index]);
                          return SizedBox(
                            width: 151,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      child: ProfilePicture(
                                        side: 135,
                                        image: NetworkImage(user.profilePhotoURL),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfilePage(userUID: user.id),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(user.name, style: kLightLabelTextStyle),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Explore Hashtags', style: GoogleFonts.dmSans(fontSize: 20)),
            ),
            ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: Hashtag.hashtags.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Hashtag tag = Hashtag.hashtags[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/image.png'), fit: BoxFit.cover),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      title: Text(
                        tag.name,
                        // style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => Posts(tag: tag.name)),
                      //   );
                      // },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
