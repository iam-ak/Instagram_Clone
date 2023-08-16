import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as models;

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int totalComments = 0;
  @override
  void initState() {
    super.initState();
    getTotalComments();
  }

  getTotalComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        totalComments = querySnapshot.docs.length;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final models.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: screenWidth >= webScreenSize
            ? Border.all(color: Colors.white)
            : Border.all(),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.only(
                start: 16, bottom: 4, top: 4, end: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImageUrl']),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      widget.snap["username"],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      children: [
                        SimpleDialogOption(
                          padding: const EdgeInsets.all(20),
                          onPressed: () {
                            FirestoreMethods()
                                .deletePost(widget.snap['postId']);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "delete",
                          ),
                        ),
                        SimpleDialogOption(
                          padding: const EdgeInsets.all(20),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "save",
                          ),
                        ),
                      ],
                    ),
                    // builder: (context) => Dialog(
                    //   child: ListView(
                    //     padding: EdgeInsets.symmetric(vertical: 16),
                    //     shrinkWrap: true,
                    //     children: [
                    //       "delete",
                    //     ]
                    //         .map((e) => InkWell(
                    //               onTap: () {},
                    //               child: Container(
                    //                 padding: const EdgeInsets.symmetric(
                    //                   vertical: 12,
                    //                   horizontal: 16,
                    //                 ),
                    //                 child: Text(e),
                    //               ),
                    //             ))
                    //         .toList(),
                    //   ),
                    // ),
                  ),
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          InkWell(
            child: AspectRatio(
              aspectRatio: 60 / 40,
              child: Image.network(
                widget.snap['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await FirestoreMethods().likePost(widget.snap['postId'],
                      user?.uid ?? "", widget.snap['likes']);
                },
                icon: widget.snap['likes'].contains(user?.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.white,
                      ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          )));
                },
                icon: const Icon(
                  Icons.comment,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              Flexible(child: Container()),
              IconButton(
                onPressed: () {
                  // setState(() {
                  //   isSaved = !isSaved;
                  // });
                },
                icon:
                    // isSaved
                    //     ? const Icon(Icons.bookmark)
                    //     :
                    const Icon(
                  Icons.bookmark_outline_outlined,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.snap['likes'].length} likes",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "${widget.snap['username']}  ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                          text: widget.snap['caption'],
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ]),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.snap['postId'])
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                  snap: widget.snap,
                                )));
                      },
                      child: snapshot.data!.docs.length == 0
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "View all ${snapshot.data!.docs.length} comments",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
