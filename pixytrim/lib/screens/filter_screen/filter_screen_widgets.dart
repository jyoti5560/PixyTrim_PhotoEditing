import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';

final controller = Get.find<CameraScreenController>();

Widget noFilterList({required double width, required double height, required BoxFit fit}){
  return Obx(
        ()=> Container(
      width: width,
      height: height,
      child: Image.file(controller.addImageFromCameraList[controller.selectedImage.value],
        width: width,
        height: height,
        fit: fit,
      ),
    ),
  );
}

Widget filter1List({required double width, required double height, required BoxFit fit}){
  return Obx(
        ()=> Container(
      width: width,
      height: height,
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix([
          0.9,0.5,0.1,0.0,0.0,
          0.3,0.8,0.1,0.0,0.0,
          0.2,0.3,0.5,0.0,0.0,
          0.0,0.0,0.0,1.0,0.0
        ]),
        child: Image.file(
          controller.addImageFromCameraList[controller.selectedImage.value],
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    ),
  );
}