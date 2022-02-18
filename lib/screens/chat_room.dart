import 'package:firebase_auth/firebase_auth.dart';
import 'package:amber/screens/group_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GroupChatRoom extends StatefulWidget {
  const GroupChatRoom({Key? key, required this.groupChatId, required this.groupName})
      : super(key: key);

  final String groupChatId;
  final String groupName;

  static const id = '/chat';

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  double lefts = 0;
  double rights = 0;
  Color fieldColor = Color(0xFF39304d);
  Color textColor = Color(0xFF1F1A30);
  Color dateColor = Colors.black87;
  double blurRadius2 = 0;
  DateTime _now = DateTime.now();

  // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now1);
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": FirebaseAuth.instance.currentUser!.email,
        'to': widget.groupChatId,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp()
      };
      _message.clear();

      await _firestore
          .collection("groups")
          .doc(widget.groupChatId)
          .collection("chats")
          .add(chatData);
    }
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.amber,
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
              Text("${widget.groupName}",
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
                            groupName: widget.groupName,
                            groupId: widget.groupChatId,
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
                      .doc(widget.groupChatId)
                      .collection("chats")
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      print(snapshot.data!.docs.length);
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else{
                      return Container();
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
                decoration: BoxDecoration(
                  color: Color(0xFF39304d),
                  // borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF39304d),
                      blurRadius: 10,
                      offset: Offset(0, 0), // Shadow position
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1F1A30),
                    // borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF39304d),
                        // blurRadius: blurRadius1,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _message,
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: Colors.white,
                        height: 1.4,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      // fillColor: field1Color,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide.none,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      suffixIcon: InkWell(
                        onTap: () {
                          onSendMessage();
                        },
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white70,
                        ),
                      ),
                      hintText: 'Message...',
                      hintStyle: TextStyle(
                          color: Colors.white60, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
              // ),
            ],
          ),
        ));
  }
  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
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
                color: Colors.pink,
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
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            height: size.height / 2,
            child: Image.network(
              chatMap['message'],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}