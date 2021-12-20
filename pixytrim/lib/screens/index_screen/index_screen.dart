import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';
import 'package:pixytrim/screens/camera_screen/camera_screen.dart';
import 'package:pixytrim/screens/collage_screen/collage_screen.dart';
import 'package:pixytrim/screens/signin_screen/signin_screen.dart';
import 'package:pixytrim/screens/trim_video_screen/trim_video_screen.dart';


class IndexScreen extends StatefulWidget {
  //IndexScreen({Key? key}) : super(key: key);

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final ImagePicker imagePicker = ImagePicker();

  //IndexScreenController indexScreenController = Get.put(IndexScreenController());
  CollageScreenController collageScreenController = Get.put(CollageScreenController());

  File ? file;
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
                  Container(
                    child: Text(
                      "Pixy Trim",
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  Container(
                    height: Get.height * 0.45,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: borderGradientDecoration(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          decoration: containerBackgroundGradient(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  Images.ic_gallery,
                                                  scale: 2.5,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Gallery",
                                                  style:
                                                  TextStyle(fontFamily: "", fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                                              //Get.to(() => CameraScreen());
                                              openCamera();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                decoration: borderGradientDecoration(),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3),
                                                  child: Container(
                                                    decoration: containerBackgroundGradient(),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          Images.ic_camera,
                                                          scale: 2.5,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "Camera",
                                                          style: TextStyle(
                                                              fontFamily: "",
                                                              fontSize: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ),

                                      // Trim Video Module
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            //Get.to(()=> TrimVideo(file: file!,));
                                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                                              type: FileType.video,
                                              allowCompression: false,
                                            );
                                            if (result != null) {
                                              File file1 = File(result.files.single.path!);
                                              Get.to(()=> TrimVideo(file: file1,));
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Container(
                                              decoration: borderGradientDecoration(),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3),
                                                child: Container(
                                                  decoration: containerBackgroundGradient(),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        Images.ic_trim_video,
                                                        scale: 2.5,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Trim Video",
                                                        style: TextStyle(
                                                            fontFamily: "",
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
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
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: (){
                              //camera();
                              selectImages();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: borderGradientDecoration(),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    decoration: containerBackgroundGradient(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Images.ic_layout,
                                          scale: 3.2,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Collage",
                                          style: TextStyle(
                                            fontFamily: "",
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: (){
                              Get.to(() => SignInScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: borderGradientDecoration(),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    decoration: containerBackgroundGradient(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Images.ic_layout,
                                          scale: 3.2,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Login",
                                          style: TextStyle(
                                            fontFamily: "",
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
          CameraScreen(/*file: file!*/), arguments: [file, SelectedModule.camera]);

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
    print('${selectedImages!.length}');
    try{
      if(selectedImages.isEmpty){
      } else if(selectedImages.length == 1 ){

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please select minimum 2 images"),
        ));
       // Get.snackbar("Please select minimum 2 image", "", snackPosition: SnackPosition.BOTTOM, );
      } else if(selectedImages.length >= 2 && selectedImages.length <= 7){
        setState(() {
          collageScreenController.imageFileList.clear();
          collageScreenController.imageFileList.addAll(selectedImages);
        });
        Get.to(()=> CollageScreen());
      } else if(selectedImages.length >= 8 ){

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please select Maximum 7 images"),
        ));
        // Get.snackbar("Please select minimum 2 image", "", snackPosition: SnackPosition.BOTTOM, );
      }
    } catch(e) {
      print('Error : $e');
    }

    print('Images List Length : ${collageScreenController.imageFileList.length}');
  }
}



