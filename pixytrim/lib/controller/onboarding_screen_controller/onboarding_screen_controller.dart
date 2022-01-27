import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/models/onboarding_screen_model/onboarding_screen_model.dart';
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
      title: 'Welcome to PixyTrim!!',
      description: 'Best and all-in-one photo editor and Collage Maker App For you!! Here,You can edit your photo with latest filters and upload on your social media.',
    ),
    OnBoardingInfo(
      imageAsset: Images.ic_service2,
      title: 'Photo Editing With PixyTrim!!',
      description: "PixyTrim is an app for editing images which lets you alter filters, saturation Brightness, and Contrast. We also allow you to resize and compress images. It's a feature-rich app for you.",
    ),
    OnBoardingInfo(
      imageAsset: Images.ic_service3,
      title: 'Collage Maker With PixyTrim!!',
      description: 'PixyTrim is most effective photo collage maker app. It is among the top photo collage apps that allows users to combine more than one photo using various grids.',
    ),
  ];

  setOnBoardingValue() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    prefs.setBool("onboarding", true);
  }


}