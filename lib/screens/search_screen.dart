import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/view_post_screen.dart';

import '../models/user.dart' as models;
import '../utils/dimensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController textEditingController;

  bool showUsers = false;
  @override
  void initState() {
    super.initState();
    textEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: screenWidth >= webScreenSize
            ? EdgeInsets.symmetric(horizontal: screenWidth * 0.2)
            : const EdgeInsets.symmetric(horizontal: 0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextField(
            decoration: InputDecoration(
              fillColor: Color.fromARGB(255, 52, 48, 48),
              filled: true,
              border: InputBorder.none,
              hintText: "search",
              prefixIcon: Icon(Icons.search),
            ),
            controller: textEditingController,
            onChanged: (value) {
              if (value == '') {
                setState(() {
                  showUsers = false;
                });
              } else {
                setState(() {
                  showUsers = true;
                });
              }
            },
          ),
        ),
        body: showUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: textEditingController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
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
                          backgroundImage: NetworkImage(snapshot.data!.docs[index]
                              .data()['profileImageUrl']),
                        ),
                        title:
                            Text(snapshot.data!.docs[index].data()['username']),
                        subtitle:
                            Text(snapshot.data!.docs[index].data()['email']),
                      );
                    },
                  );
                },
              )
            : Column(children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenWidth>=webScreenSize?4: 3),
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
              ]),
      ),
    );
  }
}
