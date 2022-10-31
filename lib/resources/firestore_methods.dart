import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/comment.dart' as models;
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    Uint8List image,
    String uid,
    String username,
    String profileImageUrl,
  ) async {
    String res = "";
    try {
      String imageUrl =
          await StorageMethods().uploadImageToStorage("posts", image, true);
      String postId = const Uuid().v1();
      Post post = new Post(
        caption: caption,
        imageUrl: imageUrl,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: imageUrl,
        likes: [],
        uid: uid,
        username: username,
        profImageUrl: profileImageUrl,
        comments: [],
      );
      await firestore.collection("posts").doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String userId, List like) async {
    try {
      if (like.contains(userId)) {
        await firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([userId])
        });
      } else {
        await firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> addComment(String postId, String username, String comment,
      String profileImageUrl, String uid) async {
    if (comment.isEmpty) {
      print("Enter text");
      return "Enter text";
    }
    String commentId = Uuid().v1();
    models.Comment commentt = new models.Comment(
      username: username,
      postId: postId,
      datePublished: DateTime.now(),
      comment: comment,
      profileImageUrl: profileImageUrl,
      likes: [],
      commentId: commentId,
      uid: uid,
    );
    String res;
    try {
      await firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .set(commentt.toJson());
      firestore.collection("posts").doc(postId).update({
        'comments': FieldValue.arrayUnion([commentId])
      });
      res = "success";
      print(res);
      return res;
    } catch (e) {
      res = e.toString();
      print(res);
      return res;
    }
  }

  Future<void> likeComment(
      String postId, String uid, String commentId, List like) async {
    try {
      if (like.contains(FirebaseAuth.instance.currentUser!.uid)) {
        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          'likes':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          'likes':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFollower(String currentUserUid, String uid) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'followers': FieldValue.arrayRemove([currentUserUid])
      });
      await firestore.collection('users').doc(currentUserUid).update({
        'following': FieldValue.arrayRemove([uid])
      });
    } catch (e) {
      print(e);
    }
  }
  Future<void> addFollower(String currentUserUid, String uid) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'followers': FieldValue.arrayUnion([currentUserUid])
      });
      await firestore.collection('users').doc(currentUserUid).update({
        'following': FieldValue.arrayUnion([uid])
      });
    } catch (e) {
      print(e);
    }
  }
}
