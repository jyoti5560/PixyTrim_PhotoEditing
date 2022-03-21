import 'dart:async';

import 'package:get/get.dart';
import 'package:pixytrim/screens/index_screen/index_screen.dart';
import 'package:pixytrim/screens/login_screen/login_screen.dart';
import 'package:pixytrim/screens/onboarding_screen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController{
  bool onBoardingValue = false;
  // bool isLogin = false;
  String userId = "";


  @override
  void onInit() {
    super.onInit();
    print('Splash Controller Init Method');
    Timer(Duration(seconds: 1), () => getOnBoardingValue());
  }

  getOnBoardingValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    onBoardingValue = prefs.getBool("onboarding") ?? false;
    userId = prefs.getString('userId') ?? '';


    if(onBoardingValue == true) {
      //Get.off(() => LoginScreen());
      if(userId.isNotEmpty){
        Get.off(() => IndexScreen());
      } else{
        Get.off(() => LoginScreen());
      }
    }
    else{
      Get.off(() => OnBoardingScreen());
    }
  }

}