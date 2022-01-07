import 'package:amber/models/user.dart';
import 'package:amber/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserId;

  const EditProfilePage({Key? key, required this.currentUserId})
      : super(key: key);
  static const id = '/edit_profile';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late AmberUser user;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
  }

  getUser() async {
    DocumentSnapshot doc =
        await DatabaseService.usersRef.doc(widget.currentUserId).get();
    user = AmberUser.fromDocument(doc);
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello'),
    );
  }
}
