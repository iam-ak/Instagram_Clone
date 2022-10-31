//import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource, BuildContext context) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? xFile = await imagePicker.pickImage(source: imageSource);
  //Uint8List file;
  if (xFile != null) {
    return await xFile.readAsBytes();
  } else {
    if (kDebugMode) {
      print("No Image Selected");
    }
    showSnackbar(context, "Image not selected");
  }
}

showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}
