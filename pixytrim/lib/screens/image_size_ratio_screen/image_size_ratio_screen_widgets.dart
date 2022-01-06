import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/controller/image_size_ratio_controller/image_size_ratio_controller.dart';

final controller = Get.find<ImageSizeRatioController>();

//1:2
class SizeRatio1 extends StatelessWidget {
  File file;
  SizeRatio1({required this.file});

  @override
  Widget build(BuildContext context) {
    /*return Container(
      child: AspectRatio(
        aspectRatio: 1 / 2,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Container(
      child: AspectRatio(
        aspectRatio: 1.0 / 2.0,
        child: Image(
          image: FileImage(file),
          fit: BoxFit.cover, // use this
        ),
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
    /*return Container(
      width: Get.width / 1.2,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Container(
      child: AspectRatio(
        aspectRatio: 2.0 / 3.0,
        child: Image(
          image: FileImage(file),

          fit: BoxFit.cover, // use this
        ),
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
    /*return Container(
      padding: EdgeInsets.only(top: 40, bottom: 40),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20),
      //     border: Border.all(color: Colors.grey)
      // ),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 3.0 / 2.0,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover,
            ),
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
    /*return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      //width: Get.width,
      child: Container(
        width: Get.width / 1.3,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Image.file(controller.file, fit: BoxFit.cover),
        ),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 3.0 / 4.0,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover, // use this
            ),
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
    /*return Container(
      width: Get.width / 1.2,
      padding: EdgeInsets.only(top: 30, bottom: 30),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 4.0 / 3.0,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover, // use this
            ),
          ),
        ),
      ],
    );
  }
}

// 5:4
class SizeRatio6 extends StatelessWidget {
  File file;
  SizeRatio6({required this.file});

  @override
  Widget build(BuildContext context) {
    /*return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: AspectRatio(
        aspectRatio: 5 / 4,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 5.0 / 4.0,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover, // use this
            ),
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
    /*return Container(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Container(
      child: AspectRatio(
        aspectRatio: 9.0 / 16.0,
        child: Image(
          image: FileImage(file),

          fit: BoxFit.cover, // use this
        ),
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
    /*return Container(
      padding: EdgeInsets.symmetric(vertical: 120),
      child: AspectRatio(
        aspectRatio: 20 / 5,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover, // use this
            ),
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
    // return Container(
    //   width: Get.width / 1.2,
    //   child: AspectRatio(
    //     aspectRatio: 1 / 1.41,
    //     child: Image.file(controller.file, fit: BoxFit.cover),
    //   ),
    // );
    return Container(
      child: AspectRatio(
        aspectRatio: 1.0 / 1.41,
        child: Image(
          image: FileImage(file),

          fit: BoxFit.cover, // use this
        ),
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
   /* return Container(
      padding: EdgeInsets.only(top: 30, bottom: 30),
      width: Get.width / 1.3,
      child: AspectRatio(
        aspectRatio: 1 / 1.41,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Container(
      child: AspectRatio(
        aspectRatio: 42.0 / 59.5,
        child: Image(
          image: FileImage(file),

          fit: BoxFit.cover, // use this
        ),
      ),
    );
  }
}

// fb cover
class SizeRatio11 extends StatelessWidget {
  File file;
  SizeRatio11({required this.file});
  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onScaleStart: (ScaleStartDetails details) {
    //     print(details);
    //     controller.previousScale = controller.scale;
    //   },
    //   onScaleUpdate: (ScaleUpdateDetails details) {
    //     print(details);
    //     controller.scale = controller.previousScale * details.scale;
    //     setState(() {});
    //   },
    //   onScaleEnd: (ScaleEndDetails details) {
    //     print(details);
    //     controller.previousScale = 1.0;
    //   },
    //   child: Container(
    //     padding: EdgeInsets.symmetric(vertical: 180),
    //     child: AspectRatio(
    //       aspectRatio: 8 / 3,
    //       child: Transform(
    //         transform: Matrix4.diagonal3(Vector3(controller.scale, controller.scale, controller.scale)),
    //         child: Image.file(controller.file, fit: BoxFit.cover),
    //       ),
    //     ),
    //   ),
    // );
    /*return Container(
      padding: EdgeInsets.symmetric(vertical: 200),
      child: AspectRatio(
        aspectRatio: 14 / 2,
        child: Image.file(controller.file,),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: AspectRatio(
            aspectRatio: 2.7 / 1,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover, // use this
            ),
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
    // return Container(
    //   padding: EdgeInsets.only(top: 100, bottom: 100),
    //   child: AspectRatio(
    //     aspectRatio: 1.91 / 1,
    //     child: Image.file(controller.file, fit: BoxFit.cover),
    //   ),
    // );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: AspectRatio(
            aspectRatio: 1.91 / 1,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover, // use this
            ),
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
    /*return Container(
      width: Get.width / 1.4,
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Container(
      child: AspectRatio(
        aspectRatio: 9.0 / 16.0,
        child: Image(
          image: FileImage(file),

          fit: BoxFit.cover, // use this
        ),
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
    /*return Container(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 1.0 /1.0,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover, // use this
            ),
          ),
        )
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
          //width: Get.width / 1.3,
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
      ],
    );
    /*return Container(
      child: AspectRatio(
        aspectRatio: 2.0 /2.5,
        child: Image(
          image: FileImage(controller.file),

          fit: BoxFit.cover, // use this
        ),
      ),
    );*/
  }
}

// movie
class SizeRatio16 extends StatelessWidget {
  File file;
  SizeRatio16({required this.file});

  @override
  Widget build(BuildContext context) {
    /*return Container(
      padding: EdgeInsets.only(top: 180, bottom: 180),
      child: AspectRatio(
        aspectRatio: 3 / 1.1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 1.85 /1.0,
            child: Image(
              image: FileImage(file),

              fit: BoxFit.cover, // use this
            ),
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
    /*return Container(
      width: Get.width / 1.3,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Container(
      child: AspectRatio(
        aspectRatio: 2.0 /3.0,
        child: Image(
          image: FileImage(file),

          fit: BoxFit.cover, // use this
        ),
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
    /*return Container(
      padding: EdgeInsets.only(top: 150, bottom: 150),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 2.39 / 1,
          child: Image.file(controller.file, fit: BoxFit.cover),
        ),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 3.0 /1.0,
            child: Image(
              image: FileImage(file),
              fit: BoxFit.cover, // use this
            ),
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
    /*return Container(
      padding: EdgeInsets.only(top: 130, bottom: 130),
      child: AspectRatio(
        aspectRatio: 2.39 / 1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 16.0 /9.0,
            child: Image(
              image: FileImage(file),
              fit: BoxFit.cover, // use this
            ),
          ),
        ),
      ],
    );
  }
}

// yt cover
class SizeRatio20 extends StatelessWidget {
  File file;
  SizeRatio20({required this.file});

  @override
  Widget build(BuildContext context) {
    /*return Container(
      padding: EdgeInsets.only(top: 180, bottom: 180),
      child: AspectRatio(
        aspectRatio: 2.39 / 1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 16.0 /9.0,
            child: Image(
              image: FileImage(file),
              fit: BoxFit.cover, // use this
            ),
          ),
        ),
      ],
    );
  }
}
