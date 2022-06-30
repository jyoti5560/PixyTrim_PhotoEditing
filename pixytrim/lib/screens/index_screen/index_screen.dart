import 'dart:io';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';
import 'package:pixytrim/controller/index_screen_controller/index_screen_controller.dart';
import 'package:pixytrim/models/collage_screen_model/single_image_file_model.dart';
import 'package:pixytrim/screens/camera_screen/camera_screen.dart';
import 'package:pixytrim/screens/collage_screen/collage_screen.dart';
//import 'package:pixytrim/screens/live_image_capture_screen/live_image_capture_screen.dart';
import 'package:pixytrim/screens/previous_session_screen/previous_session_screen.dart';
import 'package:pixytrim/screens/profile_screen/profile_screen.dart';

import '../../common/custom_color.dart';
import '../../common/helper/ad_helper.dart';
import 'index_screen_widgets.dart';
// import 'package:pixytrim/screens/trim_video_screen/trim_video_screen.dart';

class IndexScreen extends StatefulWidget {
  //IndexScreen({Key? key}) : super(key: key);
  UserCredential? result;
  IndexScreen({this.result});

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final ImagePicker imagePicker = ImagePicker();

  CollageScreenController collageScreenController =
      Get.put(CollageScreenController());

  IndexScreenController indexController = Get.put(IndexScreenController());

  File? file;
  File? compressFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MainBackgroundWidget(),
          Obx(
            () => collageScreenController.isLoading.value
                ? LoadingAnimationWidget.inkDrop(
                    size: Get.size.width * 0.1,
                    color: AppColor.kBorderGradientColor1,
                  )
                : SafeArea(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Header Name "Pixy Trim"
                            SizedBox(height: Get.size.height * 0.01),
                            HeaderTextModule(),
                            Container(
                              height: Get.height * 0.40,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Row(
                                      children: [
                                        // Gallery Module
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              openGallery();
                                            },
                                            child: GalleryModule(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                // Camera Module
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      openCamera();
                                                    },
                                                    child: CameraModule(),
                                                  ),
                                                ),

                                                // Trim Video Module
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () => selectImages(),
                                                    child: CollageModule(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () =>
                                          Get.to(() => PreviousSessionScreen()),
                                      child: LocalStoreDataModule(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => ProfileScreen(
                                              result: widget.result,
                                            ));
                                      },
                                      child: AddProfile(),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 48,
                              child: indexController.adWidget,
                            )
                          ],
                        ),
                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: Container(
                        //     height: 50,
                        //     child: indexController.adWidget,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<File> compressImageFile(
    File imageFile,
  ) async {
    var filepath = imageFile.absolute.path;
    File? result;

    if (filepath.endsWith(".jpg")) {
      print("image ids jpg or jpeg");
      final lastIndex = filepath.lastIndexOf(new RegExp(r'.jp'));
      final splitted = filepath.substring(0, (lastIndex));
      final outPath = "${splitted}_in${filepath.substring(lastIndex)}";
      var beforesize = ImageSizeGetter.getSize(FileInput(imageFile));
      print("file path before compress : $filepath");
      print("size before compress : $beforesize");

      result = await FlutterImageCompress.compressAndGetFile(
        filepath,
        outPath,
        quality: 75,
        format: CompressFormat.jpeg,
      );

      print("path after compress : ${result!.path} ");
      var size = ImageSizeGetter.getSize(FileInput(result));
      print("size after compress : $size ");
    } else if (filepath.endsWith(".png")) {
      print("image is png");
      final lastIndex = filepath.lastIndexOf(new RegExp(r'.pn'));
      final splitted = filepath.substring(0, (lastIndex));
      final outPath = "${splitted}_in${filepath.substring(lastIndex)}";
      var beforesize = ImageSizeGetter.getSize(FileInput(imageFile));
      print("file path before compress : $filepath");
      print("size before compress : $beforesize");

      result = await FlutterImageCompress.compressAndGetFile(
        filepath,
        outPath,
        quality: 75,
        format: CompressFormat.png,
      );

      print("path after compress : ${result!.path} ");
      var size = ImageSizeGetter.getSize(FileInput(result));
      print("size after compress : $size ");
    }
    return result!;
  }

  void openCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        file = File(image.path);
        print('Camera File Path : $file');
        print('Camera Image Path : ${image.path}');
        //Fluttertoast.showToast(msg: '${image.path}', toastLength: Toast.LENGTH_LONG);
        //renameImage();
      });
      Get.to(() => CameraScreen(), arguments: [file, SelectedModule.camera]);
    } else {}
  }

  void openGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        file = File(image.path);
        print('Camera File Path : $file');
        print('Camera Image Path : ${image.path}');
        //Fluttertoast.showToast(msg: '${image.path}', toastLength: Toast.LENGTH_LONG);
        //renameImage();
      });
      Get.to(() => CameraScreen(), arguments: [file, SelectedModule.gallery]);
    } else {}
  }

  // Select Multiple Images From Gallery
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    // print('${selectedImages!.length}');
    try {
      if (selectedImages!.isEmpty) {
      } else if (selectedImages.length == 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Minimum 2 images"),
        ));
      } else if (selectedImages.length >= 2 && selectedImages.length <= 7) {
        setState(() {
          collageScreenController.imageFileList.clear();
          for (int i = 0; i < selectedImages.length; i++) {
            collageScreenController.imageFileList
                .add(ImageFileItem(file: selectedImages[i]));
          }
        });
        Get.to(() => CollageScreen());
      } else if (selectedImages.length >= 8) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Maximum 7 images"),
        ));
        // Get.snackbar("Please select minimum 2 image", "", snackPosition: SnackPosition.BOTTOM, );
      }
    } catch (e) {
      print('Error : $e');
    }

    print(
        'Images List Length : ${collageScreenController.imageFileList.length}');
  }
}
