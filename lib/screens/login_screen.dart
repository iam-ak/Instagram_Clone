import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/screens/temp_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCOntroller = TextEditingController();
  final TextEditingController passCOntroller = TextEditingController();

  bool isLoading = false;
  bool sign_in_error = false;
  String res = "";

  @override
  void dispose() {
    super.dispose();
    emailCOntroller.dispose();
    passCOntroller.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    res = await AuthMethods().signInUser(
      email: emailCOntroller.text,
      password: passCOntroller.text,
    );
    setState(() {
      isLoading = false;
    });
    if (res != "success") {
      sign_in_error = true;
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
  }

  void moveToSignupPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: screenWidth >= webScreenSize
            ? EdgeInsets.symmetric(horizontal: screenWidth * 0.3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                SvgPicture.asset(
                  "assets/images/ic_instagram.svg",
                  color: Colors.white,
                  height: 64,
                ),
                const SizedBox(
                  height: 64,
                ),
                TextFieldInput(
                  textEditingController: emailCOntroller,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  textEditingController: passCOntroller,
                  hintText: "Enter your password",
                  textInputType: TextInputType.emailAddress,
                  isPass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  height: sign_in_error ? 24 : 0,
                  alignment: Alignment.topRight,
                  child: Text(
                    res,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print("this is login button");
                    }
                    loginUser();
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: blueColor),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Dont have an account? "),
                    ),
                    GestureDetector(
                      onTap: () {
                        moveToSignupPage();
                        if (kDebugMode) {
                          print("signup button clicked");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            //color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ]),
      )),
    );
  }
}
