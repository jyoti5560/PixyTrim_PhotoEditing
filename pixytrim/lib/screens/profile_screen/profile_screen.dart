import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/profile_screen_controller/profile_screen_controller.dart';
import 'package:pixytrim/screens/image_editor_screen/_paint_over_image.dart';
import 'package:pixytrim/screens/login_screen/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  //const ProfileScreen({Key? key}) : super(key: key);
  UserCredential ? result;
  ProfileScreen({this.result});
  final GoogleSignIn googleSignIn = GoogleSignIn();
  ProfileScreenController profileScreenController = Get.put(ProfileScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>
      profileScreenController.isLoading.value ?
        Center(child: CircularProgressIndicator()) :
         SafeArea(
          child: Stack(
            children: [
              MainBackgroundWidget(),

              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    appBar(context),


                    profileDetails(),

                    Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: borderGradientDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: containerBackgroundGradient(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  child: Image.asset(
                    Images.ic_left_arrow,
                    scale: 2.4,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontFamily: "",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget profileDetails(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profileScreenController.uPhotoUrl!.isNotEmpty?
          ClipOval(
            child: Image.network(
              profileScreenController.uPhotoUrl!
            ),
          ) : ClipOval(
            child: Image.asset(
                Images.ic_logo, scale: 7,
            ),
          ),
          SizedBox(height: 10,),
           Text(profileScreenController.uName!.isNotEmpty ? 'Name: ${profileScreenController.uName}' : 'Name: john', style: TextStyle(fontSize: 17),),
          SizedBox(height: 10,),
          profileScreenController.uEmail!.isNotEmpty ? Text('Email: ${profileScreenController.uEmail}', style: TextStyle(fontSize: 17),) :
          Text('Email: john@gmail.com', style: TextStyle(fontSize: 17),),
          SizedBox(height: 10,),

          GestureDetector(
            onTap: () async {
               googleSignIn.signOut();
              await profileScreenController.clearUserDetails();
              Get.back();
              //Get.off(() => LoginScreen());
            },
            child: Container(
              height: 50,
              width: Get.width/2.5,
              decoration: borderGradientDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: containerBackgroundGradient(),
                 child: Center(
                   child: Container(
                     child: Text(
                       profileScreenController.userId!.isNotEmpty ? "Sign Out" : "Sign In",
                       style: TextStyle(
                         fontFamily: "",
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                 ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
