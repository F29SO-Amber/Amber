import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../../services/database_service.dart';
import '../../../utilities/constants.dart';
import '../../../widgets/profile_picture.dart';

class Events extends StatelessWidget {
  final String userUID;

  const Events({Key? key, required this.userUID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService.eventsRef
          .where('userID', isEqualTo: userUID)
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomImage(
                                  image: NetworkImage(event.eventPhotoURL),
                                  height: 50,
                                  width: 50,
                                  borderRadius: 5,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${event.title} - ${event.startingTime}',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      event.description,
                                      style: kLightLabelTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: const Icon(Icons.add_alert, size: 30),
                            ),
                          ],
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
    );
  }
}
