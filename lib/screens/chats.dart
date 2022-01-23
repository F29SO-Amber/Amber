import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amber/constants.dart';
import 'package:amber/screens/chat.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);
  static const id = '/chats';

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  Color field2Color = Color(0xFF1F1A30);
  double blurRadius2 = 0;
  final myControllerPass = TextEditingController();
  DateTime _now = DateTime.now();
  String image_path = '';
  var images_paths;
  var imgaelink;

  @override
  Stream<String> downloadedUrl(String imageName) async* {
    String downloadedUrl =
    await storage.ref('test/$imageName').getDownloadURL();
    yield downloadedUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 15.0,
        foregroundColor: kAppColor,
        backgroundColor: Colors.amber,
        leading: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Image(image: AssetImage('assets/logo.png'),
          ),
        ),
        title: const Text(kAppName,
          style: TextStyle(
            color: Colors.white,
              letterSpacing: 6,
              fontSize: 35.0
          ),
        ),
        actions: <Widget>[
          IconButton(onPressed: (){},
            icon: const Icon(Icons.chat),
            iconSize: 35,
            color:Colors.white ,
          ),
        ],
      ),
      body:  Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0XFFFFF9C4),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('email',
                        isNotEqualTo:
                        FirebaseAuth.instance.currentUser!.email)
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
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.02),
                              decoration: BoxDecoration(
                                color: Color(0XFFFFF59D),
                                borderRadius: BorderRadius.circular(20),
                                /*boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10,
                                    offset: Offset(0, 0), // Shadow position
                                  ),
                                ],*/
                              ),
                              child: ListTile(
                                leading: Container(
                                  height:
                                  MediaQuery.of(context).size.height * 0.06,
                                  width:
                                  MediaQuery.of(context).size.height * 0.06,
                                  child: StreamBuilder(
                                      stream: downloadedUrl('${data['image']}'),
                                      builder: (context,
                                          AsyncSnapshot<String> snap) {
                                        if (snap.hasError) {
                                          return Text("Error");
                                        }
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        imgaelink = snap.data!;
                                        return CircleAvatar(
                                          backgroundImage:
                                          NetworkImage(snap.data!),
                                        );
                                      }),
                                ),
                                title: Text(
                                  data['name'],
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  data['name'],
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "12:00 am",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.008),
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Color(0xFF1F1A30),
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          chatID: data['email'],
                                          chatName: data['name']
                                      )));

                              // print(ref.getDownloadURL().toString());
                              // print("done");
                            },
                          );
                        }).toList(),
                      );
                    },
                ),
              ),
              // ),
            ],
          ),
        ),
      ));
  }

}
