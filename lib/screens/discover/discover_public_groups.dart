import 'package:amber/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../services/database_service.dart';
import '../../utilities/constants.dart';
import '../../widgets/profile_picture.dart';

class DiscoverPublicGroups extends StatelessWidget {
  static const id = '/discover_public_groups';

  const DiscoverPublicGroups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      body: StreamBuilder(
        stream: DatabaseService.roomsRef
            .where("type", isEqualTo: "group")
            // .where('metadata', isNotEqualTo: {'createdBy': UserData.currentUser!.id})
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = (snapshot.data as QuerySnapshot).docs.toList();
            return list.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 120.0),
                    child: Center(child: Text('No public groups to display!')),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(10).copyWith(bottom: 30),
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomImage(
                                    image: NetworkImage(list[index]['imageUrl']),
                                    height: 50,
                                    width: 50,
                                    borderRadius: 5,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        list[index]['name'],
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      Text(
                                        '${list[index]['userIds'].length} members',
                                        style: kLightLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: const Icon(Icons.add_circle, size: 30),
                                onTap: () async {
                                  List users = list[index]['userIds'].toList();
                                  users.add(UserData.currentUser!.id);
                                  await DatabaseService.roomsRef
                                      .doc(list[index].id)
                                      .update({'userIds': users});
                                  EasyLoading.showSuccess('Success!');
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
