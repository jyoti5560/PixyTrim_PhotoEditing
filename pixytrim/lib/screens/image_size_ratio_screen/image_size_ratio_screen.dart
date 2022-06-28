import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'package:pixytrim/controller/image_size_ratio_controller/image_size_ratio_controller.dart';
import 'dart:ui' as ui;

import '../../common/custom_color.dart';

class ImageSizeRatioScreen extends StatefulWidget {
  @override
  _ImageSizeRatioScreenState createState() => _ImageSizeRatioScreenState();
}

class _ImageSizeRatioScreenState extends State<ImageSizeRatioScreen> {
  final GlobalKey key = GlobalKey();
  ImageSizeRatioController imageSizeRatioController =
      Get.put(ImageSizeRatioController());
  int? imageRatioIndex;
  File? file;
  final csController = Get.find<CameraScreenController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showAlertDialog();
      },
      child: Scaffold(
        body: Obx(
          () => imageSizeRatioController.isLoading.value
              ? CircularProgressIndicator()
              : SafeArea(
                  child: Stack(
                    children: [
                      MainBackgroundWidget(),
                      Container(
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: Column(
                          children: [
                            appBar(),
                            SizedBox(height: 20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: ratioImage(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            ratioList(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
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
                      return showAlertDialog();
                    },
                    child: Container(
                        child: Image.asset(
                      Images.ic_left_arrow,
                      scale: 2.5,
                    )),
                  ),
                  Container(
                    child: Text(
                      "Image Ratio",
                      style: TextStyle(
                          fontFamily: "",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      int newIndex =
                          imageSizeRatioController.selectedIndex.value;
                      print('new Index : $newIndex');
                      double pixelRatio =
                          newIndex == 19 || newIndex == 6 || newIndex == 7
                              ? 7.0
                              : newIndex == 5
                                  ? 5.0
                                  : newIndex == 8
                                      ? 14
                                      : 4.0;
                      showTopNotification(
                        displayText: "Please Wait...",
                        leadingIcon: Icon(
                          Icons.image,
                          color: AppColor.kBlackColor,
                        ),
                        displayTime: 2,
                      );

                      // Fluttertoast.showToast(msg: 'Please Wait...', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 1,);
                      await _capturePng(pRation: pixelRatio).then((value) {
                        Get.back();
                      });
                    },
                    child: Container(child: Icon(Icons.check_rounded)),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future _capturePng({required double pRation}) async {
    try {
      print('inside');
      print('pRation : $pRation');
      DateTime time = DateTime.now();
      String imgName = "${time.hour}-${time.minute}-${time.second}";
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print(boundary);
      ui.Image image = await boundary.toImage(pixelRatio: pRation);
      print("image:===$image");
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      print("byte data:===$byteData");
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/$imgName.jpg');
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        csController.addImageFromCameraList[csController.selectedImage.value] =
            imgFile;
      });
      print("File path====:${file!.path}");
      print("png Bytes:====$pngBytes");
    } catch (e) {
      print(e);
    }
  }

  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage("${file!.path}",
        albumName: "OTWPhotoEditingDemo");
  }

  Widget ratioImage() {
    return Obx(
      () => Transform.scale(
        scale: imageSizeRatioController.scaleIndex.value == 10
            ? 2.1
            : imageSizeRatioController.scaleIndex.value == 0 ||
                    imageSizeRatioController.scaleIndex.value == 1 ||
                    imageSizeRatioController.scaleIndex.value == 3 ||
                    imageSizeRatioController.scaleIndex.value == 4 ||
                    imageSizeRatioController.scaleIndex.value == 6
                ? 2
                : imageSizeRatioController.scaleIndex.value == 2 ||
                        imageSizeRatioController.scaleIndex.value == 7 ||
                        imageSizeRatioController.scaleIndex.value == 8 ||
                        imageSizeRatioController.scaleIndex.value == 9 ||
                        imageSizeRatioController.scaleIndex.value == 13 ||
                        imageSizeRatioController.scaleIndex.value == 14 ||
                        imageSizeRatioController.scaleIndex.value == 16
                    ? 1.3
                    : imageSizeRatioController.scaleIndex.value == 18
                        ? 1.2
                        : 1,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: RepaintBoundary(
              key: key,
              child: imageSizeRatioController.file.toString().isNotEmpty &&
                      imageSizeRatioController.selectedIndex.value == 0
                  ? imageSizeRatioController.sizeOptions[0].sizeWidget
                  : imageSizeRatioController.file.toString().isNotEmpty &&
                          imageSizeRatioController.selectedIndex.value == 1
                      ? imageSizeRatioController.sizeOptions[1].sizeWidget
                      : imageSizeRatioController.file.toString().isNotEmpty &&
                              imageSizeRatioController.selectedIndex.value == 2
                          ? imageSizeRatioController.sizeOptions[2].sizeWidget
                          : imageSizeRatioController.file.toString().isNotEmpty &&
                                  imageSizeRatioController.selectedIndex.value ==
                                      3
                              ? imageSizeRatioController
                                  .sizeOptions[3].sizeWidget
                              : imageSizeRatioController.file.toString().isNotEmpty &&
                                      imageSizeRatioController.selectedIndex.value ==
                                          4
                                  ? imageSizeRatioController
                                      .sizeOptions[4].sizeWidget
                                  : imageSizeRatioController.file.toString().isNotEmpty &&
                                          imageSizeRatioController.selectedIndex.value ==
                                              5
                                      ? imageSizeRatioController
                                          .sizeOptions[5].sizeWidget
                                      : imageSizeRatioController.file.toString().isNotEmpty &&
                                              imageSizeRatioController.selectedIndex.value ==
                                                  6
                                          ? imageSizeRatioController
                                              .sizeOptions[6].sizeWidget
                                          : imageSizeRatioController.file
                                                      .toString()
                                                      .isNotEmpty &&
                                                  imageSizeRatioController.selectedIndex.value == 7
                                              ? imageSizeRatioController.sizeOptions[7].sizeWidget
                                              : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 8
                                                  ? imageSizeRatioController.sizeOptions[8].sizeWidget
                                                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 9
                                                      ? imageSizeRatioController.sizeOptions[9].sizeWidget
                                                      : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 10
                                                          ? imageSizeRatioController.sizeOptions[10].sizeWidget
                                                          : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 11
                                                              ? imageSizeRatioController.sizeOptions[11].sizeWidget
                                                              : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 12
                                                                  ? imageSizeRatioController.sizeOptions[12].sizeWidget
                                                                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 13
                                                                      ? imageSizeRatioController.sizeOptions[13].sizeWidget
                                                                      : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 14
                                                                          ? imageSizeRatioController.sizeOptions[14].sizeWidget
                                                                          : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 15
                                                                              ? imageSizeRatioController.sizeOptions[15].sizeWidget
                                                                              : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 16
                                                                                  ? imageSizeRatioController.sizeOptions[16].sizeWidget
                                                                                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 17
                                                                                      ? imageSizeRatioController.sizeOptions[17].sizeWidget
                                                                                      : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 18
                                                                                          ? imageSizeRatioController.sizeOptions[18].sizeWidget
                                                                                          : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 19
                                                                                              ? imageSizeRatioController.sizeOptions[19].sizeWidget
                                                                                              : Container(),
            ),
          ),
        ),
      ),
    );
  }

  Widget ratioList() {
    return Obx(
      () => imageSizeRatioController.isLoading.value
          ? CircularProgressIndicator()
          : Container(
              height: Get.height / 6.5,
              child: ListView.builder(
                itemCount: imageSizeRatioController.sizeOptions.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      imageSizeRatioController.isLoading(true);
                      /*imageRatioIndex = index;

              if(imageRatioIndex == 0){
                print(imageRatioIndex);
                setState(() {
                  imageRatioIndex =0 ;

                });
              } else if(imageRatioIndex == 1){
                print(imageRatioIndex);
                setState(() {
                  imageRatioIndex =1 ;

                });
              }*/
                      // setState(() {
                      imageSizeRatioController.selectedIndex.value = index;
                      print('index : $index');
                      print(
                          'selectedIndex : ${imageSizeRatioController.selectedIndex.value}');
                      imageSizeRatioController.scaleIndex.value =
                          imageSizeRatioController.selectedIndex.value;
                      imageSizeRatioController.isLoading(false);
                      // });
                      // File image = File('${imageSizeRatioController.sizeOptions[index].image}');
                      // var decodedImage = await decodeImageFromList(image.readAsBytesSync());
                      // print(decodedImage.width);
                      // print(decodedImage.height);
                    },
                    child: Container(
                      width: Get.width / 3.5,
                      child: Column(
                        children: [
                          Container(
                              height: Get.height / 8,
                              child: Image.asset(imageSizeRatioController
                                  .sizeOptions[index].image)),
                          SizedBox(height: 5),
                          Text(
                            "${imageSizeRatioController.sizeOptions[index].sizeName}",
                            style: TextStyle(
                                fontFamily: "",
                                color: imageSizeRatioController
                                            .selectedIndex.value ==
                                        index
                                    ? Colors.black87
                                    : Colors.grey.shade600,
                                fontWeight: imageSizeRatioController
                                            .selectedIndex.value ==
                                        index
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  showAlertDialog() {
    Widget cancelButton = IconsButton(
      onPressed: () {
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
}
