import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as models;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/screens/temp_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
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
    // UserProvider _userProvider=Provider.of(context,listen: false);
    // _userProvider.refreshUser();

    models.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
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
      bottomNavigationBar: CupertinoTabBar(
        //activeColor: Colors.white,
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: _page == 0
                ? Icon(
                    Icons.home,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
            label: "",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: _page == 1
                ? Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 33,
                  )
                : Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
            label: "",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: _page == 2
                ? Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white,
                  ),
            label: "",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: _page == 3
                ? Icon(
                    Icons.favorite,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
            label: "",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: _page == 4
                ? Icon(
                    Icons.person,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
            label: "",
            backgroundColor: Colors.white,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
