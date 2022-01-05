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


class CropImageScreen extends StatefulWidget {
  //const CropImageScreen({Key? key}) : super(key: key);
  File file;

  CropImageScreen({required this.file});

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> with SingleTickerProviderStateMixin {
  CameraScreenController csController = Get.find<CameraScreenController>();
  //final cropKey = GlobalKey<CropState>();
  File? imageFile;
  File? file2;
  final GlobalKey key = GlobalKey();
  //final _cropController = CropController();
  Uint8List? croppedImage;
  var isCropping = false;
  //File ? crop;
  // bool isLoading=true;

  int index = 0;
  bool showFront = true;
  double _rotation = 0;
  double _scale = 1.0;
  final cropController = CropController();
  BoxShape shape = BoxShape.rectangle;
  File? temp;
  double previousScale = 1.0;

  LinearGradient gradient = LinearGradient(
      colors: <Color> [
        AppColor.kBorderGradientColor1,
        AppColor.kBorderGradientColor2,
        AppColor.kBorderGradientColor3,
      ]
  );

  // @override
  // void initState() {
  //   croppedData = Uint8List(0);
  //   super.initState();
  // }


  Image ? cardFront;
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
                            child: Container(
                              width: Get.width,
                              height: Get.height,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: croppedImage == null && index == 0
                                    ? Crop(
                                  controller: cropController,
                                  image: widget.file.readAsBytesSync(),
                                  onCropped: (croppedData1) {
                                    setState(() {
                                      print('croppedData1 : $croppedData1');
                                      print('croppedData1 : ${croppedData1.runtimeType}');
                                      croppedImage = croppedData1;
                                      isCropping = false;
                                    });
                                    // if (this.mounted) {
                                    //   setState(() {
                                    //     // Your state change code goes here
                                    //   });
                                    // }
                                  },
                                  initialSize: 0.5,
                                ):
                                index == 1 ?
                                Transform(
                                  transform: Matrix4.rotationX(
                                      (_rotation) * Math.pi / 2
                                  ),
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height - 130,
                                    alignment: Alignment.center,
                                    child: Image.file(widget.file),
                                  ),
                                )
                                    : index == 2 ?
                                PhotoView(
                                  //enableRotation: true,
                                    imageProvider: FileImage(widget.file))

                                // Transform(
                                //   transform: Matrix4.identity()..scale(_scale, _scale),
                                //   alignment: Alignment.center,
                                //   child: Container(
                                //     height: MediaQuery.of(context).size.height - 130,
                                //     alignment: Alignment.center,
                                //     child: Image.file(widget.file),
                                //   ),
                                // )

                                // GestureDetector(
                                //   onScaleStart: (ScaleStartDetails details) {
                                //     print(details);
                                //     previousScale = _scale;
                                //     setState(() {});
                                //   },
                                //   onScaleUpdate: (ScaleUpdateDetails details) {
                                //     print(details);
                                //     _scale = previousScale * details.scale;
                                //     setState(() {});
                                //   },
                                //   onScaleEnd: (ScaleEndDetails details) {
                                //     print(details);
                                //
                                //     previousScale = 1.0;
                                //     setState(() {});
                                //   },
                                //   child: Transform(
                                //     alignment: FractionalOffset.center,
                                //     transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                                //     child: Image.file(widget.file,fit: BoxFit.cover,),
                                //   ),
                                // )
                                // PhotoView(
                                //   //enableRotation: true,
                                //     imageProvider: FileImage(widget.file))
                                // Transform(
                                //   transform: Matrix4.identity()..scale(_scale, _scale),
                                //   alignment: Alignment.center,
                                //   child: Container(
                                //     height: MediaQuery.of(context).size.height - 130,
                                //     alignment: Alignment.center,
                                //     child: Image.file(widget.file),
                                //   ),
                                // )
                                    : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: RepaintBoundary(
                                        key: key,
                                        child: Image.memory(croppedImage!),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                      ),

                      SizedBox(height: 20),

                      index == 0 ? cropRatio() :

                      index == 1 ? rotateRatio() :
                     // index == 2 ? scaleRatio()
                           Container(),

                      SizedBox(height: 20),

                      resizeCropButton()
                    ],
                  ),
                ),
            ],
          ),
        ),
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
            valueIndicatorTextStyle: TextStyle(fontFamily: ""),
          ),
          child: Slider(
            divisions: 25,
            value: _rotation,
            min: 0,
            max: 50,
            label: '$_rotation°',
            onChanged: (n) {
              setState(() {
                _rotation = n.roundToDouble();
                //controller.rotation = _rotation;
                //controller.rotation = _rotation;
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
          ),
          child: Slider(
            divisions: 100,
            value: _scale,
            min: -180,
            max: 180,
            label: '$_scale°',
            onChanged: (n) {
              setState(() {
                _scale = n.roundToDouble();
                //controller.rotation = _rotation;
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
                    //Get.back();
                    showAlertDialog();
                  },
                  child: Container(
                    child: Image.asset(
                      Images.ic_left_arrow,
                      scale: 2.5,
                    )
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
                Row(
                  children: [
                    // GestureDetector(
                    //   // onTap: () async{
                    //   //   temp = widget.file;
                    //   //   print("temp file====$temp");
                    //   //   cropController.crop();
                    //   //
                    //   //   print("crop file====$croppedImage");
                    //   // },
                    //   child: Container(
                    //       child: Icon(Icons.crop)
                    //   ),
                    // ),
                    SizedBox(width: 15,),
                    GestureDetector(
                      onTap: () async {
                        cropController.crop();
                        Fluttertoast.showToast(
                            msg: "Please wait",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        await Future.delayed(Duration(seconds: 3));

                        await _capturePng().then((value) {
                          csController.isLoading(false);
                          Get.back();
                        });


                        //crop1();
                      },
                      child: Container(
                          child: Icon(Icons.check_rounded)
                      ),
                    ),
                  ],
                )
                
                
              ],
            )),
      ),
    );
  }

  // void crop1() async {
  //   final pixelRatio = MediaQuery.of(context).devicePixelRatio;
  //   final cropped = await controller.crop(pixelRatio: pixelRatio);
  //
  //   final status = await Permission.storage.request();
  //   if (status == PermissionStatus.granted) {
  //     await _saveScreenShot(cropped);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Saved to gallery.'),
  //       ),
  //     );
  //   }
  // }

  // Future<dynamic> _saveScreenShot(ui.Image img) async {
  //   var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  //   var buffer = byteData!.buffer.asUint8List();
  //   final result = await ImageGallerySaver.saveImage(buffer);
  //   print(result);
  //
  //   return result;
  // }

  Future _capturePng() async {
    try {
      DateTime time = DateTime.now();
      String imgName = "${time.hour}-${time.minute}-${time.second}";
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
      File imgFile = new File('$directory/$imgName.jpg');
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        //imageFile = imgFile;
        csController.addImageFromCameraList[csController.selectedImage.value] = imgFile;
      });
      print("File path====:${imageFile!.path}");
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
            fontSize: 16.0
        );
  }

  Widget cropRatio(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              cropController.aspectRatio = 1;
              //_cropController.aspectRatio = 1/1;
            },
            child: Container(
              child: Text("1:1",
                style: TextStyle(fontSize: 18, fontFamily: ""),),
            ),
          ),
          GestureDetector(
            onTap: (){
              cropController.aspectRatio = 3.0 / 2.0;
             // _cropController.aspectRatio = 3/2;
            },
            child: Container(
                child: Text("3:2", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              //cropController.aspectRatio = 1000 / 667.0;
              cropController.aspectRatio = 16 / 9.0;
              //_cropController.aspectRatio = 1/1;

            },
            child: Container(
                child: Text("Original", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              cropController.aspectRatio = 4.0 / 3.0;
              //_cropController.aspectRatio = 4 / 3;
            },
            child: Container(
                child: Text("4:3", style: TextStyle(fontSize: 18, fontFamily: ""),)
            ),
          ),
          GestureDetector(
            onTap: (){
              //_isCircleUi = false;
              cropController.aspectRatio = 16.0 / 9.0;
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
             // cropController.crop();
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
      child: Text("No", style: TextStyle(fontFamily: ""),),
      onPressed:  () {
        Get.back();
        //Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: TextStyle(fontFamily: ""),),
      onPressed:  () async{
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

  // @override
  // void dispose() {
  //   showAlertDialog();
  //   super.dispose();
  // }


}

