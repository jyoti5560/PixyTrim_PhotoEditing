import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/splash_screen_controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  SplashScreenController splashScreenController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: Get.height,
            child: Image.asset(Images.ic_background1, fit: BoxFit.cover,),
          ),
          Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(Images.ic_logo, scale: 3,),

              ),
              SizedBox(height: 20,),

              Container(
                child: Text("Pixy Trim", style: TextStyle(fontSize: 50),),
              )
            ],
          )

        ],
      ),
    );
  }
}
