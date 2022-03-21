import 'package:amber/models/community.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:amber/services/database_service.dart';
import 'package:amber/user_data.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/feed_entity.dart';

import '../../pages/community.dart';
import '../../widgets/profile_picture.dart';

class DiscoverCommunities extends StatelessWidget {
  static const id = '/discover_communities';

  const DiscoverCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      body: StreamBuilder(
        stream: DatabaseService.communityRef
            // .where('ownerID', isNotEqualTo: UserData.currentUser!.id)
            .snapshots()
            .map((snapshot) => snapshot.docs.map((e) => CommunityModel.fromDocument(e))),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List list = (snapshot.data as dynamic).toList();
            return ListView.builder(
              padding: const EdgeInsets.all(10).copyWith(bottom: 30),
              itemCount: list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                CommunityModel community = list[index];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomImage(
                              image: NetworkImage(community.communityPhotoURL),
                              height: 50,
                              width: 50,
                              borderRadius: 5,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  community.name,
                                  style: const TextStyle(fontSize: 17),
                                ),
                                Text(
                                  community.description,
                                  style: kLightLabelTextStyle,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'No. of posts:      ',
                                      style: kLightLabelTextStyle.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    StreamBuilder(
                                      stream: DatabaseService.postsRef
                                          .where('forCommunity', isEqualTo: community.id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                              '${(snapshot.data as QuerySnapshot).docs.length}',
                                              style: kLightLabelTextStyle);
                                        } else {
                                          return Text('0', style: kLightLabelTextStyle);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Total Followers:  ',
                                      style: kLightLabelTextStyle.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    StreamBuilder(
                                      stream: DatabaseService.followersRef
                                          .doc(community.id)
                                          .collection('communityFollowers')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                              '${(snapshot.data as QuerySnapshot).docs.length}',
                                              style: kLightLabelTextStyle);
                                        } else {
                                          return Text('0', style: kLightLabelTextStyle);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: const Icon(Icons.add_circle, size: 30),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => CommunityPage(
                                  communityID: list[index].id,
                                ),
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
      ),
    );
  }
}
