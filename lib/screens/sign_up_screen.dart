// ignore_for_file: unnecessary_import

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/temp_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/dimensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailCOntroller = TextEditingController();
  final TextEditingController passCOntroller = TextEditingController();
  final TextEditingController usernameCOntroller = TextEditingController();
  final TextEditingController bioCOntroller = TextEditingController();

  bool isLoading = false;
  bool sign_up_error = false;
  String res = "";

  Uint8List? image;

  @override
  void dispose() {
    super.dispose();
    emailCOntroller.dispose();
    passCOntroller.dispose();
    usernameCOntroller.dispose();
    bioCOntroller.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery, context);
    setState(() {
      image = im;
    });
  }

  void signUp() async {
    setState(() {
      isLoading = true;
    });

    res = await AuthMethods().signUpUser(
      username: usernameCOntroller.text,
      email: emailCOntroller.text,
      password: passCOntroller.text,
      bio: bioCOntroller.text,
      profileImage: image,
    );
    if (kDebugMode) {
      print(res);
    }

    setState(() {
      isLoading = false;
    });
    if (res != "success") {
      sign_up_error = true;
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
  }

  void moveToLoginPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Container(),
                ),
                SvgPicture.asset(
                  "assets/images/ic_instagram.svg",
                  color: Colors.white,
                  height: 64,
                ),
                const SizedBox(
                  height: 32,
                ),
                Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage(
                              "assets/images/default_profile.png",
                            ),
                            backgroundColor: Colors.transparent,
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(image!),
                            backgroundColor: Colors.transparent,
                          ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.blue,
                          )),
                    )
                  ],
                ),
                // CircleAvatar(
                //   child: SvgPicture.asset("assets/images/profile.svg"),
                //   ),

                const SizedBox(
                  height: 24,
                ),

                TextFieldInput(
                  textEditingController: usernameCOntroller,
                  hintText: "Enter your username",
                  textInputType: TextInputType.text,
                ),

                const SizedBox(
                  height: 24,
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
                TextFieldInput(
                  textEditingController: bioCOntroller,
                  hintText: "Enter your bio",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
                ),

                Container(
                  height: sign_up_error ? 24 : 0,
                  child: Text(
                    res.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                  alignment: Alignment.topRight,
                ),

                InkWell(
                  onTap: signUp,
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
                            // backgroundColor: Colors.white,
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Already have an account? ",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        moveToLoginPage();
                        if (kDebugMode) {
                          print("login button clicked");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Login",
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
