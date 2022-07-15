import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'package:pixytrim/controller/photo_blend_controller/photo_blend_controller.dart';
// import 'package:search_choices/search_choices.dart';
import 'dart:ui' as ui;
import '../../common/common_widgets.dart';
import '../../common/custom_color.dart';
import '../../common/custom_image.dart';



class PhotoBlendScreen extends StatefulWidget {
  @override
  State<PhotoBlendScreen> createState() => _PhotoBlendScreenState();
}

class _PhotoBlendScreenState extends State<PhotoBlendScreen> {
  final GlobalKey key = GlobalKey();

  GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  PhotoBlendController blendController =
      Get.put(PhotoBlendController());

  CameraScreenController csController = Get.find<CameraScreenController>();

  @override
  Widget build(BuildContext context) {
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
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    appBar(),
                    SizedBox(height: 20),
                    imageList(),
                    SizedBox(height: 20),
                    colorBlendingToolsList(),
                    SizedBox(height: 5),
                    Container(
                      height: 48,
                      child: blendController.adWidget,
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
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
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
                      return showAlertDialog();
                    },
                    child: Container(
                        child: Image.asset(
                      Images.ic_left_arrow,
                      scale: 2.5,
                    )),
                  ),
                  Container(
                    child: Text(
                      "Photo Blend",
                      // csController.selectedModule == SelectedModule.camera
                      //     ? "Camera"
                      //     : "Gallery",
                      style: TextStyle(
                          fontFamily: "",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      showTopNotification(
                        displayText: "Please Wait...",
                        leadingIcon: Icon(
                          Icons.image,
                          color: AppColor.kBlackColor,
                        ),
                        displayTime: 2,
                      );
                      // Fluttertoast.showToast(
                      //   msg: 'Please Wait...',
                      //   toastLength: Toast.LENGTH_LONG,
                      //   timeInSecForIosWeb: 1,
                      // );
                      await _capturePng().then((value) {
                        Get.back();
                      });

                      // saveImage();
                    },
                    child: Container(
                      child: Icon(Icons.check_rounded),
                    ),
                  ),
                ],
              )),
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
      print("Directory: $directory");
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      print("byte data:===$byteData");
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/$imgName.jpg');
      print("Image path: $imgFile");
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        csController.addImageFromCameraList[csController.selectedImage.value] =
            imgFile;
      });
      print(
          "File path====:${csController.addImageFromCameraList[csController.selectedImage.value].path}");
      renameImage();
      // await saveImage();
    } catch (e) {
      print(e);
    }
  }

  renameImage() async {
    String orgPath = csController
        .addImageFromCameraList[csController.selectedImage.value].path;
    String frontPath =
        orgPath.split('app_flutter')[0]; // Getting Front Path of file Path
    print('frontPath: $frontPath');
    List<String> ogPathList = orgPath.split('/');
    print('ogPathList: $ogPathList');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    print('ogExt: $ogExt');
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.day}-${today.month}-${today.year}_${today.hour}:${today.minute}:${today.second}";
    print('Date: $dateSlug');
    csController.addImageFromCameraList[csController.selectedImage.value] =
        await csController
            .addImageFromCameraList[csController.selectedImage.value]
            .rename("${frontPath}cache/pixytrim_$dateSlug.$ogExt");

    print(
        'Final FIle Name : ${csController.addImageFromCameraList[csController.selectedImage.value].path}');
  }

  Widget imageList() {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: RepaintBoundary(
                key: key,
                child: Container(
                    //width: Get.width,
                    child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    blendController.selectedColor.value,
                    blendController.blendMode.value,
                  ),
                  child: Image.file(
                    csController.addImageFromCameraList[
                        csController.selectedImage.value],
                  ),
                )

                    // ExtendedImage(
                    //   // color: bright > 0
                    //   //     ? Colors.white.withOpacity(bright)
                    //   //     : Colors.black.withOpacity(-bright),
                    //   // colorBlendMode:
                    //   //     bright > 0 ? BlendMode.lighten : BlendMode.darken,
                    //   image: ExtendedFileImageProvider(
                    //     csController.addImageFromCameraList[
                    //         csController.selectedImage.value],
                    //   ),
                    //   extendedImageEditorKey: editorKey,
                    //   /*child: Container(
                    //                     width: Get.width,
                    //                     child: ClipRRect(
                    //                       borderRadius: BorderRadius.circular(20),
                    //                       child: widget.file.toString().isNotEmpty
                    //                           ? Image.file(
                    //                               widget.file,
                    //                               height: 120,
                    //                               width: 120,
                    //                               fit: BoxFit.fill,
                    //                             )
                    //                           : null,
                    //                     ),
                    //                   ),*/
                    // ),
                    ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  var searchTextEditingController = TextEditingController();

  Widget colorBlendingToolsList() {
    return Column(
      children: [
        SizedBox(height: 40),
        Container(
          // alignment: AlignmentDirectional.centerStart,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select Color",
                style: TextStyle(
                  color: AppColor.kBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: changeColor,
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              blendController.selectedColor.value = pickerColor;
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 30,
                    width: Get.size.width * 0.5,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      color: blendController.selectedColor.value,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 25),
        // selectColorButton(),
        SizedBox(height: 20),
        // selectBlendModeButton(),
        SizedBox(height: 20),
      ],
    );
  }

  // Widget selectColorButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       showDialog(
  //         context: context,
  //         builder: (ctx) => AlertDialog(
  //           title: const Text('Pick a color!'),
  //           content: SingleChildScrollView(
  //             child: ColorPicker(
  //               pickerColor: pickerColor,
  //               onColorChanged: changeColor,
  //             ),
  //           ),
  //           actions: <Widget>[
  //             ElevatedButton(
  //               child: const Text('Got it'),
  //               onPressed: () {
  //                 blendController.selectedColor.value = pickerColor;
  //                 setState(() {});
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //     child: Container(
  //       margin: EdgeInsets.all(4),
  //       height: 50,
  //       width: Get.size.width * 0.9,
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [
  //             AppColor.kBorderGradientColor1,
  //             AppColor.kBorderGradientColor2,
  //             AppColor.kBorderGradientColor3,
  //           ],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: BorderRadius.all(Radius.circular(15)),
  //       ),
  //       child: Center(
  //         child: Text(
  //           "Select Color",
  //           style: TextStyle(
  //             color: AppColor.kBlackColor.withOpacity(0.8),
  //             fontSize: 20,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget selectBlendModeButton() {
  //   return Container(
  //     height: 50,
  //     width: Get.size.width * 0.9,
  //     padding: EdgeInsets.only(top: 3),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           AppColor.kBorderGradientColor1,
  //           AppColor.kBorderGradientColor2,
  //           AppColor.kBorderGradientColor3,
  //         ],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.all(Radius.circular(15)),
  //     ),
  //     child: SearchChoices.single(
  //       padding: 10,
  //       displayClearIcon: false,
  //       items: blendController.blendingItems,
  //       searchHint: "Search Blend Mode",
  //       hint: blendController.selectedBlendModeText.value,
  //       isExpanded: true,
  //       underline: SizedBox(),
  //       style: TextStyle(
  //         color: AppColor.kBlackColor,
  //         fontWeight: FontWeight.w500,
  //         fontSize: 17,
  //       ),
  //       onChanged: (value) {
  //         setState(() {
  //           blendController.selectedBlendModeText.value = value;
  //         });
  //       },
  //       doneButton: TextButton(
  //         child: Text("Done"),
  //         onPressed: () {
  //           Get.back();
  //         },
  //       ),
  //       displayItem: (item, selected) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(
  //             vertical: 2,
  //             horizontal: 5,
  //           ),
  //           child: Row(
  //             children: [
  //               SizedBox(width: 10),
  //               selected
  //                   ? Icon(
  //                       Icons.radio_button_checked,
  //                       color: Colors.blue,
  //                     )
  //                   : Icon(
  //                       Icons.radio_button_unchecked,
  //                       color: Colors.grey,
  //                     ),
  //               SizedBox(width: 7),
  //               Expanded(
  //                 child: item,
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  showAlertDialog() {
    Widget cancelButton = IconsButton(
      onPressed: () {
        // Get.back();
        Get.back();
      },
      text: 'No',
      color: AppColor.kBorderGradientColor3,
      textStyle: TextStyle(color: Colors.white),
    );

    Widget continueButton = IconsButton(
      onPressed: () async {
        Get.back();
        Get.back();
      },
      text: 'yes',
      color: AppColor.kBorderGradientColor1,
      textStyle: TextStyle(color: Colors.white),
    );

    Dialogs.materialDialog(
      lottieBuilder: LottieBuilder.asset(
        "assets/lotties/9511-loading.json",
      ),
      color: Colors.white,
      msg: "Do you want to exit?",
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
}
