import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_gradient_slider.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'dart:ui' as ui;
import 'dart:math' as Math;
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;


class CropImageScreen extends StatefulWidget {
  File file;
  int newIndex;
  CropImageScreen({required this.file, required this.newIndex});

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  CameraScreenController csController = Get.find<CameraScreenController>();
  File? imageFile;
  final GlobalKey key = GlobalKey();
  Uint8List? croppedImage;
  var isCropping = false;

  int index = 0;
  double _rotation = 0;
  double _scale = 1;
  double _scalePercent = 0;
  final cropController = CropController();

  bool defaultSelectedIndex = true;

  LinearGradient gradient = LinearGradient(colors: <Color>[
    AppColor.kBorderGradientColor1,
    AppColor.kBorderGradientColor2,
    AppColor.kBorderGradientColor3,
  ]);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
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
                      child: isCropping == true
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: croppedImage == null && index == 0
                                    ? Crop(
                                        controller: cropController,
                                        image: widget.file.readAsBytesSync(),
                                        onCropped: (croppedData1) {
                                          Future.delayed(Duration(seconds: 3));
                                          setState(() {
                                            print('croppedData1 : $croppedData1');
                                            croppedImage = croppedData1;
                                            widget.file.writeAsBytesSync(croppedImage!);
                                            csController.addImageFromCameraList[widget.newIndex] = widget.file;
                                            print('NewIndex File : ${csController.addImageFromCameraList[widget.newIndex]}');
                                            isCropping = false;
                                            // _capturePng().then((value) {
                                            //   Get.back();
                                            // });
                                            Get.back();
                                          });
                                          // if (mounted) {
                                          //   print('mounted : $mounted');
                                          //   setState(() {
                                          //   });
                                          // }
                                        },
                                        initialSize: 0.5,
                                      )
                                    : index == 1
                                        ? RepaintBoundary(
                                            key: key,
                                            child: Transform.rotate(
                                              angle: Math.pi / 180 * _rotation,
                                              alignment: Alignment.center,
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    130,
                                                alignment: Alignment.center,
                                                child: PhotoView(
                                                  imageProvider: FileImage(widget.file),
                                                ),
                                              ),
                                            ),
                                          )
                                        : index == 2 ?
                                // GestureDetector(
                                //                 onScaleStart: (ScaleStartDetails
                                //                     details) {
                                //                   print(details);
                                //                   previousScale = _scale;
                                //                   setState(() {});
                                //                 },
                                //                 onScaleUpdate:
                                //                     (ScaleUpdateDetails
                                //                         details) {
                                //                   print(details);
                                //                   _scale = previousScale *
                                //                       details.scale;
                                //                   setState(() {});
                                //                 },
                                //                 onScaleEnd:
                                //                     (ScaleEndDetails details) {
                                //                   print(details);
                                //
                                //                   previousScale = 1.0;
                                //                   setState(() {});
                                //                 },
                                //                 child: Transform(
                                //                   alignment:
                                //                       FractionalOffset.center,
                                //                   transform: Matrix4.diagonal3(
                                //                       Vector3(_scale, _scale,
                                //                           _scale)),
                                //                   child: Image.file(
                                //                     widget.file,
                                //                     fit: BoxFit.cover,
                                //                   ),
                                //                 ),
                                //               )
                                GestureDetector(
                                  /* onScaleStart: (ScaleStartDetails details) {
                                          print(details);
                                          previousScale = _scale;
                                          setState(() {});
                                        },
                                        onScaleUpdate: (ScaleUpdateDetails details) {
                                          print(details);
                                          _scale = previousScale * details.scale;
                                          setState(() {});
                                        },
                                        onScaleEnd: (ScaleEndDetails details) {
                                          print(details);

                                          previousScale = 1.0;
                                          setState(() {});
                                        },*/
                                  child: RepaintBoundary(
                                    key: key,
                                    child: Transform(
                                      alignment: FractionalOffset.center,
                                      transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                                       // child: Image.file(widget.file,fit: BoxFit.cover,)
                                      child: PhotoView(
                                        imageProvider: FileImage(widget.file),
                                      ),
                                    ),
                                  ),
                                )
                                            : Container(
                                                child: RepaintBoundary(
                                                  key: key,
                                                  child: Container(
                                                      child: Image.memory(croppedImage!),
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
                    index == 0
                        ? cropRatio()
                        : index == 1
                            ? rotateRatio()
                            : index == 2
                                ? scaleRatio()
                                : Container(),
                    SizedBox(height: 20),
                    resizeCropButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rotateRatio() {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: borderGradientDecoration(),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: SliderTheme(
          data: SliderThemeData(
            trackShape: GradientRectSliderTrackShape(
                gradient: gradient, darkenInactive: false),
            valueIndicatorTextStyle: TextStyle(fontFamily: ""),
          ),
          child: Slider(
            divisions: 360,
            value: _rotation,
            min: 0,
            max: 360,
            label: 'Rotate : $_rotation°',
            onChanged: (n) {
              setState(() {
                _rotation = n.roundToDouble();
              });
              if (this.mounted) {
                setState(() {
                  // Your state change code goes here
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget scaleRatio(){
    return Container(
      padding: EdgeInsets.all(2),
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
            value: _scale,
            min: 1,
            max: 8,
            divisions: 32,
            label: 'Scale : $_scalePercent%',
            onChanged: (n) {
              setState(() {
                _scale = n.roundToDouble();
                _scalePercent = (100 * _scale) / 8;
                //controller.rotation = _rotation;
              });
              // if (this.mounted) {
              //   setState(() {
              //     _scale =0.0;
              //     // Your state change code goes here
              //   });
              // }
            },
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
                  child: Text(
                    "Crop",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () async {
                       if(index == 0) {
                         if(defaultSelectedIndex == true) {
                           cropController.crop();
                           Fluttertoast.showToast(msg: 'Please Wait...', toastLength: Toast.LENGTH_LONG);
                           setState(() {
                             defaultSelectedIndex = false;
                             isCropping = true;
                           });
                         } else if (defaultSelectedIndex == false){
                           await _capturePng().then((value) {
                             Get.back();
                           });
                         }

                       } else if(index == 1){
                         await _capturePng().then((value) {
                           Get.back();
                         });
                       } else if(index == 2) {
                         await _capturePng().then((value) {
                           Get.back();
                         });
                       }
                      },
                      child: Container(child: Icon(Icons.check_rounded)),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  _capturePng() async {
    try {
      DateTime time = DateTime.now();
      String imgName = "${time.hour}-${time.minute}-${time.second}";
      print('inside');
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print(boundary);
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      print("image:===$image");
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      print("byte data:===$byteData");
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/$imgName.jpg');
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        //imageFile = imgFile;
        csController.addImageFromCameraList[widget.newIndex] = imgFile;
      });
      print(
          "File path====:${csController.addImageFromCameraList[widget.newIndex].path}");
      print("png Bytes:====$pngBytes");
    } catch (e) {
      print(e);
    }
  }

  Future saveImage() async {
    // renameImage();
    print("Save===== ${imageFile!.path}");
    await GallerySaver.saveImage("${imageFile!.path}",
        albumName: "OTWPhotoEditingDemo");
    Get.back();
    Fluttertoast.showToast(
        msg: "Save In to Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget cropRatio() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              cropController.aspectRatio = 2/3;
              //_cropController.aspectRatio = 1/1;
            },
            child: Container(
              child: Text(
                "2:3",
                style: TextStyle(fontSize: 18, fontFamily: ""),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              cropController.aspectRatio = 3.0 / 2.0;
              // _cropController.aspectRatio = 3/2;
            },
            child: Container(
                child: Text(
              "3:2",
              style: TextStyle(fontSize: 18, fontFamily: ""),
            )),
          ),
          GestureDetector(
            onTap: () {
              //cropController.aspectRatio = 1000 / 667.0;
              cropController.aspectRatio = 1;
              //cropController.aspectRatio = 16 / 9.0;
              //_cropController.aspectRatio = 1/1;
            },
            child: Container(
                child: Text(
              "Original",
              style: TextStyle(fontSize: 18, fontFamily: ""),
            )),
          ),
          GestureDetector(
            onTap: () {
              cropController.aspectRatio = 4.0 / 3.0;
              //_cropController.aspectRatio = 4 / 3;
            },
            child: Container(
                child: Text(
              "4:3",
              style: TextStyle(fontSize: 18, fontFamily: ""),
            )),
          ),
          GestureDetector(
            onTap: () {
              //_isCircleUi = false;
              cropController.aspectRatio = 16.0 / 9.0;
              //_cropController.aspectRatio = 16 / 9;
            },
            child: Container(
                child: Text(
              "16:9",
              style: TextStyle(fontSize: 18, fontFamily: ""),
            )),
          ),
        ],
      ),
    );
  }

  Widget resizeCropButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                index = 0;
                defaultSelectedIndex = true;
                print('defaultSelectedIndex : $defaultSelectedIndex');
                _rotation = 0; // Reset Value
                _scale = 1; // Reset Value
              });
            },
            child: Container(
              padding: EdgeInsets.all(2),
              height: 60,
              width: 60,
              margin: EdgeInsets.only(right: 8),
              decoration: borderGradientDecoration(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Center(
                  child: Image.asset(
                    Images.ic_crop,
                    scale: 2,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                index = 1;
                _scale = 1; // Reset Value
              });
            },
            child: Container(
              padding: EdgeInsets.all(2),
              height: 60,
              width: 60,
              margin: EdgeInsets.only(right: 8),
              decoration: borderGradientDecoration(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Center(
                  child: Image.asset(
                    Images.ic_rotate,
                    scale: 2,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                index = 2;
                _rotation = 0; // Reset Value
              });
            },
            child: Container(
              padding: EdgeInsets.all(2),
              height: 60,
              width: 60,
              margin: EdgeInsets.only(right: 8),
              decoration: borderGradientDecoration(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Center(
                    child: Image.asset(
                  Images.ic_scale,
                  scale: 2,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog() {
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(fontFamily: ""),
      ),
      onPressed: () {
        Get.back();
        //Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(fontFamily: ""),
      ),
      onPressed: () async {
        // await _capturePng().then((value) {
        //   Get.back();
        //   Get.back();
        // });
        Get.back();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("AlertDialog"),
      content: Text(
        "Do you want to exit?",
        style: TextStyle(fontFamily: ""),
      ),
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

  // @override
  // void dispose() {
  //   csController.loading();
  //   super.dispose();
  // }
}
