import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixytrim/common/custom_image.dart';

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

  List<String> twoImageLayout = [
    Images.ic_layout1,
    Images.ic_layout2,
    Images.ic_layout3,
    Images.ic_layout4,
    Images.ic_layout5,
    Images.ic_layout6,
    Images.ic_layout7,
    Images.ic_layout8,
    Images.ic_layout9,
    Images.ic_layout10,
    Images.ic_layout11,
    Images.ic_layout12,
  ];

  List<String> threeImageLayout = [
    Images.ic_layout13,
    Images.ic_layout14,
    Images.ic_layout15,
    Images.ic_layout16,
    Images.ic_layout17,
    Images.ic_layout18,
    Images.ic_layout19,
    Images.ic_layout20,
    Images.ic_layout21,
    Images.ic_layout22,
    Images.ic_layout23,
    Images.ic_layout24,
    Images.ic_layout25,
    Images.ic_layout26,
  ];
}