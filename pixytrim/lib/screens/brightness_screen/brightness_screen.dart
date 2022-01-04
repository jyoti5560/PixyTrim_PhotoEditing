import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
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

class BrightnessScreen extends StatefulWidget {
  // File file;
  // BrightnessScreen({required this.file});

  @override
  _BrightnessScreenState createState() => _BrightnessScreenState();
}

class _BrightnessScreenState extends State<BrightnessScreen> {
  final csController = Get.find<CameraScreenController>();
  double sat = 1;
  double bright = 0;
  double con = 1;
  GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();
  final defaultColorMatrix = const <double>[
    1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0
  ];

  LinearGradient gradient = LinearGradient(
      colors: <Color> [
        AppColor.kBorderGradientColor1,
        AppColor.kBorderGradientColor2,
        AppColor.kBorderGradientColor3,
      ]
  );
  final GlobalKey key = GlobalKey();
  File? brightness;

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
                    Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(calculateContrastMatrix(con)),
                      child: ColorFiltered(
                            colorFilter:
                                ColorFilter.matrix(calculateSaturationMatrix(sat)),
                            child: Container(
                              //width: Get.width,
                              child: RepaintBoundary(
                                key: key,
                                child: ExtendedImage(
                                  color: bright > 0
                                      ? Colors.white.withOpacity(bright)
                                      : Colors.black.withOpacity(-bright),
                                  colorBlendMode: bright > 0
                                      ? BlendMode.lighten
                                      : BlendMode.darken,
                                  image: ExtendedFileImageProvider(csController.addImageFromCameraList[csController.selectedImage.value]),
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
                  child: Text(csController.selectedModule == SelectedModule.camera ? "Camera" : "Gallery",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    await _capturePng();
                    // saveImage();
                    Get.back();
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
                      valueIndicatorTextStyle: TextStyle(fontFamily: ""),
                      //accentTextTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)),
                    ),
                    child: Slider(
                      label: 'saturation : ${sat.toStringAsFixed(2)}',
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
                Image.asset(Images.ic_sun, scale: 2.2,),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
                      valueIndicatorTextStyle: TextStyle(fontFamily: ""),
                    ),
                    child: Slider(
                      label: 'brightness : ${bright.toStringAsFixed(2)}',
                      onChanged: (double value) {
                        setState(() {
                          bright = value;
                        });
                      },
                      divisions: 50,
                      value: bright,
                      min: -0.5,
                      max: 0.50,
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
            child: Row(
              children: [
                Image.asset(Images.ic_contrast, scale: 2.2),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
                      valueIndicatorTextStyle: TextStyle(fontFamily: ""),
                    ),
                    child: Slider(
                      label: 'contrast : ${con.toStringAsFixed(2)}',
                      onChanged: (double value) {
                        setState(() {
                          con = value;
                        });
                      },
                      divisions: 50,
                      value: con,
                      min: 0.50,
                      max: 1.50,
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
      print("png Bytes:====$pngBytes");
      // await saveImage();
    } catch (e) {
      print(e);
    }
  }

  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage("${brightness!.path}",
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
        //await _capturePng().then((value) {
          Get.back();
          Get.back();
        //});
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

