import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:amber/models/community.dart';
import 'package:amber/pages/community.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';

class Communities extends StatelessWidget {
  final String userUID;

  const Communities({Key? key, required this.userUID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService.communityRef.where('ownerID', isEqualTo: userUID).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
          var list = (snapshot.data as QuerySnapshot).docs.toList();
          return list.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 120.0),
                  child: Center(child: Text('No communities to display!')),
                )
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(10).copyWith(bottom: 30),
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    CommunityModel community = CommunityModel.fromDocument(list[index]);
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
    );
  }
}
