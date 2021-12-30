import 'dart:async';

import 'package:get/get.dart';
import 'package:pixytrim/screens/index_screen/index_screen.dart';

class SplashScreenController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    print('Splash Controller Init Method');
    Timer(Duration(seconds: 3), () => goToIndexScreen());
  }

  goToIndexScreen()=> Get.offAll(()=> IndexScreen());

}