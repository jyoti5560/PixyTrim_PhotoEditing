import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/previous_session_screen_controller/previous_session_screen_controller.dart';

import '../../common/custom_color.dart';
import '../camera_screen/camera_screen.dart';
import 'collage_session_screen/collage_session_screen.dart';

class PreviousSessionScreen extends StatelessWidget {
  PreviousSessionScreen({Key? key}) : super(key: key);
  final controller = Get.put(PreviousSessionScreenController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Obx(
            () => Stack(
              children: [
                MainBackgroundWidget(),
                controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 20),
                        child: Column(
                          children: [
                            appBar(context),
                            const SizedBox(height: 20),
                            collageImagesPreviousSessionModule(),
                            const SizedBox(height: 20),
                            Container(
                              child: controller.localSessionListNew.length == 0
                                  ? Center(
                                      child: Text(
                                        'No Local Data Available',
                                        style: TextStyle(fontFamily: ""),
                                      ),
                                    )
                                  : GridView.builder(
                                      itemCount:
                                          controller.localSessionListNew.length,
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
                                          child: GestureDetector(
                                            onTap: () {
                                              if (controller.localSessionListNew
                                                  .isNotEmpty) {
                                                Get.off(() => CameraScreen(),
                                                    arguments: [
                                                      File(
                                                          '${controller.localSessionListNew[index]}'),
                                                      SelectedModule.gallery
                                                    ]);
                                              }
                                            },
                                            onLongPress: () {
                                              deleteSingleImageAlertDialog(
                                                  context, index);
                                            },
                                            child: Container(
                                              height: 75,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                // borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: FileImage(File(
                                                      '${controller.localSessionListNew[index]}')),
                                                ),
                                              ),
                                              // child: Image.file(File('${controller.localSessionListNew![index]}')),
                                            ),
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
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
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
                  child: Container(
                    child: Image.asset(
                      Images.ic_left_arrow,
                      scale: 2.4,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Draft",
                    style: TextStyle(
                      fontFamily: "",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    deleteAllImagesAlertDialog(context);
                  },
                  child: controller.localSessionListNew.length == 0
                      ? Container()
                      : Container(
                          child: Icon(Icons.delete_rounded),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Delete Alert Dialog Box
  deleteAllImagesAlertDialog(BuildContext context) {
    Widget cancelButton = IconsButton(
      onPressed: () {
        Get.back();
      },
      text: 'No',
      color: AppColor.kBorderGradientColor3,
      textStyle: TextStyle(color: Colors.white),
    );

    Widget continueButton = IconsButton(
      onPressed: () async {
        controller.deleteLocalSessionList();
      },
      text: 'yes',
      color: AppColor.kBorderGradientColor1,
      textStyle: TextStyle(color: Colors.white),
    );

    Dialogs.materialDialog(
      lottieBuilder: LottieBuilder.asset(
        "assets/lotties/9511-loading.json",
      ),
      color: Colors.white,
      msg: "Do you want to delete all the images ?",
      msgStyle: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      context: context,
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }

  // Delete Single Image Dialog box
  deleteSingleImageAlertDialog(BuildContext context, int index) {
    Widget cancelButton = IconsButton(
      onPressed: () {
        Get.back();
      },
      text: 'No',
      color: AppColor.kBorderGradientColor3,
      textStyle: TextStyle(color: Colors.white),
    );

    Widget continueButton = IconsButton(
      onPressed: () async {
        controller.updateLocalSessionList(index);
        Get.back();
      },
      text: 'yes',
      color: AppColor.kBorderGradientColor1,
      textStyle: TextStyle(color: Colors.white),
    );

    Dialogs.materialDialog(
      lottieBuilder: LottieBuilder.asset(
        "assets/lotties/9511-loading.json",
      ),
      color: Colors.white,
      msg: "Do you want to delete the image ?",
      msgStyle: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      context: context,
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }

  collageImagesPreviousSessionModule() {
    return GestureDetector(
      onTap: () {
        Get.to(() => CollageSessionScreen());
      },
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: containerBackgroundGradient(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Collage Draft',
                  style: TextStyle(
                    fontFamily: "",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
