import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as Math;
//import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
//import 'package:image_crop/image_crop.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_gradient_slider.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:crop/crop.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package: photo_view/photo_view.dart';

class CropImageScreen extends StatefulWidget {
  //const CropImageScreen({Key? key}) : super(key: key);
  File file;

  CropImageScreen({required this.file});

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> with SingleTickerProviderStateMixin {

  //final cropKey = GlobalKey<CropState>();
  File? file;
  File? file2;
  final GlobalKey key = GlobalKey();
  //final _cropController = CropController();
  Uint8List? _croppedData;
  var _isCropping = false;

  int index = 0;
  bool showFront = true;
  double _rotation = 0;
  final controller = CropController(aspectRatio: 1000 / 667.0);
  BoxShape shape = BoxShape.rectangle;


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
                SizedBox(
                  height: 60,
                ),
                appBar(),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Container(
                      width: Get.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        // child:  _croppedData != null ?
                        // RepaintBoundary(
                        //   key: key,
                        //   child: ClipRRect(
                        //       borderRadius: BorderRadius.circular(20),
                        //       child:  Image.memory(_croppedData!)),
                        // ):
                        // Crop(
                        //   controller: _cropController,
                        //   image: widget.file.readAsBytesSync(),
                        //   onCropped: (croppedData) {
                        //     setState(() {
                        //       _croppedData = croppedData;
                        //       _isCropping = false;
                        //     });
                        //   },
                        //   //withCircleUi: _isCircleUi,
                        //   // onStatusChanged: (status) => setState(() {
                        //   //   _statusText = <CropStatus, String>{
                        //   //     CropStatus.nothing: 'Crop has no image data',
                        //   //     CropStatus.loading:
                        //   //     'Crop is now loading given image',
                        //   //     CropStatus.ready: 'Crop is now ready!',
                        //   //     CropStatus.cropping:
                        //   //     'Crop is now cropping image',
                        //   //   }[status] ??
                        //   //       '';
                        //   // }),
                        //   initialSize: 0.5,
                        //  // maskColor: _isSumbnail ? Colors.white : null,
                        //  //  cornerDotBuilder: (size, edgeAlignment) => _isSumbnail
                        //  //      ? const SizedBox.shrink()
                        //  //      : const DotControl(),
                        // ),

                        child: Crop(
                          onChanged: (decomposition) {
                            if (_rotation != decomposition.rotation) {
                              setState(() {
                                _rotation = ((decomposition.rotation + 180) % 360) - 180;
                              });
                            }

                            print(
                                "Scale : ${decomposition.scale}, Rotation: ${decomposition.rotation}, translation: ${decomposition.translation}");
                          },
                          controller: controller,
                          shape: shape,
                          child: Image.file(widget.file),
                          // foreground: IgnorePointer(
                          //   child: Container(
                          //     alignment: Alignment.bottomRight,
                          //     child: Text(
                          //       'Pixytrim',
                          //       style: TextStyle(color: Colors.red),
                          //     ),
                          //   ),
                          // ),
                          helper: shape == BoxShape.rectangle
                              ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          )
                              : null,
                        ),
                      ),
                    )
                ),

                SizedBox(
                  height: 20,
                ),

                index == 0 ? cropRatio() :
                index == 1 ? rotateRatio() :
                index == 2 ? scaleRatio()
                 : Container(),

                SizedBox(
                  height: 20,
                ),

                resizeCropButton()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget rotateRatio(){
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
          ),
          child: Slider(
            divisions: 360,
            value: _rotation,
            min: -180,
            max: 180,
            label: '$_rotation°',
            onChanged: (n) {
              setState(() {
                _rotation = n.roundToDouble();
                controller.rotation = _rotation;
              });
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
          ),
          child: Slider(
            divisions: 360,
            value: _rotation,
            min: -180,
            max: 180,
            label: '$_rotation°',
            onChanged: (n) {
              setState(() {
                _rotation = n.roundToDouble();
                controller.rotation = _rotation;
              });
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
                    Get.back();
                  },
                  child: Container(
                    child: Icon(Icons.close)
                  ),
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
                GestureDetector(
                  onTap: () {
                    //Get.back();
                    //await _capturePng();


                    // setState(() {
                    //   _isCropping = true;
                    // });
                    // _cropController.crop();
                    // _capturePng();

                     crop();
                  },
                  child: Container(
                      child: Icon(Icons.check_rounded)
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void crop() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cropped = await controller.crop(pixelRatio: pixelRatio);

    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      await _saveScreenShot(cropped);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to gallery.'),
        ),
      );
    }
  }

  Future<dynamic> _saveScreenShot(ui.Image img) async {
    var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    var buffer = byteData!.buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(buffer);
    print(result);

    return result;
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
        file = imgFile;
        //file.writeAsBytesSync(bytes)
          _croppedData = file!.readAsBytesSync();
          //file2 = File.fromRawPath(_croppedData!);
      });
      print("File path====:$_croppedData");
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
    print("Save===== ${File('$_croppedData').path}");
    await GallerySaver.saveImage("${File('$_croppedData').path}",
        albumName: "OTWPhotoEditingDemo");
  }

  Widget cropRatio(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
                controller.aspectRatio = 1;
              //_cropController.aspectRatio = 1/1;
            },
            child: Container(
              child: Text("1:1",
                style: TextStyle(fontSize: 18, fontFamily: ""),),
            ),
          ),
          GestureDetector(
            onTap: (){
              controller.aspectRatio = 3.0 / 2.0;
             // _cropController.aspectRatio = 3/2;
            },
            child: Container(
                child: Text("3:2", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              //_cropController.aspectRatio = 1/1;
              controller.aspectRatio = 1000 / 667.0;
            },
            child: Container(
                child: Text("Original", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              controller.aspectRatio = 4.0 / 3.0;
              //_cropController.aspectRatio = 4 / 3;
            },
            child: Container(
                child: Text("4:3", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              //_isCircleUi = false;
              controller.aspectRatio = 16.0 / 9.0;
              //_cropController.aspectRatio = 16 / 9;
            },
            child: Container(
                child: Text("16:9", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
        ],
      ),
    );
  }

  Widget resizeCropButton(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GestureDetector(
            onTap: (){
              setState(() {
                index = 0;
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
                //margin: EdgeInsets.only(left: 10, right: 10),

                child: Center(
                    child: Image.asset(
                      Images.ic_crop,
                      scale: 2,
                    )),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                index = 1;
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
                //margin: EdgeInsets.only(left: 10, right: 10),

                child: Center(
                    child: Image.asset(
                      Images.ic_rotate,
                      scale: 2,
                    )),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                index = 2;
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
                //margin: EdgeInsets.only(left: 10, right: 10),

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
}
