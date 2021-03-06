import 'dart:io';
// import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_color.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';
import 'package:pixytrim/models/collage_screen_model/single_image_file_model.dart';
import 'package:pixytrim/screens/camera_screen/camera_screen.dart';
import 'package:pixytrim/screens/collage_screen/collage_screen.dart';
//import 'package:pixytrim/screens/live_image_capture_screen/live_image_capture_screen.dart';
import 'package:pixytrim/screens/previous_session_screen/previous_session_screen.dart';

import 'index_screen_widgets.dart';
// import 'package:pixytrim/screens/trim_video_screen/trim_video_screen.dart';

class IndexScreen extends StatefulWidget {
  //IndexScreen({Key? key}) : super(key: key);

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final ImagePicker imagePicker = ImagePicker();

  CollageScreenController collageScreenController =
      Get.put(CollageScreenController());

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
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Header Name "Pixy Trim"
                          HeaderTextModule(),
                          Container(
                            height: Get.height * 0.32,
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
                                                  onTap: () {
                                                    selectImages();
                                                  },
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
                                    onTap: () {
                                      Get.to(() => PreviousSessionScreen());
                                    },
                                    child: LocalStoreDataModule(),
                                  ),
                                ),
                                /* Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () {
                                //Get.to(()=> LiveImageCaptureScreen());
                              },
                              child: LiveImageCaptureModule(),
                            ),
                          ),*/
                              ],
                            ),
                          ),
                          Container(),
                        ],
                      ),
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
    final image = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      collageScreenController.isLoading(true);
      setState(() {
        file = File(image.path);
        print('Camera File Path : $file');
        print('Camera Image Path : ${image.path}');
        //Fluttertoast.showToast(msg: '${image.path}', toastLength: Toast.LENGTH_LONG);
        //renameImage();
      });

      var result = await compressImageFile(file!);
      collageScreenController.isLoading(false);

      Get.to(
        () => CameraScreen(),
        arguments: [
          result,
          SelectedModule.camera,
        ],
      );
    } else {}
  }

  void openGallery() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    var result;
    if (image != null) {
      collageScreenController.isLoading(true);
      setState(() {
        file = File(image.path);
        print('Camera File Path : $file');
        print('Camera Image Path : ${image.path}');
        //Fluttertoast.showToast(msg: '${image.path}', toastLength: Toast.LENGTH_LONG);
        //renameImage();
      });
      var result = await compressImageFile(file!);
      collageScreenController.isLoading(false);
      Get.to(
        () => CameraScreen(),
        arguments: [
          result,
          SelectedModule.gallery,
        ],
      );
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
        //todo - loader true
        collageScreenController.isLoading(true);
        // selectedImages.map((image) async {
        //   var img = await compressImageFile(File(image.path));
        //   image = XFile(img.path);
        // }).toList();

        // forEach((image) async {
        //   var comFile = await compressImageFile(
        //     File(image.path),
        //   );

        //   image = XFile(comFile.path);
        // });
        // for (int i = 0; i <= selectedImages.length; i++) {
        //   var img = selectedImages[i];

        //   var comFile = await compressImageFile(File(img.path));

        //   selectedImages[i] = XFile(comFile.path);
        // }

        collageScreenController.imageFileList.clear();
        for (int i = 0; i < selectedImages.length; i++) {
          var comFile = await compressImageFile(File(selectedImages[i].path));

          selectedImages[i] = XFile(comFile.path);
          setState(() {
            collageScreenController.imageFileList
                .add(ImageFileItem(file: selectedImages[i]));
          });
        }
        //todo - loader false
        collageScreenController.isLoading(false);
        Get.to(() => CollageScreen());
      } else if (selectedImages.length >= 8) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Maximum 7 images"),
        ));
        // Get.snackbar("Please select minimum 2 image", "", snackPosition: SnackPosition.BOTTOM, );
      }
    } catch (e) {
      Exception(e);
      throw e;
      // print('Error : $e');
    }

    print(
        'Images List Length : ${collageScreenController.imageFileList.length}');
  }
}
