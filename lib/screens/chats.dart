import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:amber/screens/Groupscreen.dart';
import 'package:amber/screens/chat.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
int _index = 0;
final TextEditingController _search = TextEditingController();
class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);
  static const id = '/chats';

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}


class _ChatsPageState extends State<ChatsPage> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        // elevation: 15.0,
        // foregroundColor: kAppColor,
        backgroundColor: Colors.amber,
        leading: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Image(image: AssetImage('assets/logo.png')),
        ),
        title: const Text(
          kAppName,
          style: TextStyle(color: Colors.white, letterSpacing: 6, fontSize: 35.0),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) =>
                      GroupChatHomeScreen(),
                ),
              );
            },
            icon: const Icon(Icons.chat),
            iconSize: 35,
            color: Colors.white,

          ),
        ],

      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.amber.shade50,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
          child: Column(
            children:  [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService.usersRef
                      .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Container(
                      child: Column(
                            children: [
                              SizedBox(
                                height: size.height / 20,
                              ),
                              Container(
                                height: size.height / 14,
                                width: size.width,
                                alignment: Alignment.center,
                                child: Container(
                                  height: size.height / 14,
                                  width: size.width / 1.15,
                                  child: TextField(
                                    controller: _search,
                                    decoration: InputDecoration(
                                      hintText: "Search here",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height / 50,
                              ),
                              ElevatedButton(
                                onPressed: onSearch,
                                child: Text("Search"),
                              ),
                              SizedBox(
                                height: size.height / 30,
                              ),
                              userMap != null
                                  ? ListTile(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatPage(
                                              chatID: 'email',
                                              chatName: 'name'),
                                    ),
                                  );
                                },
                                leading: Icon(Icons.account_box, color: Colors.black),
                                title: Text(
                                  userMap!['name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(userMap!['email']),
                                trailing: Icon(Icons.chat, color: Colors.black),
                              )
                                  : Container(),
                            ]

                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService.usersRef
                      .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return InkWell(
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  width: MediaQuery.of(context).size.height * 0.06,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(data['profilePhotoURL']),
                                  ),
                                ),
                                title: Text(
                                  data['name'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  data['username'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("12:00 am", style: TextStyle(color: Colors.black)),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height * 0.008),
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Color(0xFF1F1A30),
                                        child: Text(
                                          '1',
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(chatID: data['email'], chatName: data['name']),
                                ),
                              );
                            },
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
