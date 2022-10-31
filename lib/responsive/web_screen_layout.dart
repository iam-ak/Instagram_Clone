import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/models/user.dart' as models;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  int _page = 0;
  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider _userProvider = Provider.of(context, listen: false);
    // _userProvider.refreshUser();
    models.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SvgPicture.asset(
          "assets/images/ic_instagram.svg",
          color: Colors.white,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigationTapped(0);
            },
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            icon: _page == 0
                ? const Icon(
                    Icons.home,
                  )
                : const Icon(
                    Icons.home_outlined,
                  ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(1);
            },
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            icon: _page == 1
                ? const Icon(
                    Icons.search,
                  )
                : const Icon(
                    Icons.search_outlined,
                  ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(2);
            },
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            icon: _page == 2
                ? const Icon(
                    Icons.add_a_photo,
                  )
                : const Icon(
                    Icons.add_a_photo_outlined,
                  ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(3);
            },
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            icon: _page == 3
                ? const Icon(
                    Icons.favorite,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                  ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(4);
            },
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            icon: _page == 4
                ? const Icon(
                    Icons.person,
                  )
                : const Icon(
                    Icons.person_outline_outlined,
                  ),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Center(
            child: Text("notifications"),
          ),
          ProfileScreen(
            user: user,
          ),
        ],
      ),
    );
  }
}
