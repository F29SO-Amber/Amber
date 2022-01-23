import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:amber/models/user.dart';
import 'package:amber/screens/profile.dart';
import 'package:amber/widgets/user_card.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';

class DiscoverPage extends StatefulWidget {
  static const id = '/discover';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

/*
  Discover Page helps users to discover various other users and communities that
  they might be interested in following or having a glance at.
*/
class _DiscoverPageState extends State<DiscoverPage> {
  List<String> welcomeImages = [
    "assets/camera.png",
    "assets/gellery.png",
    "assets/img.png",
    "assets/logo.png",
  ];

  @override
  Widget build(BuildContext context) {
    final SwipingCardDeck deck = SwipingCardDeck(
      cardDeck: getCardDeck(),
      onDeckEmpty: () => debugPrint("Card deck empty"),
      onLeftSwipe: (Card card) => debugPrint("Swiped left!"),
      onRightSwipe: (Card card) => debugPrint("Swiped right!"),
      cardWidth: 200,
      swipeThreshold: MediaQuery.of(context).size.width / 3,
      minimumVelocity: 1000,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber, //sets the color to amber
        title: const Text(kAppName), //Title of the app
      ),
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              deck,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    iconSize: 30,
                    color: Colors.red,
                    onPressed: deck.animationActive ? null : () => deck.swipeLeft(),
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(Icons.check),
                    iconSize: 30,
                    color: Colors.green,
                    onPressed: deck.animationActive ? null : () => deck.swipeRight(),
                  ),
                ],
              ),
            ],
          ),
          FutureBuilder(
            future: DatabaseService.usersRef.get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //Show a list of the current users in the app
              List<UserCard> list = [];
              snapshot.data?.docs.forEach((doc) {
                UserModel user = UserModel.fromDocument(doc);
                if (user.id != AuthService.currentUser.uid) {
                  list.add(
                    UserCard(
                      user: user,
                      onPress: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProfilePage(userUID: user.id)));
                      },
                    ),
                  );
                }
              });
              return ListView(children: list);
            },
          ),
        ],
      ),
    );
  }
}

List<Card> getCardDeck() {
  List<Card> cardDeck = [];
  for (int i = 0; i < 500; ++i) {
    cardDeck.add(
      Card(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          child: const SizedBox(height: 300, width: 200)),
    );
  }
  return cardDeck;
}
