import 'package:amber/screens/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class GroupChatRoom extends StatelessWidget {
  final String groupChatId;
  final String groupName;
  double lefts = 0;
  double rights = 0;
  Color fieldColor = Color(0xFF39304d);
  Color textColor = Color(0xFF1F1A30);
  Color dateColor = Colors.black87;
  DateTime _now = DateTime.now();
  GroupChatRoom({required this.groupName, required this.groupChatId, Key? key})
      : super(key: key);

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": FirebaseAuth.instance.currentUser!.email,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp()
      };
      _message.clear();

      await _firestore
          .collection("groups")
          .doc(groupChatId)
          .collection("chats")
          .add(chatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        titleSpacing: 0.0,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery
                      .of(context)
                      .size
                      .height * 0.02),
              child: CircleAvatar(
              ),
            ),
            Text("${groupName}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GroupInfo(
                          groupName: groupName,
                          groupId: groupChatId,
                        )));
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        color: Colors.amber.shade50,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("groups")
                    .doc(groupChatId)
                    .collection('chats')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.docs.length);
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> chatMap =
                          snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                          return messageTile(size, chatMap);
                        });
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.06,
                          right: MediaQuery
                              .of(context)
                              .size
                              .width * 0.06),
                      child: ListView(
                        reverse: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                          if (FirebaseAuth.instance.currentUser!.email ==
                              data['to']) {
                            lefts = 0;
                            rights = 0.2;
                            fieldColor = Color(0xFF39304d);
                            textColor = Colors.white;
                            dateColor = Colors.white70;
                          } else {
                            lefts = 0.2;
                            rights = 0;
                            fieldColor = Color(0xFF0CF6E3);
                            textColor = Color(0xFF1F1A30);
                            dateColor = Colors.black87;
                          }
                          DateTime myDateTime = (data['time2']).toDate();

                          return Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.02,
                                left: MediaQuery
                                    .of(context)
                                    .size
                                    .width * lefts,
                                right:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width * rights),
                            decoration: BoxDecoration(
                              color: fieldColor,
                              borderRadius: BorderRadius.circular(20),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Color(0xFF39304d),
                              //     blurRadius: 10,
                              //     offset: Offset(0, 0), // Shadow position
                              //   ),
                              // ],
                            ),
                            child: ListTile(
                              title: Text(
                                data['message'],
                                style: TextStyle(color: textColor),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery
                                        .of(context)
                                        .size
                                        .height *
                                        0.008),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      // DateTime.parse(timestamp.toDate().toString()),
                                      "${DateFormat('hh:mm a').format(
                                          myDateTime)}",
                                      style: TextStyle(color: dateColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .width * 0.15,
                child: Row(
                  children: [
                    Container(
                      width: size.width / 1.2,
                      height: size.height / 12,
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _message,
                        decoration: InputDecoration(
                            fillColor: Colors.orange,
                            filled: true,
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.image,
                                  color: Colors.black,
                                )),
                            hintText: "Type Message",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          onSendMessage();
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.black,
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    if (chatMap['type'] == "text") {
      return Container(
        width: size.width,
        alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.orange,
            ),
            child: Column(
              children: [
                Text(
                  chatMap['sendBy'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: size.height / 200,
                ),
                Text(
                  chatMap['message'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      );
    }  else {
      return SizedBox();
    };
  }
}
