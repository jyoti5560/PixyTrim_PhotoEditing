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
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'dart:ui' as ui;


enum SelectedModule {camera, gallery}

class BlurScreen extends StatefulWidget {
  File file;
 // final selectedModule;
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
  final cameraScreenController = Get.find<CameraScreenController>();
  final GlobalKey key = GlobalKey();
  File? blur;

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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: RepaintBoundary(
                      key: key,
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
                    //Get.back();
                    await _capturePng();
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

  Future _capturePng() async {
    try {
      print('inside');
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
      File imgFile = new File('$directory/photo.png');
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        blur = imgFile;
      });
      print("File path====:${blur!.path}");
      //collageScreenController.imageFileList = pngBytes;
      //bs64 = base64Encode(pngBytes);
      print("png Bytes:====$pngBytes");
      //print("bs64:====$bs64");
      //setState(() {});
      await saveImage();
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
