import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_gradient_slider.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';

enum SelectedModule {camera, gallery}

class CompressImageScreen extends StatefulWidget {

  //const CompressImageScreen({Key? key}) : super(key: key);
  File file;
  File compressFile;
  //final selectedModule;
  CompressImageScreen({required this.file, required this.compressFile,});
  @override
  _CompressImageScreenState createState() => _CompressImageScreenState();
}

class _CompressImageScreenState extends State<CompressImageScreen> {
  // CompressImageScreenController compressImageScreenController = Get.put(CompressImageScreenController());
  final cameraScreenController = Get.find<CameraScreenController>();
  LinearGradient gradient = LinearGradient(
      colors: <Color> [
        AppColor.kBorderGradientColor1,
        AppColor.kBorderGradientColor2,
        AppColor.kBorderGradientColor3,
      ]
  );

  double sat = 1;

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
                SizedBox(
                  height: 60,
                ),
                appBar(),
                SizedBox(
                  height: 20,
                ),

                imageList()
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
                  child: Container(
                      child: Image.asset(Images.ic_left_arrow, scale: 2.5,)
                  ),
                ),
                Container(
                  child: Text(cameraScreenController.selectedModule == SelectedModule.camera ? "Camera" : "Gallery",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    //Get.back();
                    await saveImage();
                  },
                  child: Container(
                      child: Image.asset(Images.ic_downloading, scale: 2,)
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage(widget.compressFile.path, albumName: "OTWPhotoEditingDemo");
    Fluttertoast.showToast(
        msg: "Save in to Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Widget imageList(){
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(widget.file))),
                    SizedBox(height: 10,),

                    Text("Original Size",
                      style: TextStyle(fontFamily: "", fontSize: 18),),

                    SizedBox(height: 10,),

                    Text("${widget.file.lengthSync()} kb",
                      style: TextStyle(fontFamily: "", fontSize: 18, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  children: [
                    Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(widget.compressFile))),

                    SizedBox(height: 10,),

                    Text("Expected Size",
                      style: TextStyle(fontFamily: "", fontSize: 18),),

                    SizedBox(height: 10,),

                    Text("${widget.compressFile.lengthSync()} kb",
                      style: TextStyle(fontFamily: "", fontSize: 18, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

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
                  Image.asset(Images.ic_compress, scale: 2,),
                  Expanded(
                    child: Obx(()=>
                       SliderTheme(
                        data: SliderThemeData(
                          trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
                        ),
                        child: Slider(
                          //label: 'sat : ${sat.toStringAsFixed(2)}',
                          onChanged: (value) {
                            //setState(() {
                              print('value : $value');
                              cameraScreenController.compressSize.value = value;
                            //});

                          },
                          divisions: 60,
                          value: cameraScreenController.compressSize.value,
                          min: 0,
                          max: 100,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
