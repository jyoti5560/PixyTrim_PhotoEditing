import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CollageScreenController extends GetxController{
  RxDouble borderWidthValue = 0.0.obs;
  List<Color> borderColor = [
    Colors.black,
    Colors.grey,
    Colors.green,
    Colors.green,
    Colors.pinkAccent,
    Colors.deepOrange,
    Colors.lightBlueAccent,
    Colors.deepPurpleAccent,
    Colors.yellow,
    Colors.blueAccent
  ];
  RxList<XFile> imageFileList = <XFile>[].obs;
  RxInt activeColor = 0.obs;
  RxBool isLoading = false.obs;
  RxInt selectedIndex = 0.obs;
  RxDouble borderRadiusValue = 0.0.obs;
}