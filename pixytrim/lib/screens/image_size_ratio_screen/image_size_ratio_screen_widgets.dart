import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/controller/image_size_ratio_controller/image_size_ratio_controller.dart';

final controller = Get.find<ImageSizeRatioController>();

//1:2
class SizeRatio1 extends StatelessWidget {
  const SizeRatio1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 1 / 2,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// 2:3
class SizeRatio2 extends StatelessWidget {
  const SizeRatio2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.2,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// 3:2
class SizeRatio3 extends StatelessWidget {
  const SizeRatio3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 40),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20),
      //     border: Border.all(color: Colors.grey)
      // ),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// 3:4
class SizeRatio4 extends StatelessWidget {
  const SizeRatio4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      //width: Get.width,
      child: Container(
        width: Get.width / 1.3,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Image.file(controller.file, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

// 4:3
class SizeRatio5 extends StatelessWidget {
  const SizeRatio5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.2,
      padding: EdgeInsets.only(top: 30, bottom: 30),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// 5:4
class SizeRatio6 extends StatelessWidget {
  const SizeRatio6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: AspectRatio(
        aspectRatio: 5 / 4,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// 9:16
class SizeRatio7 extends StatelessWidget {
  const SizeRatio7({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// 16:9
class SizeRatio8 extends StatelessWidget {
  const SizeRatio8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 120),
      child: AspectRatio(
        aspectRatio: 20 / 5,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// a4
class SizeRatio9 extends StatelessWidget {
  const SizeRatio9({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.2,
      child: AspectRatio(
        aspectRatio: 1 / 1.41,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// a5
class SizeRatio10 extends StatelessWidget {
  const SizeRatio10({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 30),
      width: Get.width / 1.3,
      child: AspectRatio(
        aspectRatio: 1 / 1.41,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// fb cover
class SizeRatio11 extends StatelessWidget {
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 200),
      child: AspectRatio(
        aspectRatio: 14 / 2,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// fb post
class SizeRatio12 extends StatelessWidget {
  const SizeRatio12({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100, bottom: 100),
      child: AspectRatio(
        aspectRatio: 1.91 / 1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// ig story
class SizeRatio13 extends StatelessWidget {
  const SizeRatio13({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.4,
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// ig 1:1
class SizeRatio14 extends StatelessWidget {
  const SizeRatio14({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// ig 4:5
class SizeRatio15 extends StatelessWidget {
  const SizeRatio15({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.3,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// movie
class SizeRatio16 extends StatelessWidget {
  const SizeRatio16({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 180, bottom: 180),
      child: AspectRatio(
        aspectRatio: 3 / 1.1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// pinterest post
class SizeRatio17 extends StatelessWidget {
  const SizeRatio17({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.3,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// twitter header
class SizeRatio18 extends StatelessWidget {
  const SizeRatio18({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 150, bottom: 150),
      child: AspectRatio(
        aspectRatio: 2.39 / 1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// twitter post
class SizeRatio19 extends StatelessWidget {
  const SizeRatio19({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 130, bottom: 130),
      child: AspectRatio(
        aspectRatio: 2.39 / 1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}

// yt cover
class SizeRatio20 extends StatelessWidget {
  const SizeRatio20({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 180, bottom: 180),
      child: AspectRatio(
        aspectRatio: 2.39 / 1,
        child: Image.file(controller.file, fit: BoxFit.cover),
      ),
    );
  }
}
