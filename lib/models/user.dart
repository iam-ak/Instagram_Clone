// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class User {
  final String username;
  final String email;
  final String bio;
  final String uid;
  final String profileImageUrl;
  final List followers;
  final List following;

  User({
    required this.username,
    required this.email,
    required this.bio,
    required this.uid,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'bio': bio,
      'uid': uid,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
    };
  }

  static User fromSnap(DocumentSnapshot documentSnapshot){
    var snapshot=(documentSnapshot.data() as Map<String, dynamic>);
    User user=User(
      bio: snapshot["bio"],
      email: snapshot["email"],
      username: snapshot["username"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      uid: snapshot["uid"],
      profileImageUrl: snapshot["profileImageUrl"],
    );
    return user;
  }
}
