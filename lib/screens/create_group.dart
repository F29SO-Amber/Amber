import 'package:amber/screens/Groupscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;
  const CreateGroup({required this.membersList, Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  void createGroup() async {
    isLoading = true;
    String groupId = Uuid().v1();
    await _firestore
        .collection('groups')
        .doc(groupId)
        .set({"members": widget.membersList, "id": groupId});

    for (int i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]["id"];

      await _firestore
          .collection("users")
          .doc(uid)
          .collection("groups")
          .doc(groupId)
          .set({"name": _groupName.text, "id": groupId});
    }
    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "time": FieldValue.serverTimestamp(),
    });
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => GroupChatHomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Group Name"),
      ),
      body: isLoading
          ? Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          SizedBox(
            height: size.height / 10,
          ),
          Container(
            height: size.height / 12,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 12,
              width: size.width / 1.1,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _groupName,
                decoration: InputDecoration(
                    fillColor: Colors.orange,
                    filled: true,
                    hintText: "Enter Group Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.orange)),
              onPressed: () {
                createGroup();
              },
              child: Text(
                "Create Group",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }
}