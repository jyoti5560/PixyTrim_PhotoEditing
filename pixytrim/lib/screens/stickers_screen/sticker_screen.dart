import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_simple_sticker_view/flutter_simple_sticker_view.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';

class StickerScreen extends StatefulWidget {
  const StickerScreen({Key? key}) : super(key: key);

  @override
  _StickerScreenState createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {
  // FlutterSimpleStickerView _stickerView = FlutterSimpleStickerView(
  //   Container(
  //     decoration: BoxDecoration(
  //         color: Colors.red,
  //         image: DecorationImage(
  //             fit: BoxFit.cover,
  //             image: NetworkImage(
  //                 "https://images.unsplash.com/photo-1544032527-042957c6f7ce?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"))),
  //   ),
  //   [
  //     Image.asset("assets/images/icons8-superman-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-captain-america-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-avengers-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-iron-man-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-batman-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-thor-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-venom-head-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-homer-simpson-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-spider-man-head-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-harry-potter-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-genie-lamp-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-cyborg-50.png", scale: 0.5),
  //     Image.asset("assets/images/icons8-one-ring-50.png", scale: 0.5),
  //   ],
  //   stickerSize: 150.0,
  //   // panelHeight: 150,
  //   // panelBackgroundColor: Colors.blue,
  //   // panelStickerBackgroundColor: Colors.pink,
  //   // panelStickercrossAxisCount: 4,
  //   // panelStickerAspectRatio: 1.0,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MainBackgroundWidget(),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Column(
                children: [
                  appBar(),
                  SizedBox(height: 20),

                  //_stickerView
                  // Container(
                  //   child: Expanded(
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(20),
                  //       child: Container(
                  //         padding: EdgeInsets.only(left: 10, right: 10, bottom: 0.5),
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //           color: Colors.black26,
                  //         ),
                  //
                  //         // child: Obx(
                  //         //       () => Row(
                  //         //     mainAxisAlignment: MainAxisAlignment.center,
                  //         //     children: List.generate(
                  //         //       cameraScreenController.addImageFromCameraList.length,
                  //         //           (index) => Container(
                  //         //         width: 30,
                  //         //         height: 30,
                  //         //         child: Image.file(
                  //         //           cameraScreenController
                  //         //               .addImageFromCameraList[index],
                  //         //           fit: BoxFit.cover,
                  //         //         ),
                  //         //       ),
                  //         //     ),
                  //         //   ),
                  //         // ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
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
                      Get.back();
                    },
                    child: Container(child: Icon(Icons.close)),
                  ),
                  Container(
                    child: Text(
                      "Sticker",
                      style: TextStyle(
                          fontFamily: "",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      //await _capturePng();
                      // saveImage();
                      Get.back();
                    },
                    child: Container(child: Icon(Icons.check_rounded)),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
