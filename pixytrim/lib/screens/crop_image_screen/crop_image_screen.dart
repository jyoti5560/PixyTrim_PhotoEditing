import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
//import 'package:image_crop/image_crop.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'dart:ui' as ui;

class CropImageScreen extends StatefulWidget {
  //const CropImageScreen({Key? key}) : super(key: key);
  File file;

  CropImageScreen({required this.file});

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {

  //final cropKey = GlobalKey<CropState>();
  File? file;
  File? file2;
  final GlobalKey key = GlobalKey();
  final _cropController = CropController();
  Uint8List? _croppedData;
  var _isCropping = false;

  int index = 0;

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
                        // child: widget.file.toString().isNotEmpty
                        //     ? Image.file(widget.file,
                        //     height: 120, width: 120, fit: BoxFit.fill)
                        //     : null,
                        child:  _croppedData != null ?
                        RepaintBoundary(
                          key: key,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.memory(_croppedData!)),
                        ):
                        Crop(
                          controller: _cropController,
                          image: widget.file.readAsBytesSync(),
                          onCropped: (croppedData) {
                            setState(() {
                              _croppedData = croppedData;
                              _isCropping = false;
                            });
                          },
                          //withCircleUi: _isCircleUi,
                          // onStatusChanged: (status) => setState(() {
                          //   _statusText = <CropStatus, String>{
                          //     CropStatus.nothing: 'Crop has no image data',
                          //     CropStatus.loading:
                          //     'Crop is now loading given image',
                          //     CropStatus.ready: 'Crop is now ready!',
                          //     CropStatus.cropping:
                          //     'Crop is now cropping image',
                          //   }[status] ??
                          //       '';
                          // }),
                          initialSize: 0.5,
                         // maskColor: _isSumbnail ? Colors.white : null,
                         //  cornerDotBuilder: (size, edgeAlignment) => _isSumbnail
                         //      ? const SizedBox.shrink()
                         //      : const DotControl(),
                        ),

                      ),
                    )),

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
    return Slider(
      activeColor: Colors.green,
      onChanged: (value){

      },
      value: 0,
    );
  }

  Widget scaleRatio(){
    return Slider(
      activeColor: Colors.green,
      onChanged: (value){

      },
      value: 0,
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
                  onTap: ()async {
                    //Get.back();
                    //await _capturePng();
                    setState(() {
                      _isCropping = true;
                    });
                    _cropController.crop();
                    _capturePng();
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
              _cropController.aspectRatio = 1/1;
            },
            child: Container(
              child: Text("1:1",
                style: TextStyle(fontSize: 18, fontFamily: ""),),
            ),
          ),
          GestureDetector(
            onTap: (){
              _cropController.aspectRatio = 3/2;
            },
            child: Container(
                child: Text("3:2", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              _cropController.aspectRatio = 1/1;
            },
            child: Container(
                child: Text("Original", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              _cropController.aspectRatio = 4 / 3;
            },
            child: Container(
                child: Text("4:3", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              //_isCircleUi = false;
              _cropController.aspectRatio = 16 / 9;
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
