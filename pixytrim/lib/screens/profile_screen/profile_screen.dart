import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/screens/image_editor_screen/_paint_over_image.dart';
import 'package:pixytrim/screens/login_screen/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  //const ProfileScreen({Key? key}) : super(key: key);
  UserCredential ? result;
  ProfileScreen({this.result});
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MainBackgroundWidget(),

            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appBar(context),

                  result != null ?
                  profileDetails() : Container(),

                  Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
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
       // crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Image.network(
                result!.user!.photoURL!,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text('Name: ${result!.user!.displayName}', style: TextStyle(fontSize: 17),),
          SizedBox(height: 10,),
          Text('Email: ${result!.user!.email}', style: TextStyle(fontSize: 17),),
           SizedBox(height: 10,),

          GestureDetector(
            onTap: ()async{
              await googleSignIn.signOut();
              Get.off(() => LoginScreen());
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
                       "Sign Out",
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
