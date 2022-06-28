import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';

class PDFScreen extends StatelessWidget {
  const PDFScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MainBackgroundWidget(),
            mainFrontEndWidget(),
          ],
        ),
      ),
    );
  }

  Widget mainFrontEndWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          appBar(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget appBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
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
                      // Get.back();
                    },
                    child: Container(child: Icon(Icons.close)),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Image.asset(
                        Images.ic_downloading,
                        scale: 2,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
