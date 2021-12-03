import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraScreenController extends GetxController{
  RxDouble compressSize = 61.0.obs;
  //RxList<File> file = <File>[].obs;
  RxList<File> compressFile = <File>[].obs;
}