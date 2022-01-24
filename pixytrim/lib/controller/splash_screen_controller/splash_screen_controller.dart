import 'dart:async';

import 'package:get/get.dart';
import 'package:pixytrim/screens/index_screen/index_screen.dart';
import 'package:pixytrim/screens/onboarding_screen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController{
  bool? onBoardingValue = false;


  @override
  void onInit() {
    super.onInit();
    print('Splash Controller Init Method');
    Timer(Duration(seconds: 1), () => getOnBoardingValue());
  }

  getOnBoardingValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    onBoardingValue = prefs.getBool("onboarding");

    if(onBoardingValue == true) {
      Get.off(() => IndexScreen());
    }
    else{
      Get.off(() => OnBoardingScreen());
    }
  }

}