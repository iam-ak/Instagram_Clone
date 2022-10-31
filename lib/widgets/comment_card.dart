import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/comment.dart' as models;
import 'package:instagram_clone/models/user.dart' as models;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final commentSnap;
  const CommentCard({super.key, required this.commentSnap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    models.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage:
                NetworkImage(widget.commentSnap['profileImageUrl']),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.commentSnap['username'] + " ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                          text: widget.commentSnap['comment'],
                          style: TextStyle(
                            color: Colors.white,
                          ))
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text(
                          DateFormat.yMMMd().format(
                              widget.commentSnap['datePublished'].toDate()),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.commentSnap['likes'].length.toString() +
                              " likes",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              FirestoreMethods().likeComment(
                  widget.commentSnap['postId'],
                  widget.commentSnap['uid'],
                  widget.commentSnap['commentId'],
                  widget.commentSnap['likes']);
            },
            icon: widget.commentSnap['likes'].contains(user.uid)
                ? Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  )
                : Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
          ),
        ],
      ),
    );
  }
}
