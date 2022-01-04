import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'dart:ui' as ui;


class FilterScreen extends StatefulWidget {
  @override
  FilterScreenState createState() => FilterScreenState();
}
class FilterScreenState extends State<FilterScreen> {
  // FilterScreenController filterScreenController = Get.put(FilterScreenController());
  CameraScreenController csController = Get.find<CameraScreenController>();
  File? file;
  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print('selectedImage : ${csController.selectedImage.value}');
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
          body: SafeArea(
            child: Stack(
        children: [
            MainBackgroundWidget(),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  appBar(),
                  SizedBox(height: 20),
                  Expanded(child: filterImage()),
                  SizedBox(height: 20),
                  filterList()
                ],
              ),
            )
        ],
      ),
          )),
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
                      // Fluttertoast.showToast(
                      //     msg: "Save In to Gallery",
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.BOTTOM,
                      //     timeInSecForIosWeb: 5,
                      //     backgroundColor: Colors.blue,
                      //     textColor: Colors.white,
                      //     fontSize: 16.0
                      // );
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
      height: 120,
      child: ListView.builder(
        itemCount: csController.filterOptions.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              setState(() {
                csController.selectedIndex.value = index;
                print(
                    'selectedIndex : ${csController.selectedIndex.value}');
              });
            },
            child: Container(
              // width: 100,
              child: Column(
                children: [
                  Container(
                    height: Get.height / 8,

                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(right: 10),
                    decoration: borderGradientDecoration(),
                    child: Container(
                      height: 95,
                      width: 95,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            csController.filterOptions[index].filterListWidget,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${csController.filterOptions[index].filterName}",
                     style: TextStyle(fontFamily: "",
                         color: csController.selectedIndex.value == index ? Colors.black87 : Colors.grey.shade600,
                     fontWeight: csController.selectedIndex.value == index ? FontWeight.bold : FontWeight.normal),
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
    return Obx(
      ()=> Container(
        // width: Get.width,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: RepaintBoundary(
              key: key,
              child: csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 0
                  ? csController.filterOptions[0].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 1
                  ? csController.filterOptions[1].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 2
                  ? csController.filterOptions[2].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 3
                  ? csController.filterOptions[3].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 4
                  ? csController.filterOptions[4].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 5
                  ? csController.filterOptions[5].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 6
                  ? csController.filterOptions[6].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 7
                  ? csController.filterOptions[7].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 8
                  ? csController.filterOptions[8].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 9
                  ? csController.filterOptions[9].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.selectedIndex.value == 10
                  ? csController.filterOptions[10].filterWidget
                  : Container(),
            )
        ),
      ),
    );
  }

  Future _capturePng() async {
    try {
      DateTime time = DateTime.now();
      String imgName = "${time.hour}-${time.minute}-${time.second}";
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
      File imgFile = new File('$directory/$imgName.jpg');
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        csController.addImageFromCameraList[csController.selectedImage.value] = imgFile;
      });
      print("File path====:${csController.addImageFromCameraList[csController.selectedImage.value].path}");

      // await saveImage();
    } catch (e) {
      print(e);
    }
  }

  showAlertDialog() {

    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(fontFamily: ""),),
      onPressed:  () {
        Get.back();
        //Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes", style: TextStyle(fontFamily: ""),),
      onPressed:  () async{
        //await _capturePng().then((value) {
          Get.back();
          Get.back();
        //});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("AlertDialog"),
      content: Text("Do you want to exit?", style: TextStyle(fontFamily: ""),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Future saveImage() async {
  //   await GallerySaver.saveImage("${csController.addImageFromCameraList[csController.selectedImage.value].path}",
  //       albumName: "OTWPhotoEditingDemo");
  // }


}
