// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/models/user.dart' as models;
import 'package:instagram_clone/screens/profile_screen.dart';

class FollowersScreen extends StatefulWidget {
  models.User? user;
  FollowersScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.user?.username??""),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.get('followers').length == 0) {
              return Container();
            }
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid',
                      whereIn: models.User.fromSnap(
                              snapshot.data as DocumentSnapshot<Object?>)
                          .followers)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                user: models.User.fromSnap(
                                    snapshot.data!.docs[index])),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data!.docs[index].get('profileImageUrl')),
                      ),
                      title:
                          Text(snapshot.data!.docs[index].data()['username']),
                      subtitle:
                          Text(snapshot.data!.docs[index].data()['email']),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
