// import 'package:amber/models/user.dart';
// import 'package:amber/screens/profile/profile.dart';
// import 'package:amber/services/auth_service.dart';
// import 'package:amber/services/database_service.dart';
// import 'package:amber/widgets/progress.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class Search extends StatefulWidget {
//   @override
//   static const id = '/searchpage';
//   _SearchState createState() => _SearchState();
// }
//
// class _SearchState extends State<Search> {
//   TextEditingController searchController = TextEditingController();
//   Future<QuerySnapshot>? searchResultsFuture;
//   handleSearch(String query) {
//     final start = query.substring(0, query.length - 1);
//     final end = query.characters.last;
//     final limit = start + String.fromCharCode(end.codeUnitAt(0) + 1);
//
//     final users = DatabaseService.usersRef
//         .where('username', isGreaterThanOrEqualTo: query)
//         .where('username', isLessThan: limit)
//         .get();
//
//     setState(() {
//       searchResultsFuture = users;
//     });
//   }
//
//   clearSearch() {
//     searchController.clear();
//   }
//
//   AppBar buildSearchField() {
//     return AppBar(
//       backgroundColor: Colors.amber,
//       title: TextFormField(
//         controller: searchController,
//         decoration: InputDecoration(
//           fillColor: Colors.white,
//           hintText: "Search for a user...",
//           filled: true,
//           prefixIcon: Icon(
//             Icons.account_box,
//             size: 28.0,
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(Icons.clear),
//             onPressed: clearSearch,
//           ),
//         ),
//         onFieldSubmitted: handleSearch,
//       ),
//     );
//   }
//
//   Container buildNoContent() {
//     return Container(
//       child: Center(
//         child: ListView(
//           shrinkWrap: true,
//           children: <Widget>[
//             Text(
//               "Find Users",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontStyle: FontStyle.italic,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 60.0),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   buildSearchResults() {
//     return FutureBuilder(
//       future: searchResultsFuture,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return circularProgress();
//         }
//         List<UserResult> searchResults = [];
//         //if (snapshot.connectionState == ConnectionState.done) {
//         for (var doc in (snapshot.data! as QuerySnapshot).docs) {
//           UserModel user = UserModel.fromDocument(doc);
//           if (user.id != AuthService.currentUser.uid) {
//             UserResult searchResult = UserResult(user);
//             searchResults.add(searchResult);
//           }
//         }
//         //}
//         return ListView(
//           children: searchResults,
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: buildSearchField(),
//       body: searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
//     );
//   }
// }
//
// class UserResult extends StatelessWidget {
//   final UserModel user;
//   UserResult(this.user);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: <Widget>[
//           GestureDetector(
//             // onTap: () => print("tapped"),
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => ProfilePage(userUID: user.id)));
//             },
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 backgroundImage: CachedNetworkImageProvider(user.imageUrl),
//               ),
//               title: Text(
//                 user.firstName,
//                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 user.username,
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ),
//           Divider(
//             height: 2.0,
//             color: Colors.black,
//           )
//         ],
//       ),
//     );
//   }
// }
