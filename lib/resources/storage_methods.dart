// ignore_for_file: unused_import

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference reference = firebaseStorage
        .ref()
        .child(childName)
        .child(FirebaseAuth.instance.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
