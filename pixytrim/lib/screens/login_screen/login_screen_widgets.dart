import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/login_screen_controller/login_screen_controller.dart';
import 'package:pixytrim/screens/index_screen/index_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class welcomeText extends StatelessWidget {
  const welcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image.asset(Images.ic_logo, scale: 5,),
        ),
        SizedBox(height: 15,),
        Container(
          child: Text(
            "Welcome to PixyTrim",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35, fontFamily: "Lemon Jelly", fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class socialLogin extends StatefulWidget {


  @override
  _socialLoginState createState() => _socialLoginState();
}

class _socialLoginState extends State<socialLogin> {
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _imageUrl;
  String? _email;
  final loginScreenController = Get.find<LoginScreenController>();
  //bool ? isLogin = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            loginScreenController.googleAuthentication(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: 60,
              width: Get.width/1.4,
              decoration: borderGradientDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: containerBackgroundGradient(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.ic_google,
                        scale: 2.5,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Login With Google",
                        style: TextStyle(
                          fontFamily: "",
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: ()async {

            //facebookAuthentication(context);
            _onPressedLogInButton().then((value) {
              if(loginScreenController.profile!.userId.isNotEmpty){

                Get.to(() => IndexScreen());
              }

            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: 60,
              width: Get.width/1.4,
              decoration: borderGradientDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: containerBackgroundGradient(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.ic_facebook,
                        scale: 2.5,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Login With Facebook",
                        style: TextStyle(
                          fontFamily: "",
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),

        GestureDetector(
          onTap: (){
            Get.to(() => IndexScreen());
          },
          child: Container(
            child: Text("Skip", style: TextStyle(
              fontFamily: "", fontSize: 19, decoration: TextDecoration.underline
            ),),
          ),
        )
      ],
    );
  }



  Future<void> _onPressedLogInButton() async {
    await loginScreenController.plugin.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email,
        ],
    );
    await loginScreenController.updateLoginInfo();
    await loginScreenController.plugin.logOut();
  }

}
