import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';

class GroupChatHomeScreen extends StatefulWidget {
  // const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  int _index = 0;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
      body: isLoading
          ? Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: groupList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => Navigator.of(context).push,
            leading: Icon(Icons.group),
            title: Text(groupList[index]['name']),
          );
        },
      ),

      backgroundColor: CupertinoColors.systemGrey6,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push,
        tooltip: "Create Group",
      ),
    );
  }
}

class _index {
}
