// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final String imageUrl;
  final String postId;
  final String profImageUrl;
  final datePublished;
  final String postUrl;
  final likes;
  final comments;

  Post({
    required this.caption,
    required this.imageUrl,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
    required this.uid,
    required this.username,
    required this.profImageUrl,
    required this.comments,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'caption': caption,
      'uid': uid,
      'username': username,
      'imageUrl': imageUrl,
      'postId': postId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'likes': likes,
      'profImageUrl': profImageUrl,
      'comments': comments,
    };
  }

  static Post fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = (documentSnapshot.data() as Map<String, dynamic>);
    Post post = Post(
      caption: snapshot['caption'],
      datePublished: snapshot['datePublished'],
      imageUrl: snapshot['imageUrl'],
      likes: snapshot['likes'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      profImageUrl: snapshot['profileImageUrl'],
      comments: snapshot['comments'],
    );
    return post;
  }
}
