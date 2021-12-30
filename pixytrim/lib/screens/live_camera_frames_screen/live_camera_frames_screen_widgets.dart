import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/controller/live_camera_frames_capture_screen_controller/live_camera_frames_capture_screen_controller.dart';



class SingleImageShowModule extends StatelessWidget {
  int? flex;
  SingleImageShowModule({this.flex,Key? key}) : super(key: key);
  final lCFCScreenController = Get.find<LiveCameraFramesCaptureScreenController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Container(
        decoration: BoxDecoration(

        ),
        child:CameraPreview(lCFCScreenController.controller!),
      ),
    );
  }
}
