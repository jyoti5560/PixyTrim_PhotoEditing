import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';
import 'package:pixytrim/controller/previous_session_screen_controller/previous_session_screen_controller.dart';
import 'package:pixytrim/models/collage_screen_model/single_image_file_model.dart';
import 'package:pixytrim/screens/collage_screen/collage_screen.dart';

class CollageSessionScreen extends StatelessWidget {
  CollageSessionScreen({Key? key}) : super(key: key);
  final controller = Get.find<PreviousSessionScreenController>();
  final collageScreenController = Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MainBackgroundWidget(),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  appBar(),
                  const SizedBox(height: 20),
                  Container(
                    child: controller.localCollageList.length == 0
                    ? Center(
                      child: Text(
                        'No Collage Local Data Available',
                        style: TextStyle(fontFamily: ""),
                      ),
                    )
                    : GridView.builder(
                      itemCount: controller.localCollageList.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(File(
                                    '${controller.localCollageList[index]}')),
                              ),
                            ),
                            // child: Image.file(File('${controller.localSessionListNew![index]}')),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
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
                child: Container(
                    child: Image.asset(
                  Images.ic_left_arrow,
                  scale: 2.5,
                )),
              ),
              Container(
                child: Text(
                  "Collage Store",
                  style: TextStyle(
                      fontFamily: "",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Get.back();
                  collageScreenController.imageFileList.clear();
                  for(int i=0; i < controller.localCollageList.length; i++){
                    File file = File('${controller.localCollageList[i]}');
                    XFile xFile = XFile('${file.path}');
                    collageScreenController.imageFileList.add(ImageFileItem(file: xFile));
                  }
                  Get.off(()=> CollageScreen());
                },
                child: Container(
                  child: controller.localCollageList.length == 0 ? null : Icon(Icons.check_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
