import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
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
            MainBackgroundWidget(),
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
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        onBoardingScreenController.onBoardingPages[index].title,
                        maxLines: 1,
                        style: const TextStyle(
                          // color: CustomColor.kOrangeColor,
                          fontFamily: "Lemon Jelly",
                          fontSize: 33,
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
                        style: const TextStyle(fontSize: 15, fontFamily: ""),
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
                        color: onBoardingScreenController.selectedPageIndex.value == index
                            ? AppColor.kBorderGradientColor2
                            : Colors.grey.shade200,
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
                backgroundColor: AppColor.kBorderGradientColor2,
                onPressed: onBoardingScreenController.forwardAction,
                child: Container(
                  decoration: serviceBorderGradientDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: serviceContainerDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Obx(
                              ()=> Center(
                                child: Text(
                            onBoardingScreenController.isLastPage
                                  ? 'Start'
                                  : 'Next',
                            maxLines: 1,
                            style: TextStyle(
                                  fontFamily: "",
                                  color: Colors.black
                            ),
                          ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
