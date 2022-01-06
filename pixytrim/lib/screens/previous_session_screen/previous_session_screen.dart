import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/previous_session_screen_controller/previous_session_screen_controller.dart';
import 'package:pixytrim/screens/camera_screen/camera_screen.dart';

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
            ()=> Stack(
              children: [
                MainBackgroundWidget(),
                controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Container(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                  child: Column(
                    children: [
                      appBar(context),
                      const SizedBox(height: 20),
                      Container(
                        child: controller.localSessionList.length == 0
                            ? Center(
                          child: Text(
                              'No Local Data Available',
                            style: TextStyle(fontFamily: ""),
                          ),)
                            : GridView.builder(
                          itemCount: controller.localSessionList.length,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              // child: Row(
                              //   children: [
                              //     Container(
                              //       height: 100,
                              //       width: 100,
                              //       child: Image.file(File('${controller.localSessionList![index]}')),
                              //     ),
                              //     const SizedBox(width: 10),
                              //     Expanded(
                              //         child: Text(
                              //             '${controller.localSessionList![index]}',
                              //           maxLines: 3,
                              //           overflow: TextOverflow.ellipsis,
                              //           style: TextStyle(
                              //             fontFamily: "",
                              //           ),
                              //         ),
                              //     ),
                              //   ],
                              // ),
                              child: GestureDetector(
                                onTap: () {
                                  if(controller.localSessionList.isNotEmpty){
                                    Get.off(()=> CameraScreen(), arguments: [File('${controller.localSessionList[index]}'), SelectedModule.gallery]);
                                  }
                                },

                                onLongPress: () {
                                  //todo
                                  deleteSingleImageAlertDialog(context, index);
                                },
                                child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(File('${controller.localSessionList[index]}')),
                                    ),
                                  ),
                                  // child: Image.file(File('${controller.localSessionList![index]}')),
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
                      scale: 2.4,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Previous Session",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {deleteAllImagesAlertDialog(context);},
                  child: Container(
                    child: Icon(Icons.delete_rounded),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  // Delete Alert Dialog Box
  deleteAllImagesAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(fontFamily: ""),),
      onPressed:  () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: TextStyle(fontFamily: ""),),
      onPressed: () async {
        controller.deleteLocalSessionList();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Do you want to delete All Images ?", style: TextStyle(fontFamily: ""),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Delete Single Image Dialog box
  deleteSingleImageAlertDialog(BuildContext context, int index) {

    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(fontFamily: ""),),
      onPressed:  () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: TextStyle(fontFamily: ""),),
      onPressed: () async {
        controller.updateLocalSessionList(index);
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Do you want to delete This Image ?", style: TextStyle(fontFamily: ""),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}