// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:instagram_clone/models/user.dart' as models;
// import 'package:instagram_clone/providers/user_provider.dart';
// import 'package:instagram_clone/screens/view_post_screen.dart';
// import 'package:instagram_clone/widgets/post_card.dart';

// class OtherProfileScreen extends StatefulWidget {
//   models.User user;
//   OtherProfileScreen({
//     Key? key,
//     required this.user,
//   }) : super(key: key);

//   @override
//   State<OtherProfileScreen> createState() => _OtherProfileScreenState();
// }

// class _OtherProfileScreenState extends State<OtherProfileScreen> {
//   int totalPosts = 0;
//   @override
//   void initState() {
//     super.initState();
//     getTotalPostsLength();
//   }

//   getTotalPostsLength() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('posts').get();
//       setState(() {
//         totalPosts = querySnapshot.docs.length;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           widget. user.email,
//         ),
//         actions: [
//           IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(user.profileImageUrl),
//                   radius: 32,
//                 ),
//                 SizedBox(width: 32),
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     children: [
//                       Text(
//                         totalPosts.toString(),
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text("posts"),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     children: [
//                       Text(
//                         "150",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text("followers"),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     children: [
//                       Text(
//                         "130",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text("following"),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 16,
//               right: 16,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 8,
//                   ),
//                   child: Text(
//                     user.username,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 4,
//                   ),
//                   child: Text(
//                     user.bio,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const Divider(
//             color: Colors.grey,
//             height: 20,
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection("posts")
//                   .orderBy('datePublished', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 return GridView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3),
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => ViewPostScreen(
//                               snap: snapshot.data!.docs[index].data(),
//                             ),
//                           ));
//                         },
//                         child: Card(
//                           child: GridTile(
//                             child: Image.network(
//                               snapshot.data!.docs[index].data()['imageUrl'],
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       );
//                     });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
