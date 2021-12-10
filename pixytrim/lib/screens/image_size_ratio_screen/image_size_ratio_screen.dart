import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/image_size_ratio_controller/image_size_ratio_controller.dart';
import 'dart:ui' as ui;

class ImageSizeRatioScreen extends StatefulWidget {
  //File file;
  //ImageSizeRatioScreen({required this.file});
  //const ImageSizeRatioScreen({Key? key}) : super(key: key);

  @override
  _ImageSizeRatioScreenState createState() => _ImageSizeRatioScreenState();
}

class _ImageSizeRatioScreenState extends State<ImageSizeRatioScreen> {

  final GlobalKey key = GlobalKey();
  ImageSizeRatioController imageSizeRatioController = Get.put(ImageSizeRatioController());
  int ? imageRatioIndex;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainBackgroundWidget(),

          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                appBar(),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ratioImage()
                ),

                SizedBox(height: 20),

                ratioList()
              ],
            ),
          )
        ],
      )
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
                    Get.back();
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
                    await _capturePng().then((value) {
                      Fluttertoast.showToast(
                          msg: "Save In to Gallery",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      Get.back();
                    });
                  },
                  child: Container(child: Icon(Icons.check_rounded)),
                ),
              ],
            )),
      ),
    );
  }

  Future _capturePng() async {
    try {
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
      File imgFile = new File('$directory/photo.png');
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        file = imgFile;
      });
      print("File path====:${file!.path}");
      //collageScreenController.imageFileList = pngBytes;
      //bs64 = base64Encode(pngBytes);
      print("png Bytes:====$pngBytes");
      //print("bs64:====$bs64");
      //setState(() {});
      await saveImage();
    } catch (e) {
      print(e);
    }
  }

  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage("${file!.path}",
        albumName: "OTWPhotoEditingDemo");
  }

  Widget ratioImage(){
    return Obx(
      ()=> Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey)
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: RepaintBoundary(
              key: key,
              child: imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 0
                  ? imageSizeRatioController.sizeOptions[0].sizeWidget
                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 1
                  ? imageSizeRatioController.sizeOptions[1].sizeWidget
                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 2
                  ? imageSizeRatioController.sizeOptions[2].sizeWidget
                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 3
                  ? imageSizeRatioController.sizeOptions[3].sizeWidget
                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 4
                  ? imageSizeRatioController.sizeOptions[4].sizeWidget
                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 5
                  ? imageSizeRatioController.sizeOptions[5].sizeWidget
                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 6
                  ? imageSizeRatioController.sizeOptions[6].sizeWidget
                  : imageSizeRatioController.file.toString().isNotEmpty && imageSizeRatioController.selectedIndex.value == 7
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
            )
        ),
      ),
    );
  }

  Widget ratioList() {
    return Container(
      height: Get.height / 6.5,
      child: ListView.builder(
        itemCount: imageSizeRatioController.sizeOptions.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
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
              setState(() {
                imageSizeRatioController.selectedIndex.value = index;
                print('index : $index');
                print('selectedIndex : ${imageSizeRatioController.selectedIndex.value}');
              });
            },
            child: Container(
              width: Get.width/3.5,
              child: Column(
                children: [
                  Container(
                    height: Get.height/8,
                    child: Image.asset(imageSizeRatioController.sizeOptions[index].image),


                  ),
                  SizedBox(height: 5),
                  Text(
                    "${imageSizeRatioController.sizeOptions[index].sizeName}",
                    style: TextStyle(fontFamily: "",
                        color: imageSizeRatioController.selectedIndex.value == index ? Colors.black87 : Colors.grey.shade600,
                        fontWeight: imageSizeRatioController.selectedIndex.value == index ? FontWeight.bold : FontWeight.normal),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
