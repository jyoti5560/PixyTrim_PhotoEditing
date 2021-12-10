import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_gradient_slider.dart';
import 'package:pixytrim/common/custom_image.dart';

class BrightnessScreen extends StatefulWidget {
  //const BrightnessScreen({Key? key}) : super(key: key);
  File file;

  BrightnessScreen({required this.file});

  @override
  _BrightnessScreenState createState() => _BrightnessScreenState();
}

class _BrightnessScreenState extends State<BrightnessScreen> {
  double sat = 1;
  double bright = 0;
  double con = 1;
  GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();
  final defaultColorMatrix = const <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];

  LinearGradient gradient = LinearGradient(
      colors: <Color> [
        AppColor.kBorderGradientColor1,
        AppColor.kBorderGradientColor2,
        AppColor.kBorderGradientColor3,
      ]
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainBackgroundWidget(),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              children: [
                SizedBox(height: 60),
                appBar(),
                SizedBox(height: 20),
                Expanded(
                    child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(calculateContrastMatrix(con)),
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.matrix(calculateSaturationMatrix(sat)),
                    child: Container(
                      //width: Get.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ExtendedImage(
                          color: bright > 0
                              ? Colors.white.withOpacity(bright)
                              : Colors.black.withOpacity(-bright),
                          colorBlendMode: bright > 0
                              ? BlendMode.lighten
                              : BlendMode.darken,
                          image: ExtendedFileImageProvider(widget.file),
                          extendedImageEditorKey: editorKey,
                          /*child: Container(
                            width: Get.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: widget.file.toString().isNotEmpty
                                  ? Image.file(
                                      widget.file,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            ),
                          ),*/
                        ),
                      ),
                    ),
                  ),
                )),
                SizedBox(height: 20),
                brightnessList()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      height: 50,
      width: Get.width,
      decoration: borderGradientDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(child: Icon(Icons.close)),
                ),
                Container(
                  child: Text(
                    "Camera",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //Get.back();
                  },
                  child: Container(child: Icon(Icons.check_rounded)),
                ),
              ],
            )),
      ),
    );
  }

  Widget brightnessList() {
    return Column(
      children: [
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
            //margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Image.asset(Images.ic_saturation, scale: 2.2,),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
                    ),
                    child: Slider(
                      label: 'sat : ${sat.toStringAsFixed(2)}',
                      onChanged: (double value) {
                        setState(() {
                          sat = value;
                        });
                      },
                      divisions: 50,
                      value: sat,
                      min: 0,
                      max: 2,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
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
            //margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Image.asset(Images.ic_sun, scale: 2.2,),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
                    ),
                    child: Slider(
                      label: '${bright.toStringAsFixed(2)}',
                      onChanged: (double value) {
                        setState(() {
                          bright = value;
                        });
                      },
                      divisions: 50,
                      value: bright,
                      min: -1,
                      max: 1,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
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
            //margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Image.asset(Images.ic_contrast, scale: 2.2,),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
                    ),
                    child: Slider(
                      label: 'con : ${con.toStringAsFixed(2)}',
                      onChanged: (double value) {
                        setState(() {
                          con = value;
                        });
                      },
                      divisions: 50,
                      value: con,
                      min: 0,
                      max: 4,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<double> calculateSaturationMatrix(double saturation) {
    final m = List<double>.from(defaultColorMatrix);
    final invSat = 1 - saturation;
    final R = 0.213 * invSat;
    final G = 0.715 * invSat;
    final B = 0.072 * invSat;

    m[0] = R + saturation;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + saturation;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + saturation;

    return m;
  }

  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(defaultColorMatrix);
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }
}

