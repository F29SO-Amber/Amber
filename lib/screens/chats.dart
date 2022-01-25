import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:amber/pages/chat.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);
  static const id = '/chats';

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
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
            children: [
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
