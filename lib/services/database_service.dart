import 'dart:io';

import 'package:amber/models/post.dart';
import 'package:amber/models/user.dart';
import 'package:amber/pages/login.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/widgets/post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final usersRef = _firestore.collection('users');
  static final postsRef = _firestore.collection('posts');
  static final eventsRef = _firestore.collection('events');
  static final messagesRef = _firestore.collection('messages');
  static final hashtagsRef = _firestore.collection('hashtags');
  static final commentsRef = _firestore.collection('comments');
  static final followersRef = _firestore.collection('followers');
  static final followingRef = _firestore.collection('following');
  static final communityRef = _firestore.collection('community');
  static late String usernameresult;

  static Future<UserModel> getUser(String uid) async {
    return UserModel.fromDocument(await usersRef.doc(uid).get());
  }

  static Future<String?> isUserValueUnique(String username) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').where('username', isEqualTo: username).get();

    LoginScreen.temp = snapshot.docs.isEmpty ? null : 'Nope';
  }

  static addUserData(SignupData data) {
    Map<String, dynamic> map = {};
    map.addAll({
      'id': AuthService.currentUser.uid,
      'email': '${data.name}',
      'time_created': Timestamp.now(),
      'profilePhotoURL':
          'https://firebasestorage.googleapis.com/v0/b/f29so-group-5-amber.appspot.com/o/images%2Fsnapchat-bitmoji-featured.jpeg?alt=media&token=99a93201-9511-48c1-9420-0aa3ea6a2cb7',
    });
    data.additionalSignupData?.forEach((key, value) {
      map.addAll({key: value});
    });
    usersRef.doc(AuthService.currentUser.uid).set(map);
  }

  static Future<List<UserPost>> getUserPosts(String uid) async {
    List<UserPost> posts = [];
    posts.addAll(
      ((await DatabaseService.postsRef
                  .where('authorId', isEqualTo: uid)
                  .orderBy('timestamp', descending: true)
                  .get())
              .docs)
          .map(
        (e) => UserPost(post: PostModel.fromDocument(e)),
      ),
    );
    return posts;
  }

  static Future<void> addUserPost(file, caption, location) async {
    Map<String, Object?> map = {};
    String postID = const Uuid().v4();
    UserModel user = await getUser(AuthService.currentUser.uid);
    // File compressedFile = await ImageService.compressImageFile(file, postID);
    map['id'] = postID;
    map['location'] = location;
    map['imageURL'] = await StorageService.uploadImage(postID, file);
    map['caption'] = caption;
    map['likes'] = {};
    map['authorId'] = AuthService.currentUser.uid;
    map['timestamp'] = Timestamp.now();
    map['authorName'] = user.name;
    map['authorUserName'] = user.username;
    map['authorProfilePhotoURL'] = user.profilePhotoURL;
    await DatabaseService.postsRef.doc(postID).set(map);
  }

  static Future<List<UserPost>> getUserFeed() async {
    QuerySnapshot followingUsers =
        await followingRef.doc(AuthService.currentUser.uid).collection('userFollowing').get();

    List<UserPost> posts = [];
    List<String> following = followingUsers.docs.map((e) => e.id).toList();
    for (String userID in following) {
      posts.addAll(
        ((await postsRef.where('authorId', isEqualTo: userID).get()).docs).map(
          (e) => UserPost(post: PostModel.fromDocument(e)),
        ),
      );
    }
    return posts;
  }

  static Future<void> addUserComment(comment, postID) async {
    UserModel user = await getUser(AuthService.currentUser.uid);
    Map<String, Object?> map = {};
    map['username'] = user.username;
    map['text'] = comment;
    map['timestamp'] = Timestamp.now();
    map['profilePhotoURL'] = user.profilePhotoURL;
    await DatabaseService.commentsRef.doc(postID).collection('comments').doc().set(map);
  }

  static Future<List<UserModel>> getFollowersUIDs(String id) async {
    QuerySnapshot followers =
        await DatabaseService.followersRef.doc(id).collection('userFollowers').get();

    List ids = followers.docs.map((e) => (e.id)).toList();
    List<UserModel> users = [];
    for (String x in ids) {
      users.add(await DatabaseService.getUser(x));
    }
    return users;
  }

  static Future<List<UserModel>> getFollowingUID(String id) async {
    QuerySnapshot following =
        await DatabaseService.followingRef.doc(id).collection('userFollowing').get();

    List ids = following.docs.map((e) => (e.id)).toList();
    List<UserModel> users = [];
    for (String x in ids) {
      users.add(await DatabaseService.getUser(x));
    }
    return users;
  }
}
