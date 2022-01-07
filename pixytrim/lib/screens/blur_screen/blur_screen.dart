import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_gradient_slider.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'dart:ui' as ui;


enum SelectedModule {camera, gallery}

class BlurScreen extends StatefulWidget {
  @override
  _BlurScreenState createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  final csController = Get.find<CameraScreenController>();
  double blurValue = 0.0;

  LinearGradient gradient = LinearGradient(
      colors: <Color> [
        AppColor.kBorderGradientColor1,
        AppColor.kBorderGradientColor2,
        AppColor.kBorderGradientColor3,
      ]
  );
  double blurImage = 0.0;
  final cameraScreenController = Get.find<CameraScreenController>();
  final GlobalKey key = GlobalKey();
  File? blur;

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
                    // Expanded(
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(20),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         image: DecorationImage(
                    //           image: FileImage(csController.addImageFromCameraList[csController.selectedImage.value]),
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //       child: RepaintBoundary(
                    //         key: key,
                    //         child: BackdropFilter(
                    //               filter: ImageFilter.blur(
                    //                   sigmaX: blurImage, sigmaY: blurImage),
                    //               child: Container(
                    //                 color: Colors.black.withOpacity(0.1),
                    //               ),
                    //             ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: RepaintBoundary(
                                  key: key,
                                  child: ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                        sigmaX: blurImage, sigmaY: blurImage),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: csController.addImageFromCameraList[csController.selectedImage.value].toString().isNotEmpty
                                          ? Image.file(csController.addImageFromCameraList[csController.selectedImage.value])
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    blurSlider()
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
                    //Get.back();
                    showAlertDialog();
                  },
                  child: Container(
                      child: Image.asset(
                        Images.ic_left_arrow,
                        scale: 2.5,
                      )),
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
                  onTap: ()async {
                    //saveImage();
                    await _capturePng();
                    Get.back();
                  },
                  child: Container(child: Icon(Icons.check_rounded)),
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
                valueIndicatorTextStyle: TextStyle(fontFamily: ""),
              ),
              child: Slider(
                value: blurImage,
                min:0,
                max: 5 ,
                divisions: 100,
                label: 'Blur : ${blurValue.toStringAsFixed(0)} %',
                onChanged: (value) {
                  setState(() {
                    blurImage = value;
                    blurValue = (value * 100) / 5;
                  });
                  print(blurValue);
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

  Future _capturePng() async {
    try {
      print('inside');
      DateTime time = DateTime.now();
      final imgName = "${time.day}_${time.month}_${time.year}_${time.hour}_${time.minute}_${time.second}";
      RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print(boundary);
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      print("image:===$image");
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      print("byte data:===$byteData");
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/$imgName.jpg');
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        csController.addImageFromCameraList[csController.selectedImage.value] = imgFile;
      });
      print("File path====:${blur!.path}");
      //collageScreenController.imageFileList = pngBytes;
      //bs64 = base64Encode(pngBytes);
      print("png Bytes:====$pngBytes");
      //print("bs64:====$bs64");
      //setState(() {});
      //await saveImage();
    } catch (e) {
      print(e);
    }
  }

  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage("${blur!.path}",
        albumName: "OTWPhotoEditingDemo");
    Fluttertoast.showToast(
              msg: "Save in to Gallery",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
    );
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
        await _capturePng().then((value) {
          Get.back();
          Get.back();
        });
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
  // Image Save Module
  // Future saveImage() async {
  //   // renameImage();
  //   await GallerySaver.saveImage(widget.file.path, albumName: "OTWPhotoEditingDemo");
  //   Fluttertoast.showToast(
  //       msg: "Save in to Gallery",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  // }

}
