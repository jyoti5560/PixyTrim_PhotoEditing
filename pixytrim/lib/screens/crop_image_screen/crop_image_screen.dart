import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
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
import 'package:path/path.dart' as path;

import '../../common/helper/ad_helper.dart';

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
  File? tempCroppedFile;

  int index = 0;
  double _rotation = 0;
  double _scale = 1;
  double _scalePercent = 0;
  final cropController = CropController();

  bool defaultSelectedIndex = true;
  bool cropEnable = true;

  LinearGradient gradient = LinearGradient(
    colors: <Color>[
      AppColor.kBorderGradientColor1,
      AppColor.kBorderGradientColor2,
      AppColor.kBorderGradientColor3,
    ],
  );

  late AdWidget? adWidget;

  late BannerAdListener listener;

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    sizes: [
      AdSize.banner,
    ],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
      },

      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.

        ad.dispose();
        print('Ad failed to load: $error');
      },

      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );

    adWidget = AdWidget(
      ad: myBanner,
    );
    myBanner.load();
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showAlertDialog();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              MainBackgroundWidget(),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  children: [
                    appBar(),
                    SizedBox(height: 20),
                    Obx(
                      () => Expanded(
                        child: isCropping == true ||
                                csController.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: croppedImage == null &&
                                                index == 0
                                            ? Crop(
                                                //maskColor: Colors.white54,
                                                cornerDotBuilder: (size,
                                                        edgeAlignment) =>
                                                    const DotControl(
                                                        color: Colors.white),
                                                controller: cropController,
                                                image: widget.file
                                                    .readAsBytesSync(),
                                                onCropped:
                                                    (croppedData1) async {
                                                  // Future.delayed(Duration(seconds: 3));
                                                  setState(() {
                                                    print(
                                                        'croppedData1 : $croppedData1');
                                                    croppedImage = croppedData1;
                                                    widget.file
                                                        .writeAsBytesSync(
                                                            croppedImage!);
                                                    tempCroppedFile =
                                                        widget.file;
                                                    print(
                                                        'tempCroppedFile : $tempCroppedFile');
                                                    isCropping = false;
                                                    cropEnable = false;
                                                    csController.loading();
                                                  });
                                                  if (mounted) {
                                                    print('mounted : $mounted');
                                                    DateTime time =
                                                        DateTime.now();
                                                    String imgName =
                                                        '${time.hour}_${time.minute}_${time.second}-${time.day}_${time.month}_${time.year}';
                                                    String dir =
                                                        (await getApplicationDocumentsDirectory())
                                                            .path;
                                                    String newPath = path.join(
                                                        dir, '$imgName.jpg');
                                                    widget.file
                                                        .renameSync(newPath);
                                                    print(
                                                        'widget.file :${widget.file}');
                                                    setState(() {});
                                                  }
                                                },
                                                initialSize: 0.5,
                                              )
                                            : index == 1
                                                ? Obx(
                                                    () => csController
                                                            .isLoading.value
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                        : RepaintBoundary(
                                                            key: key,
                                                            child: Transform
                                                                .rotate(
                                                              angle: Math.pi /
                                                                  180 *
                                                                  _rotation,
                                                              origin:
                                                                  Offset.zero,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height -
                                                                    130,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: /*tempCroppedFile != null
                                                            ? PhotoView(imageProvider: FileImage(tempCroppedFile!))
                                                              : PhotoView(imageProvider: FileImage(widget.file),disableGestures: true,),*/
                                                                    Image.file(
                                                                        widget
                                                                            .file),
                                                              ),
                                                            ),
                                                          ),
                                                  )
                                                : index == 2
                                                    ?
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
                                                            alignment:
                                                                FractionalOffset
                                                                    .center,
                                                            transform: Matrix4
                                                                .diagonal3(
                                                                    Vector3(
                                                                        _scale,
                                                                        _scale,
                                                                        _scale)),
                                                            // child: Image.file(widget.file,fit: BoxFit.cover,)
                                                            child: PhotoView(
                                                              enablePanAlways:
                                                                  true,
                                                              backgroundDecoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                              imageProvider:
                                                                  FileImage(
                                                                      widget
                                                                          .file),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        child: RepaintBoundary(
                                                          key: key,
                                                          child: Container(
                                                            child: Image.memory(
                                                                croppedImage!),
                                                          ),
                                                        ),
                                                      ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                    SizedBox(height: 15),
                    Container(
                      height: 48,
                      child: adWidget,
                    ),
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

  Widget scaleRatio() {
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
                        if (index == 0) {
                          if (defaultSelectedIndex == true) {
                            cropController.crop();
                            showTopNotification(
                              displayText: "Please Wait...",
                              leadingIcon: Icon(
                                Icons.crop,
                                color: AppColor.kBlackColor,
                              ),
                              displayTime: 2,
                            );
                            //  Fluttertoast.showToast(msg: 'Please Wait...', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 1,);
                            setState(() {
                              defaultSelectedIndex = false;
                              isCropping = true;
                            });
                          } else if (defaultSelectedIndex == false) {
                            showTopNotification(
                              displayText: "Please Wait...",
                              leadingIcon: Icon(
                                Icons.crop,
                                color: AppColor.kBlackColor,
                              ),
                              displayTime: 2,
                            );
                            //  Fluttertoast.showToast(msg: 'Please Wait...', toastLength: Toast.LENGTH_LONG);
                            await _capturePng().then((value) {
                              Get.back();
                            });
                          }
                        } else if (index == 1) {
                          showTopNotification(
                            displayText: "Please Wait...",
                            leadingIcon: Icon(
                              Icons.crop,
                              color: AppColor.kBlackColor,
                            ),
                            displayTime: 2,
                          );
                          //  Fluttertoast.showToast(msg: 'Please Wait...', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 1,);
                          await _capturePng().then((value) {
                            Get.back();
                          });
                        } else if (index == 2) {
                          showTopNotification(
                            displayText: "Please Wait...",
                            leadingIcon: Icon(
                              Icons.crop,
                              color: AppColor.kBlackColor,
                            ),
                            displayTime: 2,
                          );
                          //  Fluttertoast.showToast(msg: 'Please Wait...', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 1,);
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
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
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
      renameImage();
    } catch (e) {
      print(e);
    }
  }

  renameImage() async {
    String orgPath = csController
        .addImageFromCameraList[csController.selectedImage.value].path;
    String frontPath =
        orgPath.split('app_flutter')[0]; // Getting Front Path of file Path
    print('frontPath: $frontPath');
    List<String> ogPathList = orgPath.split('/');
    print('ogPathList: $ogPathList');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    print('ogExt: $ogExt');
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.day}-${today.month}-${today.year}_${today.hour}:${today.minute}:${today.second}";
    print('Date: $dateSlug');
    csController.addImageFromCameraList[csController.selectedImage.value] =
        await csController
            .addImageFromCameraList[csController.selectedImage.value]
            .rename("${frontPath}cache/pixytrim_$dateSlug.$ogExt");

    print(
        'Final FIle Name : ${csController.addImageFromCameraList[csController.selectedImage.value].path}');
  }

  Future saveImage() async {
    // renameImage();
    print("Save===== ${imageFile!.path}");
    await GallerySaver.saveImage("${imageFile!.path}",
        albumName: "OTWPhotoEditingDemo");
    Get.back();

    showTopNotification(
      displayText: "Save In to Gallery",
      leadingIcon: Icon(
        Icons.image,
        color: AppColor.kBlackColor,
      ),
      displayTime: 2,
    );
    // Fluttertoast.showToast(
    //     msg: "Save In to Gallery",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 5,
    //     backgroundColor: Colors.blue,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  Widget cropRatio() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              cropController.aspectRatio = 2 / 3;
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
              if (cropEnable == true) {
                setState(() {
                  index = 0;
                  defaultSelectedIndex = true;
                  print('defaultSelectedIndex : $defaultSelectedIndex');
                  _rotation = 0; // Reset Value
                  _scale = 1; // Reset Value
                });
              } else {
                showTopNotification(
                  displayText: "Image Already Cropped!",
                  leadingIcon: Icon(
                    Icons.crop,
                    color: AppColor.kBlackColor,
                  ),
                  displayTime: 2,
                );
                //   Fluttertoast.showToast(
                //       msg: 'Image Already Cropped!',
                //       toastLength: Toast.LENGTH_SHORT);
              }

              /*setState(() {
                index = 0;
                defaultSelectedIndex = true;
                print('defaultSelectedIndex : $defaultSelectedIndex');
                _rotation = 0; // Reset Value
                _scale = 1; // Reset Value
              });*/
            },
            child: Column(
              children: [
                Container(
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
                const SizedBox(height: 5),
                Text(
                  'Crop',
                  style: TextStyle(
                      color: index == 0 ? Colors.black87 : Colors.grey.shade600,
                      fontWeight:
                          index == 0 ? FontWeight.bold : FontWeight.normal,
                      fontFamily: ""),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                index = 1;
                _scale = 1; // Reset Value
                // cropEnable = false;
                csController.loading();
              });
            },
            child: Column(
              children: [
                Container(
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
                const SizedBox(height: 5),
                Text(
                  'Rotate',
                  style: TextStyle(
                      color: index == 1 ? Colors.black87 : Colors.grey.shade600,
                      fontWeight:
                          index == 1 ? FontWeight.bold : FontWeight.normal,
                      fontFamily: ""),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                index = 2;
                _rotation = 0; // Reset Value
                // cropEnable = false;
              });
            },
            child: Column(
              children: [
                Container(
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
                const SizedBox(height: 5),
                Text(
                  'Scale',
                  style: TextStyle(
                      color: index == 2 ? Colors.black87 : Colors.grey.shade600,
                      fontWeight:
                          index == 2 ? FontWeight.bold : FontWeight.normal,
                      fontFamily: ""),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog() {
    Widget cancelButton = IconsButton(
      onPressed: () {
        croppedImage = null;
        Get.back();
      },
      text: 'No',
      color: AppColor.kBorderGradientColor3,
      textStyle: TextStyle(color: Colors.white),
    );

    Widget continueButton = IconsButton(
      onPressed: () async {
        Get.back();
        Get.back();
      },
      text: 'yes',
      color: AppColor.kBorderGradientColor1,
      textStyle: TextStyle(color: Colors.white),
    );

    Dialogs.materialDialog(
      lottieBuilder: LottieBuilder.asset(
        "assets/lotties/9511-loading.json",
      ),
      color: Colors.white,
      msg: "Do you want to exit?",
      msgStyle: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      context: context,
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
  // @override
  // void dispose() {
  //   csController.loading();
  //   super.dispose();
  // }
}
