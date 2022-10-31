import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: screenWidth >= webScreenSize
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              title: SvgPicture.asset(
                "assets/images/ic_instagram.svg",
                color: Colors.white,
                height: 32,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  icon: const Icon(
                    Icons.messenger_outline_outlined,
                  ),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Padding(
              padding: screenWidth >= webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.3,
                      vertical: 20,
                    )
                  : const EdgeInsets.all(0),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
