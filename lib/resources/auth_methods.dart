// ignore_for_file: unused_import, unnecessary_import

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User user=_firebaseAuth.currentUser!;
    DocumentSnapshot documentSnapshot=await firebaseFirestore.collection("users").doc(user.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List? profileImage,
  }) async {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        bio.isEmpty ||
        profileImage == null) {
      return "All fields are required";
    }
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String downloadUrl = await StorageMethods()
          .uploadImageToStorage("ProfilePics", profileImage, false);

      if (kDebugMode) {
        print(userCredential.user!.uid);
      }
      model.User user = model.User(
          username: username,
          email: email,
          bio: bio,
          uid: userCredential.user!.uid,
          profileImageUrl: downloadUrl,
          followers: [],
          following: []);

      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(
            user.toJson(),
          );

      return "success";
    } on FirebaseAuthException catch(err)
    {
      return err.code;
    }
    catch (err) {
      return err.toString();
    }
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return "All field are required";
    }
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "success";
    } on FirebaseAuthException catch(err)
    {
      return err.code;
    }
    catch (err) {
      return err.toString();
    }
  }

  Future<String> signOutUser() async{
    try{
    await _firebaseAuth.signOut();
    return "success";
    }
    catch(e)
    {
      print(e);
      return e.toString();
    }
  }
}
