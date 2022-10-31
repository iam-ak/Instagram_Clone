// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/followers_screen.dart';
import 'package:instagram_clone/screens/following_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:provider/provider.dart';

import 'package:instagram_clone/models/user.dart' as models;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/view_post_screen.dart';
import 'package:instagram_clone/widgets/post_card.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  models.User user;
  ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String text = "Sign Out";
  var icon = Icons.edit;
  // Color backColor = Color.fromARGB(255, 57, 54, 54);
  Color backColor = Colors.black;
  Color textColor = Colors.white;
  Color iconColor = Colors.white;
  Color borderColor = Colors.white;
  int totalPosts = 0;
  int followers = 0;
  int following = 0;
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.user.uid)
          .get();
      setState(() {
        totalPosts = querySnapshot.docs.length;
        followers = widget.user.followers.length;
        following = widget.user.following.length;
      });
      if (widget.user.uid == FirebaseAuth.instance.currentUser!.uid) {
        return;
      }
      if (widget.user.followers.contains(currentUserUid)) {
        text = 'Unfollow';
        icon = Icons.person;
        backColor = Colors.white;
        textColor = Colors.black;
        iconColor = Colors.black;
        borderColor = Colors.black;
      } else {
        text = 'follow';
        icon = Icons.add_box;
        backColor = Colors.blueAccent;
        textColor = Colors.black;
        iconColor = Colors.black;
        borderColor = Colors.black;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.user.email,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.user.profileImageUrl),
                            radius: 32,
                          ),
                          SizedBox(width: 32),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  totalPosts.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("posts"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FollowersScreen(user: widget.user)));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data!
                                        .get('followers')
                                        .length
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("followers"),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FollowingScreen(user: widget.user)));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data!
                                        .get('following')
                                        .length
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("following"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Text(
                                    widget.user.username,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                  ),
                                  child: Text(
                                    widget.user.bio,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () async {
                                  if (text == 'Sign Out') {
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             EditProfile()));
                                    String res =
                                        await AuthMethods().signOutUser();
                                    if (res == 'success') {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    }
                                  } else {
                                    if (snapshot.data!
                                        .get('followers')
                                        .contains(currentUserUid)) {
                                      FirestoreMethods().removeFollower(
                                          currentUserUid, widget.user.uid);
                                      setState(() {
                                        text = 'follow';
                                        icon = Icons.add_box;
                                        backColor = Colors.blueAccent;
                                        textColor = Colors.black;
                                        iconColor = Colors.black;
                                        borderColor = Colors.black;
                                      });
                                    } else {
                                      FirestoreMethods().addFollower(
                                          currentUserUid, widget.user.uid);
                                      setState(() {
                                        text = 'Unfollow';
                                        icon = Icons.person;
                                        backColor = Colors.white;
                                        textColor = Colors.black;
                                        iconColor = Colors.black;
                                        borderColor = Colors.black;
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: backColor,
                                    border: Border.all(
                                      color: borderColor,
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 32,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              text,
                                              style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Icon(icon,
                                              size: 20, color: iconColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
          const Divider(
            color: Colors.grey,
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .where('uid', isEqualTo: widget.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:  screenWidth>=webScreenSize?4: 3,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewPostScreen(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          ));
                        },
                        child: Card(
                          child: GridTile(
                            child: Image.network(
                              snapshot.data!.docs[index].data()['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
