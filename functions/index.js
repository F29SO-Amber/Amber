const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.onCreateFollower = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onCreate(async (snapshot, context) => {
    console.log("Follower Created", snapshot.id);
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // 1) Create followed users posts ref
    const followedUserPostsRef = admin
      .firestore()
      .collection("posts")
      .where("authorId", "==", userId);

    const followedUserThumbnailsRef = admin
      .firestore()
      .collection("thumbnails")
      .where("authorId", "==", userId);

    const followedUserArticlesRef = admin
      .firestore()
      .collection("articles")
      .where("authorId", "==", userId);

    // 2) Create following user's timeline ref
    const timelinePostsRef = admin
      .firestore()
      .collection("timeline")
      .doc(followerId)
      .collection("timelinePosts");

    const timelineThumbnailsRef = admin
      .firestore()
      .collection("timeline")
      .doc(followerId)
      .collection("timelineThumbnails");

    const timelineArticlesRef = admin
      .firestore()
      .collection("timeline")
      .doc(followerId)
      .collection("timelineArticles");

    // 3) Get followed users posts
    const postsQuerySnapshot = await followedUserPostsRef.get();
    const articlesQuerySnapshot = await followedUserArticlesRef.get();
    const thumbnailsQuerySnapshot = await followedUserThumbnailsRef.get();

    // 4) Add each user post to following user's timeline
    postsQuerySnapshot.forEach(doc => {
      if (doc.exists) {
        const postId = doc.id;
        const postData = doc.data();
        timelinePostsRef.doc(postId).set(postData);
      }
    });

    articlesQuerySnapshot.forEach(doc => {
      if (doc.exists) {
        const articleId = doc.id;
        const articleData = doc.data();
        timelineArticlesRef.doc(articleId).set(articleData);
      }
    });

    thumbnailsQuerySnapshot.forEach(doc => {
      if (doc.exists) {
        const thumbnailId = doc.id;
        const thumbnailData = doc.data();
        timelineThumbnailsRef.doc(thumbnailId).set(thumbnailData);
      }
    });
  });

exports.onDeleteFollower = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onDelete(async (snapshot, context) => {
    console.log("Follower Deleted", snapshot.id);
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // Get posts of the user being unfollowed
    const timelinePostsRef = admin
          .firestore()
          .collection("timeline")
          .doc(followerId)
          .collection("timelinePosts")
          .where("authorId", "==", userId);

    // 3) Get timeline users posts
    const querySnapshot = await timelinePostsRef.get();

    // 4) Delete the selected posts
    querySnapshot.forEach(doc => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  })