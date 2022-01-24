import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/controller/onboarding_screen_controller/onboarding_screen_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);
  final onBoardingScreenController = Get.put(OnBoardingScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: onBoardingScreenController.pageController,
              onPageChanged: onBoardingScreenController.selectedPageIndex,
              itemCount: onBoardingScreenController.onBoardingPages.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onBoardingScreenController.onBoardingPages[index].imageAsset,
                      height: Get.height * 0.35,),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        onBoardingScreenController.onBoardingPages[index].title,
                        style: const TextStyle(
                          // color: CustomColor.kOrangeColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        onBoardingScreenController.onBoardingPages[index].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 25,
              left: 20,
              child: Row(
                children: List.generate(onBoardingScreenController.onBoardingPages.length,
                      (index) => Obx(() => Container(
                    margin: const EdgeInsets.all(4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: onBoardingScreenController.selectedPageIndex.value == index ? Colors.black : Colors.grey,
                        shape: BoxShape.circle
                    ),
                  ),
                  ),
                ),
              ),
            ),

            Positioned(
              right: 20,
              bottom: 25,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.orange,
                onPressed: onBoardingScreenController.forwardAction,
                child: Obx(()=> Text(onBoardingScreenController.isLastPage ? 'Start' : 'Next')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
