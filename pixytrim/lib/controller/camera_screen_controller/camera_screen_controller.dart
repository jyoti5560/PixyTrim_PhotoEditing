import 'dart:io';
import 'package:get/get.dart';

class CameraScreenController extends GetxController{
  final selectedModule = Get.arguments;
  RxDouble compressSize = 61.0.obs;
  //RxList<File> file = <File>[].obs;
  RxList<File> compressFile = <File>[].obs;
}