import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pixytrim/controller/image_size_ratio_controller/image_size_ratio_controller.dart';

final controller = Get.find<ImageSizeRatioController>();

//1:2 = 0
class SizeRatio1 extends StatelessWidget {
  File file;
  SizeRatio1({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
        height: 270,
        child: PhotoView(
          // enableRotation: true,
          enablePanAlways: true,
          customSize: Size.fromRadius(250),
          imageProvider: FileImage(file),
        ),
    );
  }
}

// 2:3
class SizeRatio2 extends StatelessWidget {
  File file;
  SizeRatio2({required this.file});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 150,
      height: 225,
      child: PhotoView(
        // enableRotation: true,
        enablePanAlways: true,
        customSize: Size.fromRadius(250),
        imageProvider: FileImage(file),
      ),
    );
  }
}

// 3:2
class SizeRatio3 extends StatelessWidget {
  File file;
  SizeRatio3({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 270,
          height: 180,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// 3:4
class SizeRatio4 extends StatelessWidget {
  File file;
  SizeRatio4({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180,
          height: 240,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// 4:3
class SizeRatio5 extends StatelessWidget {
  File file;
  SizeRatio5({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 160,
          height: 120,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// 5:4 = 5
class SizeRatio6 extends StatelessWidget {
  File file;
  SizeRatio6({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 300,
          height: 240,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// 9:16
class SizeRatio7 extends StatelessWidget {
  File file;
  SizeRatio7({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 154.29,
      height: 274.29,
      child: PhotoView(
        // enableRotation: true,
        enablePanAlways: true,
        customSize: Size.fromRadius(250),
        imageProvider: FileImage(file),
      ),
    );
  }
}

// 16:9
class SizeRatio8 extends StatelessWidget {
  File file;
  SizeRatio8({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 274.29,
          height: 154.29,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// a4
class SizeRatio9 extends StatelessWidget {
  File file;
  SizeRatio9({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.57,
      height: 177.14,
      child: PhotoView(
        // enableRotation: true,
        enablePanAlways: true,
        customSize: Size.fromRadius(250),
        imageProvider: FileImage(file),
      ),
    );
  }
}

// a5
class SizeRatio10 extends StatelessWidget {
  File file;
  SizeRatio10({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      height: 174.8,
      child: PhotoView(
        // enableRotation: true,
        enablePanAlways: true,
        customSize: Size.fromRadius(250),
        imageProvider: FileImage(file),
      ),
    );
  }
}

// fb cover phone = 10
class SizeRatio11 extends StatelessWidget {
  File file;
  SizeRatio11({required this.file});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 160,
          height: 90,
          child: PhotoView(
            // enableRotation: true,
            // customSize: Size.fromRadius(50),
            enablePanAlways: true,
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// fb post
class SizeRatio12 extends StatelessWidget {
  File file;
  SizeRatio12({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 300,
          height: 157.5,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// ig story
class SizeRatio13 extends StatelessWidget {
  File file;
  SizeRatio13({required this.file});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 270,
      height: 480,
      child: PhotoView(
        // enableRotation: true,
        enablePanAlways: true,
        customSize: Size.fromRadius(250),
        imageProvider: FileImage(file),
      ),
    );
  }
}

// ig 1:1
class SizeRatio14 extends StatelessWidget {
  File file;
  SizeRatio14({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 270,
          height: 270,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// ig 4:5
class SizeRatio15 extends StatelessWidget {
  File file;
  SizeRatio15({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 270,
          height: 337.5,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// movie = 15
class SizeRatio16 extends StatelessWidget {
  File file;
  SizeRatio16({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 480,
          height: 270,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// pinterest post
class SizeRatio17 extends StatelessWidget {
  File file;
  SizeRatio17({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 183.75,
      height: 275.5,
      child: PhotoView(
        // enableRotation: true,
        enablePanAlways: true,
        customSize: Size.fromRadius(250),
        imageProvider: FileImage(file),
      ),
    );
  }
}

// twitter header
class SizeRatio18 extends StatelessWidget {
  File file;
  SizeRatio18({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 375,
          height: 125,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// twitter post
class SizeRatio19 extends StatelessWidget {
  File file;
  SizeRatio19({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 300,
          height: 168.75,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}

// yt cover = 19
class SizeRatio20 extends StatelessWidget {
  File file;
  SizeRatio20({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 365.71,
          height: 205.71,
          child: PhotoView(
            // enableRotation: true,
            enablePanAlways: true,
            customSize: Size.fromRadius(250),
            imageProvider: FileImage(file),
          ),
        ),
      ],
    );
  }
}
