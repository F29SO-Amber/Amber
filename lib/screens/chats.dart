import 'dart:io';
import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';

class ChatsPage extends StatefulWidget {
  static const id = '/chats';

  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: createRandomColor(),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(kAppName, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: const Center(child: Text('To be implemented!')),
    );
  }
  
}

Widget buildChats() =>ListView.builder(
  physics: BouncingScrollPhysics(),
  itemCount: 25,
  itemBuilder: (context,index){
    //final users= users[index];
    return Container(
      height: 75.0,
      child: ListTile(
        onTap: (){
          Navigator.pushReplacementNamed(context, '/chat2');
          //Navigator.pushNamed(context, '/home2');
         // Navigator.of(context).push(MaterialPageRoute(builder: context)=>ChatPage(user:user))
        },
        leading: Image.asset('assets/img.png'),
        title: Text('Vladamir Putin',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
        tileColor: Colors.black,
      ),
    );
    }
  );

