import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chatID})
      : super(key: key);
  final String chatID;

  static const id = '/chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double lefts = 0;
  double rights = 0;
  Color fieldColor = Color(0xFF39304d);
  Color textColor = Color(0xFF1F1A30);
  Color dateColor = Colors.black87;
  double blurRadius2 = 0;
  final myControllerMsg = TextEditingController();
  DateTime _now = DateTime.now();
  // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now1);

  // FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Color(0xFF1F1A30),
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.height * 0.02),
                child: CircleAvatar(
                ),
              ),
              Text("Texts",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF1F1A30),
          child: Column(
            children: [
              // SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: EdgeInsets.only(
              //       bottom: MediaQuery.of(context).size.height * 0,
              //       top: MediaQuery.of(context).size.height * 0.005),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: Padding(
              //       padding: EdgeInsets.only(
              //           top: MediaQuery.of(context).size.width * 0.06,
              //           left: MediaQuery.of(context).size.width * 0.06),
              //       // child: Text("${widget.chatmanname}",
              //       //     style: TextStyle(
              //       //         color: Colors.white,
              //       //         fontWeight: FontWeight.bold,
              //       //         fontSize: 30)),
              //     ),
              //   ),
              // ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .where('token', whereIn: [
                    '${FirebaseAuth.instance.currentUser!.email}|${widget.chatID}',
                    '${widget.chatID}|${FirebaseAuth.instance.currentUser!.email}'
                  ])
                      .orderBy('time2', descending: true)
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

                    // var kk ;

                    return Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.06,
                          right: MediaQuery.of(context).size.width * 0.06),
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
                                top: MediaQuery.of(context).size.height * 0.02,
                                left: MediaQuery.of(context).size.width * lefts,
                                right:
                                MediaQuery.of(context).size.width * rights),
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
                                    bottom: MediaQuery.of(context).size.height *
                                        0.008),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      // DateTime.parse(timestamp.toDate().toString()),
                                      "${DateFormat('hh:mm a').format(myDateTime)}",
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
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.15,
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
                    controller: myControllerMsg,
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
}
