import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/filter_screen_controller/filter_screen_controller.dart';
import 'dart:ui' as ui;

class FilterScreen extends StatefulWidget {
  @override
  FilterScreenState createState() => FilterScreenState();
}
class FilterScreenState extends State<FilterScreen> {
  FilterScreenController filterScreenController = Get.put(FilterScreenController());
  File? file;
  final GlobalKey key = GlobalKey();

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
                  child: filterImage()
              ),

              SizedBox(height: 20),
              filterList()
            ],
          ),
        )
      ],
    ));
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
                    "Filter",
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

  Widget filterList() {
    return Container(
      height: Get.height / 6.5,
      child: ListView.builder(
        itemCount: filterScreenController.filterOptions.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              setState(() {
                filterScreenController.selectedIndex.value = index;
                print(
                    'selectedIndex : ${filterScreenController.selectedIndex.value}');
              });
            },
            child: Container(
              width: Get.width/3.5,
              child: Column(
                children: [
                  Container(
                    height: Get.height/8,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(right: 10),
                    decoration: borderGradientDecoration(),
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                          child: filterScreenController.filterOptions[index].filterWidget,
                    ),
                  ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${filterScreenController.filterOptions[index].filterName}",
                     style: TextStyle(fontFamily: "",
                         color: filterScreenController.selectedIndex.value == index ? Colors.black87 : Colors.grey.shade600,
                     fontWeight: filterScreenController.selectedIndex.value == index ? FontWeight.bold : FontWeight.normal),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget filterImage(){
    return Container(
      width: Get.width,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: RepaintBoundary(
            key: key,
            child: filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 0
                ? filterScreenController.filterOptions[0].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 1
                ? filterScreenController.filterOptions[1].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 2
                ? filterScreenController.filterOptions[2].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 3
                ? filterScreenController.filterOptions[3].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 4
                ? filterScreenController.filterOptions[4].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 5
                ? filterScreenController.filterOptions[5].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 6
                ? filterScreenController.filterOptions[6].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 7
                ? filterScreenController.filterOptions[7].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 8
                ? filterScreenController.filterOptions[8].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 9
                ? filterScreenController.filterOptions[9].filterWidget
                : filterScreenController.file.toString().isNotEmpty && filterScreenController.selectedIndex.value == 10
                ? filterScreenController.filterOptions[10].filterWidget
                : Container(),
          )
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


}
