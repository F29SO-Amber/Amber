import 'dart:math';

import 'package:amber/pages/error.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:amber/models/user.dart';
import 'package:amber/models/post.dart';
import 'package:amber/pages/search.dart';
import 'package:amber/models/hashtag.dart';
import 'package:amber/screens/profile/profile.dart';
import 'package:amber/widgets/feed_entity.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/database_service.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';

// TODO: Create search bar
// TODO: Create discover algorithms

class DiscoverPage extends StatefulWidget {
  static const id = '/discover';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(kAppName),
        titleTextStyle: const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 25.0),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) => const ErrorScreen()),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
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
                                    body: FeedEntity(feedEntity: post),
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
                                          child: CustomImage(
                                            side: 135,
                                            image: NetworkImage(user.imageUrl),
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
                                        child: Text(user.firstName, style: kLightLabelTextStyle),
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
                GridView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Hashtag.hashtags.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    Hashtag tag = Hashtag.hashtags[index];
                    return GestureDetector(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/hashtags/${tag.name.substring(1)}.jpeg'),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          Text(tag.name, style: const TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // FloatingSearchBar(
          //   hint: 'Search...',
          //   scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          //   transitionDuration: const Duration(milliseconds: 800),
          //   transitionCurve: Curves.easeInOut,
          //   physics: const BouncingScrollPhysics(),
          //   axisAlignment: isPortrait ? 0.0 : -1.0,
          //   openAxisAlignment: 0.0,
          //   width: isPortrait ? 600 : 500,
          //   debounceDelay: const Duration(milliseconds: 500),
          //   onQueryChanged: (query) {
          //     // Call your model, bloc, controller here.
          //   },
          //   // Specify a custom transition to be used for
          //   // animating between opened and closed stated.
          //   transition: CircularFloatingSearchBarTransition(),
          //   actions: [
          //     FloatingSearchBarAction(
          //       showIfOpened: false,
          //       child: CircularButton(
          //         icon: const Icon(Icons.place),
          //         onPressed: () {},
          //       ),
          //     ),
          //     FloatingSearchBarAction.searchToClear(
          //       showIfClosed: false,
          //     ),
          //   ],
          //   builder: (context, transition) {
          //     return ClipRRect(
          //       borderRadius: BorderRadius.circular(8),
          //       child: Material(
          //         color: Colors.white,
          //         elevation: 4.0,
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: Colors.accents.map((color) {
          //             return Container(height: 112, color: color);
          //           }).toList(),
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
