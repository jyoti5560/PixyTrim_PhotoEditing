import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';

class WallPapersScreen extends StatefulWidget {
  WallPapersScreen({Key? key}) : super(key: key);

  @override
  _WallPapersScreenState createState() => _WallPapersScreenState();
}

class _WallPapersScreenState extends State<WallPapersScreen> {
  final collageScreenController = Get.find<CollageScreenController>();

  final ImagePicker imagePicker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      height: 60,
      width: Get.width,
      margin: EdgeInsets.only(right: 8),
      decoration: borderGradientDecoration(),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: collageScreenController.wallpapers.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          collageScreenController.isActiveWallpaper.value = true;
                          collageScreenController.activeWallpaper.value = index;
                          print('selectedIndex : ${collageScreenController.activeWallpaper.value}');
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: AssetImage(collageScreenController.wallpapers[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // GestureDetector(
              //   onTap: (){
              //     openGallery();
              //   },
              //     child: Icon(Icons.add))
            ],
          )
      ),

    );

  }

  void openGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        collageScreenController.file = File(image.path);
        print('Camera File Path : ${collageScreenController.file}');
        print('Camera Image Path : ${image.path}');
        //Fluttertoast.showToast(msg: '${image.path}', toastLength: Toast.LENGTH_LONG);
        //renameImage();
      });
      // Get.to(()=>
      //     CameraScreen(), arguments: [file, SelectedModule.gallery]
      // );
    } else {}
  }
}
