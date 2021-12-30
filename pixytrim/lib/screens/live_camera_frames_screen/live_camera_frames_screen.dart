import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/controller/live_camera_frames_capture_screen_controller/live_camera_frames_capture_screen_controller.dart';
import 'package:pixytrim/main.dart';
import 'live_camera_frames_capture_screen/live_camera_frames_capture_screen.dart';
import 'live_camera_frames_screen_widgets.dart';

class LiveCameraFramesScreen extends StatefulWidget {
  const LiveCameraFramesScreen({Key? key}) : super(key: key);
  @override
  _LiveCameraFramesScreenState createState() => _LiveCameraFramesScreenState();
}
class _LiveCameraFramesScreenState extends State<LiveCameraFramesScreen> {
  final lCFCScreenController = Get.put(LiveCameraFramesCaptureScreenController());
  // CameraController? controller;


  @override
  void initState() {
    super.initState();
    lCFCScreenController.controller = CameraController(cameras![0], ResolutionPreset.max);
    lCFCScreenController.controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    lCFCScreenController.controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            MainBackgroundWidget(),
            Container(
              child: Column(
                children: [
                  // SizedBox(height: 10),
                  Expanded(child: Container(child: liveCameraShowModule())),
                  // layoutListModule(),
                ],
              ),
            ),

            Positioned(
              bottom: 70,
              // right: 15,
              child: goToNextScreenButton(),
            ),
            layoutListModule(),

          ],
        ),
      ),
    );
  }

  Widget liveCameraShowModule() {
    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: lCFCScreenController.selectedIndex.value == 0
            ? Container(
                child: Row(
                  children: [
                    SingleImageShowModule(),
                    const SizedBox(width: 5),
                    SingleImageShowModule(),
                  ],
                ),
              )
            : lCFCScreenController.selectedIndex.value == 1
                ? Container(
                    child: Column(
                      children: [
                        SingleImageShowModule(),
                        const SizedBox(height: 5),
                        SingleImageShowModule(),
                      ],
                    ),
                  )
                : lCFCScreenController.selectedIndex.value == 2
                    ? Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SingleImageShowModule(),
                                const SizedBox(width: 5),
                                SingleImageShowModule(),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                SingleImageShowModule(),
                                const SizedBox(width: 5),
                                SingleImageShowModule(),
                              ],
                            ),
                          ],
                        ),
                      )
                    : lCFCScreenController.selectedIndex.value == 3
                        ? Container(
                            child: Column(
                              children: [
                                SingleImageShowModule(),
                                const SizedBox(height: 5),
                                SingleImageShowModule(flex: 2),
                              ],
                            ),
                          )
                        : Container(
                            child: Row(
                              children: [
                                SingleImageShowModule(),
                                const SizedBox(width: 5),
                                SingleImageShowModule(flex: 2),
                              ],
                            ),
                          ),
      ),
    );
  }

  Widget layoutListModule() {
    return Container(
      height: Get.height * 0.08,
      child: ListView.builder(
        itemCount: lCFCScreenController.twoImageLayout.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, i){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                lCFCScreenController.selectedIndex.value = i;
                print('index : ${lCFCScreenController.selectedIndex.value}');
              },
              child: Container(
                child: Image.asset(lCFCScreenController.twoImageLayout[i]),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget imageShowModule0() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         SingleImageShowModule(),
  //         const SizedBox(height: 10),
  //         SingleImageShowModule(),
  //       ],
  //     ),
  //   );
  //
  //
  // }

  Widget goToNextScreenButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: liveCameraFramesButtonDecoration(),
      child: IconButton(
        onPressed: () async {
          await onPressedClick();

        },
        icon: Icon(
          Icons.camera_alt_rounded,
          color: Colors.white60,
          size: 30,
        ),
      ),
    );
  }

  Future onPressedClick() async {
    takePicture().then((XFile? file) async {
      if (mounted) {
        setState(() {
          lCFCScreenController.imageFile = file;
        });
        if (lCFCScreenController.imageFile != null){
          lCFCScreenController.newFile = File("${lCFCScreenController.imageFile!.path}");
          Get.to(()=> LiveCameraFramesCaptureScreen());
        }
      }
    });

  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = lCFCScreenController.controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      // showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
  }

  void logError(String code, String? message) {
    if (message != null) {
      print('Error: $code\nError Message: $message');
    } else {
      print('Error: $code');
    }
  }

}
