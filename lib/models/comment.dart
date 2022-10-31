import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String postId;
  final datePublished;
  final String comment;
  final String profileImageUrl;
  final likes;
  final String commentId;
  final String uid;

  Comment({
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.comment,
    required this.profileImageUrl,
    required this.likes,
    required this.commentId,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'postId': postId,
      'datePublished': datePublished,
      'comment': comment,
      'profileImageUrl': profileImageUrl,
      'likes':likes,
      'commentId': commentId,
      'uid': uid,
    };
  }

  static Comment fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = (documentSnapshot.data() as Map<String, dynamic>);
    Comment commentt = Comment(
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      username: snapshot['username'],
      comment: snapshot['comments'],
      profileImageUrl: snapshot['profileImageUrl'],
      likes: 'likes',
      commentId: 'commentId',
      uid: 'uid',
    );
    return commentt;
  }
}
