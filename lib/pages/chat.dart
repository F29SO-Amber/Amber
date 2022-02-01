import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chatID, required this.chatName}) : super(key: key);

  final String chatID;
  final String chatName;

  static const id = '/chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double lefts = 0;
  double rights = 0;
  Color fieldColor = const Color(0xFF39304d);
  Color textColor = const Color(0xFF1F1A30);
  Color dateColor = Colors.black87;
  final myControllerMsg = TextEditingController();

  Future<void> addData() async {
    await FirebaseFirestore.instance.collection('messages').add({
      'token': '${FirebaseAuth.instance.currentUser!.email}|${widget.chatID}',
      'from': FirebaseAuth.instance.currentUser!.email,
      'to': widget.chatID,
      'time2': DateTime.now(),
      'message': myControllerMsg.text,
    });
    myControllerMsg.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: Colors.amber, // top bar color
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.02),
              child: const CircleAvatar(),
            ),
            Text(
              widget.chatName,
              style:
                  const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0XFFFFF9C4),
        child: Column(
          children: [
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
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.06,
                        right: MediaQuery.of(context).size.width * 0.06),
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        if (FirebaseAuth.instance.currentUser!.email == data['to']) {
                          lefts = 0;
                          rights = 0.2;
                          fieldColor = const Color(0xFF5C6BC0);
                          textColor = Colors.white;
                          dateColor = Colors.white70;
                        } else {
                          lefts = 0.2;
                          rights = 0;
                          fieldColor = const Color(0xFF64B5F6);
                          textColor = const Color(0xFF1F1A30);
                          dateColor = Colors.black87;
                        }
                        DateTime myDateTime = (data['time2']).toDate();

                        return Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                              left: MediaQuery.of(context).size.width * lefts,
                              right: MediaQuery.of(context).size.width * rights),
                          decoration: BoxDecoration(
                            color: fieldColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Text(
                              data['message'],
                              style: TextStyle(color: textColor),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height * 0.008),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat('hh:mm a').format(myDateTime),
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
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: const BoxDecoration(
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
                decoration: const BoxDecoration(
                  color: Color(0xFFFFA726), // message
                  // borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFA726),
                      // blurRadius: blurRadius1,
                      offset: Offset(0, 0), // Shadow position
                    ),
                  ],
                ),
                child: TextField(
                  controller: myControllerMsg,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                      color: Colors.white, height: 1.4, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    // fillColor: field1Color,
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    suffixIcon: InkWell(
                      onTap: () {
                        addData();
                      },
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white70,
                      ),
                    ),
                    hintText: 'Message...',
                    hintStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            )
            // ),
          ],
        ),
      ),
    );
  }
}
