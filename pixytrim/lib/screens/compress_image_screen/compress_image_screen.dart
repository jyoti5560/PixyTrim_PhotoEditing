import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_gradient_slider.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';

enum SelectedModule { camera, gallery }

class CompressImageScreen extends StatefulWidget {
  File compressFile;
  int index;

  CompressImageScreen({
    required this.compressFile,
    required this.index,
  });

  @override
  _CompressImageScreenState createState() => _CompressImageScreenState();
}

class _CompressImageScreenState extends State<CompressImageScreen> {
  // CompressImageScreenController compressImageScreenController = Get.put(CompressImageScreenController());
  final csController = Get.find<CameraScreenController>();
  LinearGradient gradient = LinearGradient(colors: <Color>[
    AppColor.kBorderGradientColor1,
    AppColor.kBorderGradientColor2,
    AppColor.kBorderGradientColor3,
  ]);

  double sat = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              MainBackgroundWidget(),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                child: Column(
                  children: [
                    appBar(),
                    SizedBox(height: 20),
                    imageList(),
                  ],
                ),
              )
            ],
          ),
        ),
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

                    //widget.compressFile.delete();
                    //csController.compressSize.value;
                    showAlertDialog();
                    //Get.back();
                  },
                  child: Container(
                      child: Image.asset(
                    Images.ic_left_arrow,
                    scale: 2.5,
                  )),
                ),
                Container(
                  child: Text(
                    csController.selectedModule == SelectedModule.camera
                        ? "Camera"
                        : "Gallery",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await saveImage();
                    csController.compressSize.value = 61;
                    Get.back();
                  },
                  child: Container(
                      child: Image.asset(
                    Images.ic_downloading,
                    scale: 2,
                  )),
                ),
              ],
            )),
      ),
    );
  }

  Future saveImage() async {
    await GallerySaver.saveImage(widget.compressFile.path,
        albumName: "OTWPhotoEditingDemo");
    Fluttertoast.showToast(
        msg: "Save in to Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    widget.compressFile.delete();
  }

  Widget imageList() {
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
                            child: Image.file(
                                csController.addImageFromCameraList[
                                    csController.selectedImage.value]))),
                    SizedBox(height: 10),
                    Text(
                      "Original Size",
                      style: TextStyle(fontFamily: "", fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${csController.addImageFromCameraList[csController.selectedImage.value].lengthSync()} kb",
                      style: TextStyle(
                          fontFamily: "",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(widget.compressFile),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Expected Size",
                      style: TextStyle(fontFamily: "", fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => csController.isLoading.value
                          ? CircularProgressIndicator()
                          : Text(
                              "${widget.compressFile.lengthSync()} kb",
                              style: TextStyle(
                                fontFamily: "",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
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
              child: Row(
                children: [
                  Image.asset(Images.ic_compress, scale: 2),
                  Expanded(
                    child: Obx(
                      () => SliderTheme(
                        data: SliderThemeData(
                          trackShape: GradientRectSliderTrackShape(
                              gradient: gradient, darkenInactive: false,
                          ),
                        ),
                        child: Slider(
                          onChanged: (value) {
                            setState(() {
                              print('value : $value');
                              csController.compressSize.value = value;
                              compressImage(csController.addImageFromCameraList[widget.index]);
                              print('Compressed Index : ${widget.index}');
                              csController.loading();
                            });
                          },
                          divisions: 70,
                          value: csController.compressSize.value,
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

  Future compressImage(File file) async {
    print("file: $file");
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    print("last inde: $lastIndex");
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: csController.compressSize.value.toInt(),
    );
    print("Original path : ${file.lengthSync()}");
    print(file.absolute.path);
    print("Compress path : ${result!.lengthSync()}");
    setState(() {
      widget.compressFile = result;
      //cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value] = result;
    });
    // setState Required
    setState(() {});
    print("compressFile: ${widget.compressFile.lengthSync()}");
    // setState(() {
    //
    // });
  }

  showAlertDialog() {

    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(fontFamily: ""),),
      onPressed:  () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: TextStyle(fontFamily: ""),),
      onPressed:  () async{
          Get.back();
          Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("AlertDialog"),
      content: Text("Do you want to exit?", style: TextStyle(fontFamily: ""),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
