import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/live_camera_frames_capture_screen_controller/live_camera_frames_capture_screen_controller.dart';

class LiveCameraFramesCaptureScreen extends StatelessWidget {
  // File imgPath;
  LiveCameraFramesCaptureScreen({/*required this.imgPath,*/Key? key}) : super(key: key);
  final lCFCScreenController = Get.find<LiveCameraFramesCaptureScreenController>();
  final GlobalKey repaintKey = GlobalKey();
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            MainBackgroundWidget(),

            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  appBar(),
                  SizedBox(height: 20),
                  Expanded(
                    child: RepaintBoundary(
                      key: repaintKey,
                      child: Container(
                        child: imageShowModule(),
                      ),
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


  Widget imageShowModule() {
    return Container(
      child: lCFCScreenController.selectedIndex.value == 0
      ? Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              child: Image.file(lCFCScreenController.newFile!),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              child: Image.file(lCFCScreenController.newFile!),
            ),
          ),
        ],
      )
      : lCFCScreenController.selectedIndex.value == 1
      ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              child: Image.file(lCFCScreenController.newFile!),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              child: Image.file(lCFCScreenController.newFile!),
            ),
          ),
        ],
      )
      : Column(
        children: [
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Image.file(lCFCScreenController.newFile!),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Container(
                      child: Image.file(lCFCScreenController.newFile!),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Image.file(lCFCScreenController.newFile!),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Container(
                      child: Image.file(lCFCScreenController.newFile!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageSaveButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: liveCameraFramesButtonDecoration(),
      child: IconButton(
        onPressed: () async {
          await imageSaveFunction();
        },
        icon: Icon(
          Icons.check_rounded,
          color: Colors.white60,
          size: 30,
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
                  child: Container(child: Icon(Icons.close)),
                ),
                GestureDetector(
                  onTap: () async {
                    await imageSaveFunction();
                  },
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
    );
  }
  Future imageSaveFunction() async {
    try {
      print('inside');
      DateTime time = DateTime.now();
      String photoName = "${time.day}_${time.month}_${time.year}_${time.hour}_${time.minute}_${time.second}";
      RenderRepaintBoundary boundary =
      repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print(boundary);
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      print("image:===$image");
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      print("byte data:===$byteData");
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/$photoName.jpg');
      await imgFile.writeAsBytes(pngBytes);
      file = imgFile;
      await saveImage(file!.path);
    } catch (e) {
      print('Collage Saving Error : $e');
    }
  }
  Future saveImage(String filePath) async {
    await GallerySaver.saveImage("$filePath",
        albumName: "LiveCameraPhotoFrames");
    print('Path : $filePath');
    Fluttertoast.showToast(msg: 'Photo Saved at $filePath');
  }

}
