import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_gradient_slider.dart';

class BlurScreen extends StatefulWidget {
  File file;
  BlurScreen({required this.file});
  //const BlurScreen({Key? key}) : super(key: key);

  @override
  _BlurScreenState createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {

  LinearGradient gradient = LinearGradient(
      colors: <Color> [
        AppColor.kBorderGradientColor1,
        AppColor.kBorderGradientColor2,
        AppColor.kBorderGradientColor3,
      ]
  );
  double blurImage = 0;

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                            sigmaX: blurImage, sigmaY: blurImage),
                        child: Container(
                          color: Colors.transparent,
                          child: widget.file.toString().isNotEmpty
                              ? Image.file(widget.file)
                              : null,
                        ),
                      ),
                ),

                SizedBox(height: 20),

                blurSlider()
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
                  child: Container(child: Icon(Icons.close)),
                ),
              ],
            )),
      ),
    );
  }

  Widget blurSlider(){
    return Container(
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
                value: blurImage,
                max: 10,
                onChanged: (value) {
                  setState(() {
                    blurImage = value;
                  });
                  print(blurImage);
                },
                //divisions: 100,
                //value: widget.collageScreenController.borderWidthValue.value,
               // min: 0,
                //max: 10,
              ),
            ),
          ),
    );
  }
}
