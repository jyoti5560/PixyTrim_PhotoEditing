import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';

final collageScreenController = Get.find<CollageScreenController>();

BoxDecoration collageMainImageBoxDecoration() {
  return BoxDecoration(
    color: collageScreenController
        .borderColor[collageScreenController.activeColor.value],
    image: collageScreenController.isActiveWallpaper.value ?
    DecorationImage(
      image: AssetImage("${collageScreenController.wallpapers[collageScreenController.activeWallpaper.value]}"),
      fit: BoxFit.fill,
    ) : null,
  );
}