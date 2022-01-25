import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/models/onboarding_screen_model/onboarding_screen_model.dart';
import 'package:pixytrim/screens/index_screen/index_screen.dart';
import 'package:pixytrim/screens/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreenController extends GetxController {

  var selectedPageIndex = 0.obs;

  var pageController = PageController();
  bool get isLastPage => selectedPageIndex.value == onBoardingPages.length - 1;

  forwardAction() {
    if(isLastPage){
      setOnBoardingValue();
      Get.off(() => LoginScreen());
    } else {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    }
  }

  List<OnBoardingInfo> onBoardingPages= [
    OnBoardingInfo(
      imageAsset: Images.ic_service1,
      title: 'Dummy Text 1',
      description: 'Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text',
    ),
    OnBoardingInfo(
      imageAsset: Images.ic_service2,
      title: 'Dummy Text 2',
      description: 'Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text',
    ),
    OnBoardingInfo(
      imageAsset: Images.ic_service3,
      title: 'Dummy Text 3',
      description: 'Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text Dummy Text',
    ),
  ];

  setOnBoardingValue() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    prefs.setBool("onboarding", true);
  }


}