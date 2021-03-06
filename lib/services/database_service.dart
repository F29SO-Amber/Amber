import 'dart:io';

import 'package:amber/models/community.dart';
import 'package:amber/models/post.dart';
import 'package:amber/models/user.dart';
import 'package:amber/screens/auth/login.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/widgets/feed_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final usersRef = _firestore.collection('users');
  static final postsRef = _firestore.collection('posts');
  static final roomsRef = _firestore.collection('rooms');
  static final eventsRef = _firestore.collection('events');
  static final articlesRef = _firestore.collection('articles');
  static final messagesRef = _firestore.collection('messages');
  static final hashtagsRef = _firestore.collection('hashtags');
  static final commentsRef = _firestore.collection('comments');
  static final timelineRef = _firestore.collection('timeline');
  static final followersRef = _firestore.collection('followers');
  static final followingRef = _firestore.collection('following');
  static final communityRef = _firestore.collection('community');
  static final thumbnailsRef = _firestore.collection('thumbnails');

  static Future<UserModel> getUser(String uid) async {
    return UserModel.fromDocument(await usersRef.doc(uid).get());
  }

  static Future<CommunityModel> getCommunity(String uid) async {
    return CommunityModel.fromDocument(await communityRef.doc(uid).get());
  }

  static addUserData(SignupData data) {
    Map<String, dynamic> map = {};
    map.addAll({
      'id': AuthService.currentUser.uid,
      'email': '${data.name}',
      'timeCreated': Timestamp.now(),
      'role': 'user',
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/f29so-group-5-amber.appspot.com/o/turkish-van.png?alt=media&token=6b90c135-6065-4e91-a4da-470a0d889842',
    });
    data.additionalSignupData?.forEach((key, value) {
      map.addAll({key: value});
    });
    usersRef.doc(AuthService.currentUser.uid).set(map);
  }

  static Future<List<FeedEntity>> getUserPosts(String coll, String id) async {
    List<FeedEntity> posts = [];
    posts.addAll(
      ((await DatabaseService.postsRef
                  .where(coll, isEqualTo: id)
                  .orderBy('timestamp', descending: true)
                  .get())
              .docs)
          .map(
        (e) => FeedEntity(feedEntity: PostModel.fromDocument(e)),
      ),
    );
    return posts;
  }

  static Future<List<FeedEntity>> getUserThumbnails(String coll, String id) async {
    List<FeedEntity> posts = [];
    posts.addAll(
      ((await DatabaseService.postsRef
                  .where(coll, isEqualTo: id)
                  .orderBy('timestamp', descending: true)
                  .get())
              .docs)
          .map(
        (e) => FeedEntity(feedEntity: PostModel.fromDocument(e)),
      ),
    );
    return posts;
  }

  static Future<List<FeedEntity>> getUserFeed() async {
    QuerySnapshot followingUsers =
        await followingRef.doc(AuthService.currentUser.uid).collection('userFollowing').get();

    List<FeedEntity> posts = [];
    List<String> following = followingUsers.docs.map((e) => e.id).toList();
    for (String userID in following) {
      posts.addAll(
        ((await postsRef.where('authorId', isEqualTo: userID).get()).docs).map(
          (e) => FeedEntity(feedEntity: PostModel.fromDocument(e)),
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
    map['profilePhotoURL'] = user.imageUrl;
    await DatabaseService.commentsRef.doc(postID).collection('comments').doc().set(map);
  }

  static Future<List<CommunityModel>> getUserCommunities(String id) async {
    QuerySnapshot communityIDs = await DatabaseService.followingRef
        .doc(AuthService.currentUser.uid)
        .collection('userCommunities')
        .get();

    List ids = communityIDs.docs.map((e) => (e.id)).toList();
    List<CommunityModel> communities = [];
    for (String x in ids) {
      communities.add(await DatabaseService.getCommunity(x));
    }
    return communities;
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
