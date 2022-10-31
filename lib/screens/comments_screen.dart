import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as models;
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    models.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Comments"),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          child: Row(children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "comment as " + user.username,
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                  controller: controller,
                ),
              ),
            ),
            // IconButton(onPressed: (){}, icon: Icon(Icons.send),)
            InkWell(
              onTap: () {
                FirestoreMethods().addComment(
                    widget.snap['postId'],
                    user.username,
                    controller.text,
                    user.profileImageUrl,
                    user.uid);
                setState(() {
                  controller..text = '';
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CommentsScreen(snap: widget.snap)));
              },
              child: Container(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ),
          ]),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished',)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommentCard(
              commentSnap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
