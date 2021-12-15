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

  List<String> fourImageLayout = [
    Images.ic_layout27,
    Images.ic_layout28,
    Images.ic_layout29,
    Images.ic_layout30,
    Images.ic_layout31,
    Images.ic_layout32,
    Images.ic_layout33,
    Images.ic_layout34,
    Images.ic_layout35,
    Images.ic_layout36,
    Images.ic_layout37,
    Images.ic_layout38,
    Images.ic_layout39,
    Images.ic_layout40,
    Images.ic_layout41,
    Images.ic_layout42,
    Images.ic_layout43,
  ];

  List<String> fiveImageLayout = [
    Images.ic_layout44,
    Images.ic_layout45,
    Images.ic_layout46,
    Images.ic_layout47,
    Images.ic_layout48,
    Images.ic_layout49,
    Images.ic_layout50,
    Images.ic_layout51,
    Images.ic_layout52,
    Images.ic_layout53,
    Images.ic_layout54,
    Images.ic_layout55,
    Images.ic_layout56,
    Images.ic_layout57,
    Images.ic_layout58,
    Images.ic_layout59,
    Images.ic_layout60,
    Images.ic_layout61,
    Images.ic_layout62,
    Images.ic_layout63,
  ];

  List<String> sixImageLayout = [
    Images.ic_layout64,
    Images.ic_layout65,
    Images.ic_layout66,
    Images.ic_layout67,
    Images.ic_layout68,
    Images.ic_layout69,
    Images.ic_layout70,
    Images.ic_layout71,
    Images.ic_layout72,
    Images.ic_layout73,
    Images.ic_layout74,
    Images.ic_layout75,
    Images.ic_layout76,
    Images.ic_layout77,
    Images.ic_layout78,
    Images.ic_layout79,
    Images.ic_layout80,
    Images.ic_layout81,
    Images.ic_layout82,
    Images.ic_layout83,
  ];

  List<String> sevenImageLayout = [
    Images.ic_layout84,
    Images.ic_layout85,
    Images.ic_layout86,
    Images.ic_layout87,
    Images.ic_layout88,
    Images.ic_layout89,
    Images.ic_layout90,
    Images.ic_layout91,
    Images.ic_layout92,
    Images.ic_layout93,
    Images.ic_layout94,
    Images.ic_layout95,
    Images.ic_layout96,
    Images.ic_layout97,
    Images.ic_layout98,
    Images.ic_layout99,
  ];
}