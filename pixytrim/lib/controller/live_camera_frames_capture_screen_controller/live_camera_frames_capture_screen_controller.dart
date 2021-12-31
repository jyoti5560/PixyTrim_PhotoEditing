import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixytrim/common/custom_image.dart';

class LiveCameraFramesCaptureScreenController extends GetxController {
  CameraController? controller;
  XFile? imageFile;
  File? newFile;
  RxInt selectedIndex = 0.obs;

  List<String> twoImageLayout = [
    Images.ic_layout1,
    Images.ic_layout2,
    Images.ic_layout27,
  ];

}