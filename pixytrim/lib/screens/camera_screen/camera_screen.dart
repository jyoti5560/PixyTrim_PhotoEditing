import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'package:pixytrim/screens/blur_screen/blur_screen.dart';
import 'package:pixytrim/screens/brightness_screen/brightness_screen.dart';
import 'package:pixytrim/screens/compress_image_screen/compress_image_screen.dart';
import 'package:pixytrim/screens/crop_image_screen/crop_image_screen.dart';
import 'package:pixytrim/screens/filter_screen/filter_screen.dart';
import 'package:pixytrim/screens/image_editor_screen/image_editor_screen.dart';
import 'package:pixytrim/screens/image_size_ratio_screen/image_size_ratio_screen.dart';
import 'package:share/share.dart';
import 'package:image/image.dart' as imageLib;


enum SelectedModule { camera, gallery }

class CameraScreen extends StatefulWidget {
  // File file;
  // CameraScreen({required this.file});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final cameraScreenController = Get.put(CameraScreenController());

  final ImagePicker imagePicker = ImagePicker();

  List<String> iconList = [
    Images.ic_crop,
    Images.ic_filter,
    Images.ic_brightness,
    Images.ic_blur,
    Images.ic_compress,
    Images.ic_resize,
    Images.ic_edit_image,
    Images.ic_image_ratio,
  ];

  int? i;
  File? compressFile;
  imageLib.Image? resize;

  @override
  Widget build(BuildContext context) {
    print("path===${cameraScreenController.selectedModule}");
    return Scaffold(
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
                  Container(
                    child: Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Obx(
                              ()=> Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: cameraScreenController.addImageFromCameraList.length.isGreaterThan(0)
                                    ? Image.file(cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value],
                                    height: 120, width: 120, fit: BoxFit.fill)
                                    : null,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10, bottom: 0.5),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                              ),
                              child: Obx(
                                ()=> ListView.builder(
                                  itemCount: cameraScreenController.addImageFromCameraList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i){
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            cameraScreenController.selectedImage.value = i;
                                            print('selectedImage1 : ${cameraScreenController.selectedImage.value}');
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
                                            border: cameraScreenController.selectedImage.value == i
                                                ? Border.all(color: Colors.black)
                                                : Border.all(color: Colors.transparent)
                                          ),
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
                  SizedBox(height: 20),
                  editingIconList(),
                ],
              ),
            )
          ],
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
                              : Images.ic_gallery,
                          scale: cameraScreenController.selectedModule ==
                              SelectedModule.camera ? 1.7 : 3.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        saveImage();
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
                        await shareImage();
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
      await Share.shareFiles(['${cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value].path}']);
    } catch (e) {
      print('Share Error : $e');
    }
  }

  // Image Save Module
  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage(cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value].path,
        albumName: "OTWPhotoEditingDemo");
    Fluttertoast.showToast(
        msg: "Save in to Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  editingIconList() {
    return Container(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: iconList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                i = index;

                if (i == 0) {
                  Get.to(() => CropImageScreen(
                        file: cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value],
                      ));
                  //cropImage();
                } else if (i == 1) {
                  Get.to(() => FilterScreen(),
                      // arguments: cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value]
                  );
                } else if (i == 2) {
                  Get.to(() => BrightnessScreen(
                        // file: cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value],
                      )); //todo
                } else if (i == 3) {
                  Get.to(() => BlurScreen());
                } else if (i == 4) {
                  compressImage(cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value]).then((value) {
                    Get.to(() => CompressImageScreen(
                              compressFile: compressFile!,
                            ))!
                        .then((value) {
                      // setState(() {});
                    });
                  });
                } else if (i == 5) {
                  resizeImage(cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value]).then((value) {
                    /*Get.to(() => CompressImageScreen(
                      file: widget.file,
                      compressFile: compressFile!,
                    ))!
                        .then((value) {
                      // setState(() {});
                    });*/
                    Fluttertoast.showToast(
                        msg: "Original length: ${imageTemp!.length}\n"
                            "Resize length: ${resize!.length}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    /*Get.to(() => ResizeScreen(
                                resize: resize!
                              ))!.then((value) {
                                Fluttertoast.showToast(
                                    msg: "Resize length: ${resize!.length}",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              });*/
                  });
                } else if (i == 6) {
                  Get.to(() =>
                      ImageEditorScreen(file: cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value]));
                } else if (i == 7) {
                  Get.to(() => ImageSizeRatioScreen(),
                      arguments: cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value]);

                  //Get.to(() => ImageEditorScreen(file: widget.file));
                }
                // else if (i == 8) {
                //   Get.to(() => ImageSizeRatioScreen(),
                //       arguments: cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value]);
                //
                //   //Get.to(() => ImageEditorScreen(file: widget.file));
                // }
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
                    iconList[index],
                    scale: 2,
                  )),
                ),
              ),
            );
          }),
    );
  }

  Future compressImage(File file) async {
    print("file: $file");
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
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
      // cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value] = result;
    });
    // setState Required
    setState(() {});
    print("compressFile: ${compressFile!.lengthSync()}");
    // setState(() {
    //
    // });
  }

  imageLib.Image? imageTemp;

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
      cameraScreenController.addImageFromCameraList[cameraScreenController.selectedImage.value] = croppedFile;
      setState(() {});
      //setState(() {
      // state = AppState.cropped;
      //});
    }
  }
}
