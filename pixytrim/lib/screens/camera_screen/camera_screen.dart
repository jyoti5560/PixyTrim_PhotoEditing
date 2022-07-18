import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/common/store_session_local/store_session_local.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'package:pixytrim/screens/blur_screen/blur_screen.dart';
import 'package:pixytrim/screens/brightness_screen/brightness_screen.dart';
import 'package:pixytrim/screens/compress_image_screen/compress_image_screen.dart';
import 'package:pixytrim/screens/crop_image_screen/crop_image_screen.dart';
import 'package:pixytrim/screens/filter_screen/filter_screen.dart';
import 'package:pixytrim/screens/image_editor_screen/image_editor_screen.dart';
import 'package:pixytrim/screens/image_size_ratio_screen/image_size_ratio_screen.dart';
import 'package:pixytrim/screens/image_size_ratio_screen/image_size_ratio_screen_widgets.dart';
import 'package:share/share.dart';
import 'package:image/image.dart' as imageLib;

import '../../common/custom_color.dart';
import '../../common/helper/ad_helper.dart';
import '../photo_blend_screen/photo_blend_screen.dart';

enum SelectedModule { camera, gallery }

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final cameraScreenController = Get.put(CameraScreenController());
  LocalStorage localStorage = LocalStorage();
  List<String> localList = [];
  final ImagePicker imagePicker = ImagePicker();

  int? i;
  File? compressFile;
  imageLib.Image? resize;
  imageLib.Image? imageTemp;

  @override
  Widget build(BuildContext context) {
    print("path===${cameraScreenController.selectedModule}");

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
                    cameraModule(),
                    SizedBox(height: 20),
                    editingIconList(),
                    SizedBox(height: 10),
                    Container(
                      height: 48,
                      child: cameraScreenController.adWidget,
                    )
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
                      scale: 2.4,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    cameraScreenController.selectedModule ==
                            SelectedModule.camera
                        ? "Camera"
                        : "Gallery",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        cameraScreenController.selectedModule ==
                                SelectedModule.camera
                            ? openCamera()
                            : openGallery();
                      },
                      child: Container(
                        child: Image.asset(
                          cameraScreenController.selectedModule ==
                                  SelectedModule.camera
                              ? Images.ic_camera2
                              : Images.ic_gallery1,
                          scale: cameraScreenController.selectedModule ==
                                  SelectedModule.camera
                              ? 1.7
                              : 1.7,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        cameraScreenController.rewardedAd.show(
                          onUserEarnedReward: (ad, reward) {
                            saveImage();
                          },
                        );
                      },
                      child: Container(
                        child: Image.asset(
                          Images.ic_downloading,
                          scale: 1.7,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        cameraScreenController.rewardedAd.show(
                          onUserEarnedReward: (ad, reward) async {
                            await shareImage();
                          },
                        );
                      },
                      child: Container(
                        child: Image.asset(
                          Images.ic_sharing,
                          scale: 1.7,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget cameraModule() {
    return Container(
      child: Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Obx(
            () => cameraScreenController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  child: cameraScreenController
                                          .addImageFromCameraList.length
                                          .isGreaterThan(0)
                                      ? Image.file(
                                          cameraScreenController
                                                  .addImageFromCameraList[
                                              cameraScreenController
                                                  .selectedImage.value],
                                          errorBuilder: (ctx, obj, st) {
                                            return Center(
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColor
                                                      .kBorderGradientColor1,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 0.5),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                          ),
                          child: Obx(
                            () => ListView.builder(
                              itemCount: cameraScreenController
                                  .addImageFromCameraList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cameraScreenController
                                            .selectedImage.value = i;
                                        print(
                                            'selectedImage1 : ${cameraScreenController.selectedImage.value}');
                                      });
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      child: Image.file(
                                        cameraScreenController
                                            .addImageFromCameraList[i],
                                        fit: BoxFit.cover,
                                      ),
                                      decoration: BoxDecoration(
                                          border: cameraScreenController
                                                      .selectedImage.value ==
                                                  i
                                              ? Border.all(color: Colors.black)
                                              : Border.all(
                                                  color: Colors.transparent)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // child: Obx(
                          //       () => Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: List.generate(
                          //       cameraScreenController.addImageFromCameraList.length,
                          //           (index) => Container(
                          //         width: 30,
                          //         height: 30,
                          //         child: Image.file(
                          //           cameraScreenController
                          //               .addImageFromCameraList[index],
                          //           fit: BoxFit.cover,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  showAlertDialog() {
    Widget cancelButton = IconsButton(
      onPressed: () {
        Get.back();
        Get.back();
        cameraScreenController.rewardedAd.show(
          onUserEarnedReward: (ad, reward) {},
        );
      },
      text: 'Don\'t save'.toUpperCase(),
      color: AppColor.kBorderGradientColor3,
      textStyle: TextStyle(color: Colors.white),
    );

    Widget continueButton = IconsButton(
      onPressed: () async {
        if (cameraScreenController.addImageFromCameraList.isNotEmpty) {
          for (int i = 0;
              i < cameraScreenController.addImageFromCameraList.length;
              i++) {
            localList
                .add(cameraScreenController.addImageFromCameraList[i].path);
          }
          print('localList : $localList');
          if (localList.isNotEmpty) {
            await localStorage.storeMainList(localList);
          }
          Get.back();
        }
        Get.back();
        cameraScreenController.rewardedAd.show(
          onUserEarnedReward: (ad, reward) {},
        );
      },
      text: 'save draft'.toUpperCase(),
      color: AppColor.kButtonCyanColor,
      textStyle: TextStyle(color: Colors.white),
    );

    Dialogs.materialDialog(
      lottieBuilder: LottieBuilder.asset(
        "assets/lotties/9511-loading.json",
      ),
      color: Colors.white,
      msg: "Do you want to save draft Project before exiting?",
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

  void openCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // setState(() {
      cameraScreenController.file = File(image.path);
      print('Camera File Path : ${cameraScreenController.file}');
      print('Camera Image Path : ${image.path}');
      cameraScreenController.addCameraImageInList(
          file: cameraScreenController.file);
    } else {}
  }

  void openGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        cameraScreenController.file = File(image.path);
        print('Camera File Path : ${cameraScreenController.file}');
        print('Camera Image Path : ${image.path}');
        //Fluttertoast.showToast(msg: '${image.path}', toastLength: Toast.LENGTH_LONG);
        //renameImage();
        cameraScreenController.addCameraImageInList(
            file: cameraScreenController.file);
      });
    } else {}
  }

  // Share The
  shareImage() async {
    try {
      // final ByteData bytes = await rootBundle.load('${file!.path}');
      await Share.shareFiles([
        '${cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value].path}'
      ]);
    } catch (e) {
      print('Share Error : $e');
    }
  }

  // Image Save Module
  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage(
        cameraScreenController
            .addImageFromCameraList[cameraScreenController.selectedImage.value]
            .path,
        albumName: "OTWPhotoEditingDemo");

    showTopNotification(
      displayText: "Saved to photo Gallery",
      leadingIcon: Icon(
        Icons.image,
        color: AppColor.kBlackColor,
      ),
    );

    // Fluttertoast.showToast(
    //     msg: "Save in to Gallery",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  Widget editingIconList() {
    return Container(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: cameraScreenController.iconList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              i = index;

              if (i == 0) {
                Get.to(() => CropImageScreen(
                              file: cameraScreenController
                                      .addImageFromCameraList[
                                  cameraScreenController.selectedImage.value],
                              newIndex:
                                  cameraScreenController.selectedImage.value,
                            ))!
                        .whenComplete(() {
                  cameraScreenController.loading();
                }) /*.then((value){
                         cameraScreenController.loading();
                  })*/
                    ;
                //cropImage();
              } else if (i == 1) {
                Get.to(
                  () => FilterScreen(),
                );
              } else if (i == 2) {
                Get.to(
                  () => BrightnessScreen(),
                );
              } else if (i == 3) {
                Get.to(
                  () => BlurScreen(),
                );
              } else if (i == 4) {
                Get.to(
                  () => PhotoBlendScreen(),
                );
              } else if (i == 5) {
                compressImage(cameraScreenController.addImageFromCameraList[
                        cameraScreenController.selectedImage.value])
                    .then((value) {
                  print(
                      'index index : ${cameraScreenController.selectedImage.value}');
                  Get.to(() => CompressImageScreen(
                        compressFile: compressFile!,
                        index: cameraScreenController.selectedImage.value,
                      ));
                });
              } else if (i == 6) {
                resizeImage(cameraScreenController.addImageFromCameraList[
                        cameraScreenController.selectedImage.value])
                    .then((value) {
                  /*Get.to(() => CompressImageScreen(
                      file: widget.file,
                      compressFile: compressFile!,
                    ))!
                        .then((value) {
                      // setState(() {});
                    });*/
                  showTopNotification(
                    displayText: "Original length: ${imageTemp!.length} Kb\n"
                        "Resize length: ${resize!.length} Kb",
                    leadingIcon: Icon(
                      Icons.photo_filter,
                      color: AppColor.kBlackColor,
                    ),
                  );
                });
              } else if (i == 7) {
                Get.to(() => ImageEditorScreen(
                    file: cameraScreenController.addImageFromCameraList[
                        cameraScreenController.selectedImage.value],
                    newIndex: cameraScreenController.selectedImage.value));
              } else if (i == 8) {
                print('Value : ${cameraScreenController.selectedImage.value}');
                Get.to(() => ImageSizeRatioScreen(), arguments: [
                  cameraScreenController.addImageFromCameraList[
                      cameraScreenController.selectedImage.value],
                  cameraScreenController.selectedImage.value
                ]);

                //Get.to(() => ImageEditorScreen(file: widget.file));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        cameraScreenController.iconList[index],
                        scale: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${cameraScreenController.bottomToolsList[index]}",
                      style: TextStyle(
                        color: AppColor.kBlackColor.withOpacity(0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future compressImage(File file) async {
    print("file: $file");
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    print("last index: $lastIndex");
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: cameraScreenController.compressSize.value.toInt(),
    );
    print("Original path : ${file.lengthSync()}");
    print(file.absolute.path);
    print("Compress path : ${result!.lengthSync()}");
    setState(() {
      compressFile = result;
      //cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value] = result;
    });
    // setState Required
    setState(() {});
    print("compressFile: ${compressFile!.lengthSync()}");
    // setState(() {
    //
    // });
  }

  Future resizeImage(File file) async {
    imageTemp = imageLib.decodeImage(file.readAsBytesSync());
    imageLib.Image resized_img = imageLib.copyResize(imageTemp!, height: 800);
    resize = resized_img;
    print(resized_img.length);
    print(imageTemp!.length);
  }

  Future<Null> cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: cameraScreenController.file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop',
        ));
    if (croppedFile != null) {
      cameraScreenController.addImageFromCameraList[
          cameraScreenController.selectedImage.value] = croppedFile;
      setState(() {});
      //setState(() {
      // state = AppState.cropped;
      //});
    }
  }
}
