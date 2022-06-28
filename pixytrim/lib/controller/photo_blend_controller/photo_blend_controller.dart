import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoBlendController extends GetxController {
  RxDouble borderWidthValue = 0.0.obs;

  Rx<Color> selectedColor = Colors.transparent.obs;
  Rx<BlendMode> blendMode = BlendMode.saturation.obs;

  RxList<String> blendModesList = [
    "clear",
    "color",
    "colorBurn",
    "colorDodge",
    "darken",
    "difference",
    "dst",
    "dstATop",
    "dstIn",
    "dstOut",
    "dstOver",
    "exclusion",
    "hardLight",
    "hue",
    "lighten",
    "luminosity",
    "modulate",
    "multiply",
    "overlay",
    "plus",
    "saturation",
    "screen",
    "softLight",
    "src",
    "srcATop",
    "srcIn",
    "srcOut",
    "srcOver",
    "values",
    "xor",
  ].obs;
}
