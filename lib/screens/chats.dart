import 'package:flutter/material.dart';
import 'package:amber/constants.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 15.0,
        foregroundColor: kAppColor,
        backgroundColor: Colors.black,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/logo.png'),
          ),
        ),
        title: const Text(kAppName,
          style: TextStyle(
            fontSize: 35.0
          ),
        ),
        actions: <Widget>[
        IconButton(onPressed: (){},
          icon: const Icon(Icons.chat),
          iconSize: 30,
        ),
        ],
      ),
      body:  Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
          )
        ),
        child: buildChats(),
      ),
    );
  }
  
}

Widget buildChats() =>ListView.builder(
  physics: BouncingScrollPhysics(),
  itemBuilder: (context,index){
    //final users= users[index];
    return Container(
      height: 75.0,
      child: ListTile(
        onTap: (){},
        leading: Image.asset(''),
        title: Text('Name of user'),

      ),
    );
    }
  );

