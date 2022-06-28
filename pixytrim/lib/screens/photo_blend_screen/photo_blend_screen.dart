import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'package:pixytrim/controller/photo_blend_controller/photo_blend_controller.dart';

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

  PhotoBlendController imageSizeRatioController =
      Get.put(PhotoBlendController());

  CameraScreenController csController = Get.find<CameraScreenController>();

  PhotoBlendController blendController = Get.find<PhotoBlendController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showAlertDialog();
      },
      child: Scaffold(
        body: SafeArea(
          child: DirectSelectContainer(
            child: Stack(
              children: [
                MainBackgroundWidget(),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                  child: Column(
                    children: [
                      appBar(),
                      SizedBox(height: 20),
                      imageList(),
                      SizedBox(height: 20),
                      colorBlendingToolsList(),
                    ],
                  ),
                )
              ],
            ),
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
                      // await _capturePng().then((value) {
                      Get.back();
                      // });

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
        Container(
          alignment: AlignmentDirectional.centerStart,
          margin: EdgeInsets.only(left: 4),
          child: Text("City"),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Card(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Padding(
                        child: DirectSelectList<String>(
                            values: blendController.blendModesList,
                            defaultItemIndex: 3,
                            itemBuilder: (String value) =>
                                getDropDownMenuItem(value),
                            focusedItemDecoration: _getDslDecoration(),
                            onItemSelectedListener: (item, index, context) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(item),
                                ),
                              );
                            }),
                        padding: EdgeInsets.only(left: 12))),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.unfold_more,
                    color: Colors.black38,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
        selectColorButton(),
        SizedBox(height: 40),
      ],
    );
  }

  GestureDetector selectColorButton() {
    return GestureDetector(
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
            colors: [
              AppColor.kBorderGradientColor1,
              AppColor.kBorderGradientColor2,
              AppColor.kBorderGradientColor3,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(4),
          height: 50,
          width: Get.size.width * 0.9,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.kBorderGradientColor2,
                AppColor.kBorderGradientColor1,
                // AppColor.kBorderGradientColor3,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Center(
            child: Text(
              "Select Color",
              style: TextStyle(
                color: AppColor.kBlackColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

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
