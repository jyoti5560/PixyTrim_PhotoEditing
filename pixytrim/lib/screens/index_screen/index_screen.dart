import 'dart:io';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixytrim/common/common_widgets.dart';
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

  CollageScreenController collageScreenController = Get.put(CollageScreenController());

  File? file;
  File? compressFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MainBackgroundWidget(),

          SafeArea(
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
                                            onTap: (){
                                              openCamera();
                                            },
                                            child: CameraModule(),
                                          ),
                                      ),

                                      // Trim Video Module
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){
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
                            onTap: (){
                              Get.to(()=> PreviousSessionScreen());
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
        ],
      ),
    );
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
      Get.to(()=>
          CameraScreen(), arguments: [file, SelectedModule.camera]);

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
      Get.to(()=>
          CameraScreen(), arguments: [file, SelectedModule.gallery]
      );
    } else {}
  }

  // Select Multiple Images From Gallery
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    // print('${selectedImages!.length}');
    try{
      if(selectedImages!.isEmpty){
      } else if(selectedImages.length == 1 ){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Minimum 2 images"),
        ));
      } else if(selectedImages.length >= 2 && selectedImages.length <= 7){
        setState(() {
          collageScreenController.imageFileList.clear();
          for(int i =0; i< selectedImages.length; i++){
            collageScreenController.imageFileList.add(ImageFileItem(file: selectedImages[i]));
          }
        });
        Get.to(()=> CollageScreen());
      } else if(selectedImages.length >= 8 ){

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Maximum 7 images"),
        ));
        // Get.snackbar("Please select minimum 2 image", "", snackPosition: SnackPosition.BOTTOM, );
      }
    } catch(e) {
      print('Error : $e');
    }

    print('Images List Length : ${collageScreenController.imageFileList.length}');
  }
}



