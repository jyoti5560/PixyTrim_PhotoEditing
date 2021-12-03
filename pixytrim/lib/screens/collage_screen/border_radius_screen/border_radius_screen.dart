import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_gradient_slider.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';

class BorderRadiusScreen extends StatefulWidget {
  //const BorderColorScreen({Key? key}) : super(key: key);
  @override
  _BorderRadiusScreenState createState() => _BorderRadiusScreenState();
}

class _BorderRadiusScreenState extends State<BorderRadiusScreen> {
  LinearGradient gradient = LinearGradient(
      colors: <Color> [
        AppColor.kBorderGradientColor1,
        AppColor.kBorderGradientColor2,
        AppColor.kBorderGradientColor3,
      ]
  );

  CollageScreenController collageScreenController =
  Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Container(
          padding: EdgeInsets.all(2),
          height: 60,
          width: Get.width,
          margin: EdgeInsets.only(right: 8),
          decoration: borderGradientDecoration(),
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
              ),
              child: Slider(
                //label: 'sat : ${collageScreenController.borderWidthValue.toStringAsFixed(2)}',
                onChanged: (value) {
                  collageScreenController.borderRadiusValue.value = value;
                  print(collageScreenController.borderRadiusValue.value);
                },
                divisions: 100,
                value: collageScreenController.borderRadiusValue.value,
                min: 0,
                max: 50,
              ),
            ),
            // Slider(
            //   value: collageScreenController.borderWidthValue.value,
            //   min: 0,
            //   max: 10,
            //   onChanged: (value) {
            //     collageScreenController.borderWidthValue.value = value;
            //     print(collageScreenController.borderWidthValue.value);
            //   },
            //   divisions: 10,
            // )
            // : Container()
          ),
        ),
    );
  }
}
