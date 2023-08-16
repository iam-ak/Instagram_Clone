import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  TextEditingController captionController = TextEditingController();
  void postImage(
    String uid,
    String username,
    String profileImageUrl,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        captionController.text,
        _file!,
        uid,
        username,
        profileImageUrl,
      );
      if (res == "success") {
        setState(() {
          _file = null;
          captionController.text = "";
        });
        showSnackbar(context, "Posted!");
      } else {
        showSnackbar(context, res);
      }
    } catch (err) {
      showSnackbar(context, err.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List image = await pickImage(
                    ImageSource.camera,
                    context,
                  );
                  setState(() {
                    _file = image;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List image = await pickImage(
                    ImageSource.gallery,
                    context,
                  );
                  setState(() {
                    _file = image;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                size: 40,
              ),
              onPressed: () {
                selectImage(context);
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _file = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text("New Post"),
              actions: [
                IconButton(
                  onPressed: () => postImage(user?.uid ?? "",
                      user?.username ?? "", user?.profileImageUrl ?? ""),
                  icon: const Icon(
                    Icons.check,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                isLoading ? const LinearProgressIndicator() : Container(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(user?.profileImageUrl ?? ""),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        controller: captionController,
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 50,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}
