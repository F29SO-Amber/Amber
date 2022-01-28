import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemPink,
        title: Text("Groups"),
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

      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (int val) {
      //     setState(() {
      //       _index = val;
      //     });
      //     if (val == 0) {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => AddMembersInGroup(),
      //           ));
      //     }
      //     if (val == 1) {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => AddMembersInGroup(),
      //           ));
      //     }
      //     if (val == 2) {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => AddMembersInGroup(),
      //           ));
      //     }
      //     if (val == 3) {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => AddMembersInGroup(),
      //           ));
      //     }
      //   },
      backgroundColor: CupertinoColors.systemGrey6,
      // currentIndex: _index,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.group_outlined,
      //         size: 40.0,
      //         color: Colors.cyan,
      //       ),
      //       label: 'Groups',
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(
      //     //     Icons.contacts_rounded,
      //     //     size: 40.0,
      //     //     color: Colors.cyan,
      //     //   ),
      //     //   label: 'Contacts',
      //     // ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.person_outline_sharp,
      //         size: 40.0,
      //         color: Colors.cyan,
      //       ),
      //       label: 'Create Group',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.logout,
      //         size: 30.0,
      //         color: Colors.cyan,
      //       ),
      //       label: 'LogOut',
      //     ),
      //   ],
      // ),
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
