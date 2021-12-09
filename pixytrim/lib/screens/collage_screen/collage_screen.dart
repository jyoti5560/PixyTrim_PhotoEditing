import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';
import 'package:pixytrim/screens/collage_screen/border_color_screen/border_color_screen.dart';
import 'package:pixytrim/screens/collage_screen/border_radius_screen/border_radius_screen.dart';
import 'package:pixytrim/screens/collage_screen/border_width_screen/border_width_screen.dart';
import 'package:pixytrim/screens/collage_screen/layout_screen/layout_screen.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

class CollageScreen extends StatefulWidget {
  //const CollageScreen({Key? key}) : super(key: key);

  // File file;
  // CollageScreen({required this.file});

  @override
  _CollageScreenState createState() => _CollageScreenState();
}

class _CollageScreenState extends State<CollageScreen>
    with SingleTickerProviderStateMixin {
  CollageScreenController collageScreenController =
      Get.find<CollageScreenController>();

  late TabController _tabController;
  final GlobalKey key = GlobalKey();
  File? file;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                    child: RepaintBoundary(
                  key: key,
                  child: Container(
                    width: Get.width,
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(20)
                    // ),
                    child: Obx(
                      () => collageScreenController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : ImageListModule(),
                    ),
                  ),
                )),
                tabBar(),
                tabBarView()
              ],
            ),
          )
        ],
      ),
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
                  child: Container(child: Icon(Icons.close)),
                ),
                Container(
                  child: Text(
                    "Collage",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    //Get.back();
                    await _capturePng();
                  },
                  child: Container(
                      child: Image.asset(
                    Images.ic_downloading,
                    scale: 2,
                  )),
                ),
              ],
            )),
      ),
    );
  }

  Widget tabBar() {
    return Container(
      child: TabBar(
        isScrollable: true,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.black,
        labelPadding:
            EdgeInsets.only(top: 10.0, bottom: 5, left: 10, right: 10),
        unselectedLabelColor: Colors.black38,
        controller: _tabController,
        labelStyle: TextStyle(fontSize: 17),
        tabs: [
          Container(
            child: Tab(text: "Layout"),
          ),
          Container(
            child: Tab(text: "Border Width"),
          ),
          Container(
            child: Tab(text: "Border Color"),
          ),
          Container(
            child: Tab(text: "Border Radius"),
          ),
        ],
      ),
    );
  }

  Widget tabBarView() {
    return Container(
      height: Get.height * 0.08,
      child: TabBarView(
        controller: _tabController,
        children: [
          // BottomBarModule(),
          // BorderwidthModule(),
          // BorderColorModule(),
          // BorderRadiusModule(),
          LayoutScreen(),
          BorderWidthScreen(),
          BorderColorScreen(),
          BorderRadiusScreen(),
        ],
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

class ImageListModule extends StatefulWidget {
  const ImageListModule({Key? key}) : super(key: key);

  @override
  _ImageListModuleState createState() => _ImageListModuleState();
}

class _ImageListModuleState extends State<ImageListModule> {
  CollageScreenController collageScreenController =
      Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => collageScreenController.imageFileList.length == 1
          ? singleImageSelectedModule()
          : collageScreenController.imageFileList.length == 2
              ? twoImageSelectedModule(
                  collageScreenController.selectedIndex.value)
          : collageScreenController.imageFileList.length == 3
          ? threeImageSelectedModule(
          collageScreenController.selectedIndex.value)
          : collageScreenController.imageFileList.length == 4
          ? fourImageSelectedModule(
          collageScreenController.selectedIndex.value)
          : collageScreenController.imageFileList.length == 5
          ? fiveImageSelectedModule(
          collageScreenController.selectedIndex.value)
          : collageScreenController.imageFileList.length == 6
          ? sixImageSelectedModule(
          collageScreenController.selectedIndex.value)
              : Container(),
    );
  }

  Widget singleImageSelectedModule() {
    return Container(
      child:
          Image.file(File('${collageScreenController.imageFileList[0].path}')),
    );
  }

  Widget twoImageSelectedModule(int selectedIndex) {
    return Obx(() =>
      selectedIndex == 0
        ? ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                  color: collageScreenController
                      .borderColor[collageScreenController.activeColor.value]),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                              collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                              collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : selectedIndex == 1
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      // border: Border.all(color: Colors.red, width: 5),
                      color: collageScreenController.borderColor[
                          collageScreenController.activeColor.value]),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: collageScreenController
                                  .borderWidthValue.value,
                              right: collageScreenController
                                  .borderWidthValue.value,
                              top: collageScreenController
                                  .borderWidthValue.value,
                              bottom: collageScreenController
                                  .borderWidthValue.value),
                          child: Container(
                            //width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  collageScreenController
                                      .borderRadiusValue.value),
                              color: Colors.white,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(
                                      '${collageScreenController.imageFileList[0].path}'))),
                            ),
                            // child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: collageScreenController
                                  .borderWidthValue.value,
                              right: collageScreenController
                                  .borderWidthValue.value,
                              top: collageScreenController
                                  .borderWidthValue.value,
                              bottom: collageScreenController
                                  .borderWidthValue.value),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  collageScreenController
                                      .borderRadiusValue.value),
                              color: Colors.white,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                            ),
                            // child:
                            // Image.file(File('${collageScreenController.imageFileList[1].path}')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : selectedIndex == 2
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                          // border: Border.all(color: Colors.red, width: 5),
                          color: collageScreenController.borderColor[
                              collageScreenController.activeColor.value]),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: collageScreenController
                                      .borderWidthValue.value,
                                  right: collageScreenController
                                      .borderWidthValue.value,
                                  top: collageScreenController
                                      .borderWidthValue.value,
                                  bottom: collageScreenController
                                      .borderWidthValue.value),
                              child: Container(
                                //width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      collageScreenController
                                          .borderRadiusValue.value),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(File(
                                          '${collageScreenController.imageFileList[0].path}'))),
                                ),
                                // child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: collageScreenController
                                      .borderWidthValue.value,
                                  right: collageScreenController
                                      .borderWidthValue.value,
                                  top: collageScreenController
                                      .borderWidthValue.value,
                                  bottom: collageScreenController
                                      .borderWidthValue.value),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      collageScreenController
                                          .borderRadiusValue.value),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(File(
                                          '${collageScreenController.imageFileList[1].path}'))),
                                ),
                                // child:
                                // Image.file(File('${collageScreenController.imageFileList[1].path}')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : selectedIndex == 3
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                              // border: Border.all(color: Colors.red, width: 5),
                              color: collageScreenController.borderColor[
                                  collageScreenController.activeColor.value]),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: collageScreenController
                                          .borderWidthValue.value,
                                      right: collageScreenController
                                          .borderWidthValue.value,
                                      top: collageScreenController
                                          .borderWidthValue.value,
                                      bottom: collageScreenController
                                          .borderWidthValue.value),
                                  child: Container(
                                    //width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          collageScreenController
                                              .borderRadiusValue.value),
                                      color: Colors.white,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(File(
                                              '${collageScreenController.imageFileList[0].path}'))),
                                    ),
                                    // child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: collageScreenController
                                          .borderWidthValue.value,
                                      right: collageScreenController
                                          .borderWidthValue.value,
                                      top: collageScreenController
                                          .borderWidthValue.value,
                                      bottom: collageScreenController
                                          .borderWidthValue.value),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          collageScreenController
                                              .borderRadiusValue.value),
                                      color: Colors.white,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(File(
                                              '${collageScreenController.imageFileList[1].path}'))),
                                    ),
                                    // child:
                                    // Image.file(File('${collageScreenController.imageFileList[1].path}')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : selectedIndex == 4
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.red, width: 5),
                                  color: collageScreenController.borderColor[
                                      collageScreenController
                                          .activeColor.value]),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: collageScreenController
                                              .borderWidthValue.value,
                                          right: collageScreenController
                                              .borderWidthValue.value,
                                          top: collageScreenController
                                              .borderWidthValue.value,
                                          bottom: collageScreenController
                                              .borderWidthValue.value),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              collageScreenController
                                                  .borderRadiusValue.value),
                                          color: Colors.white,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(File(
                                                  '${collageScreenController.imageFileList[0].path}'))),
                                        ),
                                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: collageScreenController
                                              .borderWidthValue.value,
                                          right: collageScreenController
                                              .borderWidthValue.value,
                                          top: collageScreenController
                                              .borderWidthValue.value,
                                          bottom: collageScreenController
                                              .borderWidthValue.value),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              collageScreenController
                                                  .borderRadiusValue.value),
                                          color: Colors.white,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(File(
                                                  '${collageScreenController.imageFileList[1].path}'))),
                                        ),
                                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : selectedIndex == 5
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.red, width: 5),
                                      color:
                                          collageScreenController.borderColor[
                                              collageScreenController
                                                  .activeColor.value]),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: collageScreenController
                                                  .borderWidthValue.value,
                                              right: collageScreenController
                                                  .borderWidthValue.value,
                                              top: collageScreenController
                                                  .borderWidthValue.value,
                                              bottom: collageScreenController
                                                  .borderWidthValue.value),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      collageScreenController
                                                          .borderRadiusValue
                                                          .value),
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(File(
                                                      '${collageScreenController.imageFileList[0].path}'))),
                                            ),
                                            //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: collageScreenController
                                                  .borderWidthValue.value,
                                              right: collageScreenController
                                                  .borderWidthValue.value,
                                              top: collageScreenController
                                                  .borderWidthValue.value,
                                              bottom: collageScreenController
                                                  .borderWidthValue.value),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      collageScreenController
                                                          .borderRadiusValue
                                                          .value),
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(File(
                                                      '${collageScreenController.imageFileList[1].path}'))),
                                            ),
                                            //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : selectedIndex == 6
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // border: Border.all(color: Colors.red, width: 5),
                                          color: collageScreenController
                                                  .borderColor[
                                              collageScreenController
                                                  .activeColor.value]),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(child: Container()),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                        right:
                                                            collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                        top: collageScreenController
                                                            .borderWidthValue
                                                            .value,
                                                        bottom:
                                                            collageScreenController
                                                                .borderWidthValue
                                                                .value),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                collageScreenController
                                                                    .borderRadiusValue
                                                                    .value),
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: FileImage(File(
                                                                '${collageScreenController.imageFileList[0].path}'))),
                                                      ),
                                                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                        right:
                                                            collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                        top: collageScreenController
                                                            .borderWidthValue
                                                            .value,
                                                        bottom:
                                                            collageScreenController
                                                                .borderWidthValue
                                                                .value),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                collageScreenController
                                                                    .borderRadiusValue
                                                                    .value),
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: FileImage(File(
                                                                '${collageScreenController.imageFileList[1].path}'))),
                                                      ),
                                                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(child: Container()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : selectedIndex == 7
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              // border: Border.all(color: Colors.red, width: 5),
                                              color: collageScreenController
                                                      .borderColor[
                                                  collageScreenController
                                                      .activeColor.value]),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                            right: collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                            top: collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                            bottom: collageScreenController
                                                                .borderWidthValue
                                                                .value),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    collageScreenController
                                                                        .borderRadiusValue
                                                                        .value),
                                                            color: Colors.white,
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: FileImage(
                                                                    File(
                                                                        '${collageScreenController.imageFileList[0].path}'))),
                                                          ),
                                                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                        child: Container()),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container()),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                            right: collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                            top: collageScreenController
                                                                .borderWidthValue
                                                                .value,
                                                            bottom: collageScreenController
                                                                .borderWidthValue
                                                                .value),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    collageScreenController
                                                                        .borderRadiusValue
                                                                        .value),
                                                            color: Colors.white,
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: FileImage(
                                                                    File(
                                                                        '${collageScreenController.imageFileList[1].path}'))),
                                                          ),
                                                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : selectedIndex == 8
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  // border: Border.all(color: Colors.red, width: 5),
                                                  color: collageScreenController
                                                          .borderColor[
                                                      collageScreenController
                                                          .activeColor.value]),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Container()),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: collageScreenController
                                                                    .borderWidthValue
                                                                    .value,
                                                                right: collageScreenController
                                                                    .borderWidthValue
                                                                    .value,
                                                                top: collageScreenController
                                                                    .borderWidthValue
                                                                    .value,
                                                                bottom: collageScreenController
                                                                    .borderWidthValue
                                                                    .value),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius.circular(
                                                                    collageScreenController
                                                                        .borderRadiusValue
                                                                        .value),
                                                                color: Colors
                                                                    .white,
                                                                image: DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: FileImage(
                                                                        File(
                                                                            '${collageScreenController.imageFileList[0].path}'))),
                                                              ),
                                                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: collageScreenController
                                                                    .borderWidthValue
                                                                    .value,
                                                                right: collageScreenController
                                                                    .borderWidthValue
                                                                    .value,
                                                                top: collageScreenController
                                                                    .borderWidthValue
                                                                    .value,
                                                                bottom: collageScreenController
                                                                    .borderWidthValue
                                                                    .value),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius.circular(
                                                                    collageScreenController
                                                                        .borderRadiusValue
                                                                        .value),
                                                                color: Colors
                                                                    .white,
                                                                image: DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: FileImage(
                                                                        File(
                                                                            '${collageScreenController.imageFileList[1].path}'))),
                                                              ),
                                                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Container()),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : selectedIndex == 9
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      // border: Border.all(color: Colors.red, width: 5),
                                                      color: collageScreenController
                                                              .borderColor[
                                                          collageScreenController
                                                              .activeColor
                                                              .value]),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: collageScreenController
                                                                        .borderWidthValue
                                                                        .value,
                                                                    right: collageScreenController
                                                                        .borderWidthValue
                                                                        .value,
                                                                    top: collageScreenController
                                                                        .borderWidthValue
                                                                        .value,
                                                                    bottom: collageScreenController
                                                                        .borderWidthValue
                                                                        .value),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(collageScreenController
                                                                            .borderRadiusValue
                                                                            .value),
                                                                    color: Colors
                                                                        .white,
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: FileImage(
                                                                            File('${collageScreenController.imageFileList[0].path}'))),
                                                                  ),
                                                                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container()),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container()),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: collageScreenController
                                                                        .borderWidthValue
                                                                        .value,
                                                                    right: collageScreenController
                                                                        .borderWidthValue
                                                                        .value,
                                                                    top: collageScreenController
                                                                        .borderWidthValue
                                                                        .value,
                                                                    bottom: collageScreenController
                                                                        .borderWidthValue
                                                                        .value),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(collageScreenController
                                                                            .borderRadiusValue
                                                                            .value),
                                                                    color: Colors
                                                                        .white,
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: FileImage(
                                                                            File('${collageScreenController.imageFileList[1].path}'))),
                                                                  ),
                                                                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : selectedIndex == 10
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          // border: Border.all(color: Colors.red, width: 5),
                                                          color: collageScreenController
                                                                  .borderColor[
                                                              collageScreenController
                                                                  .activeColor
                                                                  .value]),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: collageScreenController
                                                                            .borderWidthValue
                                                                            .value,
                                                                        right: collageScreenController
                                                                            .borderWidthValue
                                                                            .value,
                                                                        top: collageScreenController
                                                                            .borderWidthValue
                                                                            .value,
                                                                        bottom: collageScreenController
                                                                            .borderWidthValue
                                                                            .value),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(collageScreenController
                                                                            .borderRadiusValue
                                                                            .value),
                                                                        color: Colors
                                                                            .white,
                                                                        image: DecorationImage(
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                                                                      ),
                                                                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: collageScreenController
                                                                            .borderWidthValue
                                                                            .value,
                                                                        right: collageScreenController
                                                                            .borderWidthValue
                                                                            .value,
                                                                        top: collageScreenController
                                                                            .borderWidthValue
                                                                            .value,
                                                                        bottom: collageScreenController
                                                                            .borderWidthValue
                                                                            .value),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(collageScreenController
                                                                            .borderRadiusValue
                                                                            .value),
                                                                        color: Colors
                                                                            .white,
                                                                        image: DecorationImage(
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                                                                      ),
                                                                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : selectedIndex == 11
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  // border: Border.all(color: Colors.red, width: 5),
                                                                  color: collageScreenController
                                                                          .borderColor[
                                                                      collageScreenController
                                                                          .activeColor
                                                                          .value]),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                collageScreenController.borderWidthValue.value,
                                                                            right: collageScreenController.borderWidthValue.value,
                                                                            top: collageScreenController.borderWidthValue.value,
                                                                            bottom: collageScreenController.borderWidthValue.value),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                                                            color:
                                                                                Colors.white,
                                                                            image:
                                                                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                                                                          ),
                                                                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                collageScreenController.borderWidthValue.value,
                                                                            right: collageScreenController.borderWidthValue.value,
                                                                            top: collageScreenController.borderWidthValue.value,
                                                                            bottom: collageScreenController.borderWidthValue.value),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                                                            color:
                                                                                Colors.white,
                                                                            image:
                                                                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                                                                          ),
                                                                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container());
  }

  Widget threeImageSelectedModule(int selectedIndex) {
    return Obx(() =>
      selectedIndex == 0
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[1].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 1
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController.borderColor[
            collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue.value,
                    right: collageScreenController
                        .borderWidthValue.value,
                    top: collageScreenController
                        .borderWidthValue.value,
                    bottom: collageScreenController
                        .borderWidthValue.value),
                child: Container(
                  //width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  // child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue.value,
                    right: collageScreenController
                        .borderWidthValue.value,
                    top: collageScreenController
                        .borderWidthValue.value,
                    bottom: collageScreenController
                        .borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[1].path}'))),
                  ),
                  // child:
                  // Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue.value,
                    right: collageScreenController
                        .borderWidthValue.value,
                    top: collageScreenController
                        .borderWidthValue.value,
                    bottom: collageScreenController
                        .borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  // child:
                  // Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 2
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController.borderColor[
            collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue.value,
                    right: collageScreenController
                        .borderWidthValue.value,
                    top: collageScreenController
                        .borderWidthValue.value,
                    bottom: collageScreenController
                        .borderWidthValue.value),
                child: Container(
                  //width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  // child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue.value,
                          right: collageScreenController
                              .borderWidthValue.value,
                          top: collageScreenController
                              .borderWidthValue.value,
                          bottom: collageScreenController
                              .borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        // child:
                        // Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue.value,
                          right: collageScreenController
                              .borderWidthValue.value,
                          top: collageScreenController
                              .borderWidthValue.value,
                          bottom: collageScreenController
                              .borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        // child:
                        // Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    )
        : selectedIndex == 3
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController.borderColor[
            collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue.value,
                          right: collageScreenController
                              .borderWidthValue.value,
                          top: collageScreenController
                              .borderWidthValue.value,
                          bottom: collageScreenController
                              .borderWidthValue.value),
                      child: Container(
                        //width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        // child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue.value,
                          right: collageScreenController
                              .borderWidthValue.value,
                          top: collageScreenController
                              .borderWidthValue.value,
                          bottom: collageScreenController
                              .borderWidthValue.value),
                      child: Container(
                        //width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        // child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue.value,
                    right: collageScreenController
                        .borderWidthValue.value,
                    top: collageScreenController
                        .borderWidthValue.value,
                    bottom: collageScreenController
                        .borderWidthValue.value),
                child: Container(
                  //width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  // child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 4
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController.borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue.value,
                          right: collageScreenController
                              .borderWidthValue.value,
                          top: collageScreenController
                              .borderWidthValue.value,
                          bottom: collageScreenController
                              .borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue.value,
                          right: collageScreenController
                              .borderWidthValue.value,
                          top: collageScreenController
                              .borderWidthValue.value,
                          bottom: collageScreenController
                              .borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue.value,
                    right: collageScreenController
                        .borderWidthValue.value,
                    top: collageScreenController
                        .borderWidthValue.value,
                    bottom: collageScreenController
                        .borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 5
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController.borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue.value,
                    right: collageScreenController
                        .borderWidthValue.value,
                    top: collageScreenController
                        .borderWidthValue.value,
                    bottom: collageScreenController
                        .borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue.value,
                          right: collageScreenController
                              .borderWidthValue.value,
                          top: collageScreenController
                              .borderWidthValue.value,
                          bottom: collageScreenController
                              .borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue.value,
                          right: collageScreenController
                              .borderWidthValue.value,
                          top: collageScreenController
                              .borderWidthValue.value,
                          bottom: collageScreenController
                              .borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 6
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 7
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex:1,
                    child: Container()
                  ),

                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                      flex:1,
                      child: Container()
                  ),

                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),

                  Expanded(
                      flex:1,
                      child: Container()
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  Expanded(
                      flex:1,
                      child: Container()
                  ),


                ],
              ),
            ),
          ],
        )

      ),
    )
        : selectedIndex == 8
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 9
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController
                        .borderRadiusValue
                        .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController
                              .borderRadiusValue
                              .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController
                              .borderRadiusValue
                              .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )

      ),
    )
        : selectedIndex == 10
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.red, width: 5),
              color: collageScreenController
                  .borderColor[
              collageScreenController
                  .activeColor
                  .value]),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController
                                .borderWidthValue
                                .value,
                            right: collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom: collageScreenController
                                .borderWidthValue
                                .value),
                        child:
                        Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(collageScreenController
                                .borderRadiusValue
                                .value),
                            color: Colors
                                .white,
                            image: DecorationImage(
                                fit: BoxFit
                                    .cover,
                                image: FileImage(
                                    File('${collageScreenController.imageFileList[0].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5,),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: collageScreenController
                          .borderWidthValue
                          .value,
                      right: collageScreenController
                          .borderWidthValue
                          .value,
                      top: collageScreenController
                          .borderWidthValue
                          .value,
                      bottom: collageScreenController
                          .borderWidthValue
                          .value),
                  child:
                  Container(
                    decoration:
                    BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(collageScreenController
                          .borderRadiusValue
                          .value),
                      color: Colors
                          .white,
                      image: DecorationImage(
                          fit: BoxFit
                              .cover,
                          image: FileImage(
                              File('${collageScreenController.imageFileList[1].path}'))),
                    ),
                    //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: collageScreenController
                          .borderWidthValue
                          .value,
                      right: collageScreenController
                          .borderWidthValue
                          .value,
                      top: collageScreenController
                          .borderWidthValue
                          .value,
                      bottom: collageScreenController
                          .borderWidthValue
                          .value),
                  child:
                  Container(
                    decoration:
                    BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(collageScreenController
                          .borderRadiusValue
                          .value),
                      color: Colors
                          .white,
                      image: DecorationImage(
                          fit: BoxFit
                              .cover,
                          image: FileImage(
                              File('${collageScreenController.imageFileList[2].path}'))),
                    ),
                    //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                  ),
                ),
              ),
            ],
          )

      ),
    )
        : selectedIndex == 11
        ? ClipRRect(
      borderRadius:
      BorderRadius
          .circular(20),
      child: Container(
        decoration:
        BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(child: Container(),),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 12
        ? ClipRRect(
      borderRadius:
      BorderRadius
          .circular(20),
      child: Container(
        decoration:
        BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Row(
          children: [

            Expanded(
              flex: 1,
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 13
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[1].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : Container());
  }

  Widget fourImageSelectedModule(int selectedIndex){
    return Obx(() =>
    selectedIndex == 0
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 1
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 2
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 3
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 4
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 5
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: collageScreenController.borderWidthValue.value,
                        right: collageScreenController.borderWidthValue.value,
                        top: collageScreenController.borderWidthValue.value,
                        bottom:
                        collageScreenController.borderWidthValue.value),
                    child: Container(
                      decoration: BoxDecoration(
                        //border: Border.all(width: collageScreenController.borderWidthValue.value),
                        borderRadius: BorderRadius.circular(
                            collageScreenController.borderRadiusValue.value),
                        color: Colors.white,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(
                                '${collageScreenController.imageFileList[1].path}'))),
                      ),
                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: collageScreenController.borderWidthValue.value,
                        right: collageScreenController.borderWidthValue.value,
                        top: collageScreenController.borderWidthValue.value,
                        bottom:
                        collageScreenController.borderWidthValue.value),
                    child: Container(
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.pink, width: 5),
                        borderRadius: BorderRadius.circular(
                            collageScreenController.borderRadiusValue.value),
                        color: Colors.white,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(
                                '${collageScreenController.imageFileList[2].path}'))),
                      ),
                      //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: collageScreenController.borderWidthValue.value,
                        right: collageScreenController.borderWidthValue.value,
                        top: collageScreenController.borderWidthValue.value,
                        bottom:
                        collageScreenController.borderWidthValue.value),
                    child: Container(
                      decoration: BoxDecoration(
                        //border: Border.all(width: collageScreenController.borderWidthValue.value),
                        borderRadius: BorderRadius.circular(
                            collageScreenController.borderRadiusValue.value),
                        color: Colors.white,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(
                                '${collageScreenController.imageFileList[3].path}'))),
                      ),
                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
              ],
            ),
          ),

            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 6
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex:3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex:3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 7
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex:1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex:1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 8
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File(
                                '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController
                                    .borderWidthValue
                                    .value,
                                right: collageScreenController
                                    .borderWidthValue
                                    .value,
                                top: collageScreenController
                                    .borderWidthValue
                                    .value,
                                bottom: collageScreenController
                                    .borderWidthValue
                                    .value),
                            child: Container(
                              decoration:
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    collageScreenController
                                        .borderRadiusValue
                                        .value),
                                color: Colors
                                    .white,
                                image: DecorationImage(
                                    fit: BoxFit
                                        .cover,
                                    image: FileImage(
                                        File(
                                            '${collageScreenController.imageFileList[2].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController
                                    .borderWidthValue
                                    .value,
                                right: collageScreenController
                                    .borderWidthValue
                                    .value,
                                top: collageScreenController
                                    .borderWidthValue
                                    .value,
                                bottom: collageScreenController
                                    .borderWidthValue
                                    .value),
                            child: Container(
                              decoration:
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    collageScreenController
                                        .borderRadiusValue
                                        .value),
                                color: Colors
                                    .white,
                                image: DecorationImage(
                                    fit: BoxFit
                                        .cover,
                                    image: FileImage(
                                        File(
                                            '${collageScreenController.imageFileList[3].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 9
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File(
                                '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File(
                                '${collageScreenController.imageFileList[3].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 10
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File(
                                '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File(
                                '${collageScreenController.imageFileList[3].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 11
        ? ClipRRect(
      borderRadius:
      BorderRadius
          .circular(20),
      child: Container(
        decoration:
        BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 12
        ? ClipRRect(
      borderRadius:
      BorderRadius
          .circular(20),
      child: Container(
        decoration:
        BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Column(
          children: [
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 13
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[1].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[3].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 14
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[1].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.pink, width: 5),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[3].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 15
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
                 child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[0].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
              ),
            ),

            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 16
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
          child: Stack(
            alignment: Alignment.center,
            children: [
               Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(width: collageScreenController.borderWidthValue.value),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[0].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(color: Colors.pink, width: 5),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[1].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(width: collageScreenController.borderWidthValue.value),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[2].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(color: Colors.pink, width: 5),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[3].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                height: 80, width: 80,
                color: Colors.black,
              )
            ],
          ),
      ),
    )
        : Container());
  }

  Widget fiveImageSelectedModule(int selectedIndex){
    return Obx(() =>
    selectedIndex == 0
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(color: Colors.pink, width: 5),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[3].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(color: Colors.pink, width: 5),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[4].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 1
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 2
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 3
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 4
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[0].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[1].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                  ],
              )
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[3].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[4].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 5
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom:
                    collageScreenController.borderWidthValue.value),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(width: collageScreenController.borderWidthValue.value),
                    borderRadius: BorderRadius.circular(
                        collageScreenController.borderRadiusValue.value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                ),
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 6
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Column(
          children: [
            Expanded(
              flex:2,
              child: Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController
                        .borderWidthValue
                        .value,
                    right:
                    collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom:
                    collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(
                            '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 7
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Column(
          children: [
            Expanded(
              flex:2,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ]
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex:1,
              child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[2].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[3].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[4].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                  ]
              ),
            ),


          ],
        ),
      ),
    )
        : selectedIndex == 8
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 9
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File(
                                '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File(
                                '${collageScreenController.imageFileList[4].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 10
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                    left: collageScreenController
                        .borderWidthValue
                        .value,
                    right: collageScreenController
                        .borderWidthValue
                        .value,
                    top: collageScreenController
                        .borderWidthValue
                        .value,
                    bottom: collageScreenController
                        .borderWidthValue
                        .value),
                child: Container(
                  decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        collageScreenController
                            .borderRadiusValue
                            .value),
                    color: Colors
                        .white,
                    image: DecorationImage(
                        fit: BoxFit
                            .cover,
                        image: FileImage(
                            File(
                                '${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 11
        ? ClipRRect(
      borderRadius:
      BorderRadius
          .circular(20),
      child: Container(
        decoration:
        BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 12
        ? ClipRRect(
      borderRadius:
      BorderRadius
          .circular(20),
      child: Container(
        decoration:
        BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    flex:2,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height:5),
                  Expanded(
                    flex:1,
                    child: Row(
                      children:[
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                        SizedBox(width:5),
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                      ]
                    )
                  )
                ],
              ),
            ),
            SizedBox(width:5),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
              flex:1,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height:5),
                  Expanded(
                      flex:2,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    )
        : selectedIndex == 13
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              flex:1,
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex:2,
              child: Row(
                children: [
                  Expanded(
                    flex:2,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    flex:1,
                    child: Column(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 14
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                     child:
                  Padding(
                  padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                        right: collageScreenController.borderWidthValue.value,
                        top: collageScreenController.borderWidthValue.value,
                        bottom: collageScreenController.borderWidthValue.value),
                    child:
                    Container(
                      decoration:
                      BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                        color:
                        Colors.white,
                        image:
                        DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                      ),
                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                    ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 15
        ?  ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 16
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex:2,
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex:1,
              child: Column(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 17
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              flex:1,
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex:2,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom: collageScreenController.borderWidthValue.value),
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                color:
                                Colors.white,
                                image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 18
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 19
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : Container());
  }

  Widget sixImageSelectedModule(int selectedIndex){
    return Obx(() =>
    selectedIndex == 0
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 1
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 2
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex:2,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(width: collageScreenController.borderWidthValue.value),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[1].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                            ),
                          ),
                        ),
                        SizedBox(width:5),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(width: collageScreenController.borderWidthValue.value),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[2].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex:1,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 3
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
              flex:1,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    flex:1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(width: collageScreenController.borderWidthValue.value),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[3].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                            ),
                          ),
                        ),
                        SizedBox(width:5),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: collageScreenController.borderWidthValue.value,
                                right: collageScreenController.borderWidthValue.value,
                                top: collageScreenController.borderWidthValue.value,
                                bottom:
                                collageScreenController.borderWidthValue.value),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(width: collageScreenController.borderWidthValue.value),
                                borderRadius: BorderRadius.circular(
                                    collageScreenController.borderRadiusValue.value),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(
                                        '${collageScreenController.imageFileList[4].path}'))),
                              ),
                              //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                            ),
                          ),
                        )
                      ]
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 4
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[0].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[1].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(width: 5,),
            Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[2].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[3].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(width: 5,),
            Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[4].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom:
                            collageScreenController.borderWidthValue.value),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(width: collageScreenController.borderWidthValue.value),
                            borderRadius: BorderRadius.circular(
                                collageScreenController.borderRadiusValue.value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[5].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 5
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                      flex:1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex:1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(width: collageScreenController.borderWidthValue.value),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}'), fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                      flex:2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom:
                          collageScreenController.borderWidthValue.value),
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.pink, width: 5),
                          borderRadius: BorderRadius.circular(
                              collageScreenController.borderRadiusValue.value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 6
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children:[
                  Expanded(
                      flex:2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height:5),
                  Expanded(
                    flex:1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          right:
                          collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom:
                          collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(
                                  '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  )
                ]
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                  children:[
                    Expanded(
                      flex:1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[2].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    SizedBox(height:5),
                    Expanded(
                      flex:2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[3].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    )
                  ]
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                  children:[
                    Expanded(
                      flex:2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[4].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    SizedBox(height:5),
                    Expanded(
                      flex:1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[5].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    )
                  ]
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 7
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[0].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                        flex:1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[1].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                  children: [
                    Expanded(
                      flex:1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[2].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex:2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[3].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[4].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex:1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            right:
                            collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom:
                            collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    '${collageScreenController.imageFileList[5].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 8
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
                child: Container()
            )

          ],
        ),
      ),
    )
        : selectedIndex == 9
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Row(
          children: [
            Expanded(
                child: Container()
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    )
        : selectedIndex == 10
        ? ClipRRect(
      borderRadius:
      BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor.value]),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController
                                .borderWidthValue
                                .value,
                            right: collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom: collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration:
                          BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors
                                .white,
                            image: DecorationImage(
                                fit: BoxFit
                                    .cover,
                                image: FileImage(
                                    File(
                                        '${collageScreenController.imageFileList[0].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: collageScreenController
                                .borderWidthValue
                                .value,
                            right: collageScreenController
                                .borderWidthValue
                                .value,
                            top: collageScreenController
                                .borderWidthValue
                                .value,
                            bottom: collageScreenController
                                .borderWidthValue
                                .value),
                        child: Container(
                          decoration:
                          BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                collageScreenController
                                    .borderRadiusValue
                                    .value),
                            color: Colors
                                .white,
                            image: DecorationImage(
                                fit: BoxFit
                                    .cover,
                                image: FileImage(
                                    File(
                                        '${collageScreenController.imageFileList[1].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    )
                  ]
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex:1,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: collageScreenController
                              .borderWidthValue
                              .value,
                          right: collageScreenController
                              .borderWidthValue
                              .value,
                          top: collageScreenController
                              .borderWidthValue
                              .value,
                          bottom: collageScreenController
                              .borderWidthValue
                              .value),
                      child: Container(
                        decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              collageScreenController
                                  .borderRadiusValue
                                  .value),
                          color: Colors
                              .white,
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: FileImage(
                                  File(
                                      '${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    )
        : selectedIndex == 11
        ? ClipRRect(
      borderRadius:
      BorderRadius
          .circular(20),
      child: Container(
        decoration:
        BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Column(
          children: [
            Expanded(
              flex:2,
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex:1,
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child:
                      Padding(
                      padding: EdgeInsets.only(
                  left:
                  collageScreenController.borderWidthValue.value,
                      right: collageScreenController.borderWidthValue.value,
                      top: collageScreenController.borderWidthValue.value,
                  bottom: collageScreenController.borderWidthValue.value),
                    child:
                    Container(
                      decoration:
                      BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                        color:
                        Colors.white,
                        image:
                        DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[5].path}'))),
                      ),
                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                    ),
                  ),
    ),
                ],
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 12
        ? ClipRRect(
      borderRadius:
      BorderRadius
          .circular(20),
      child: Container(
        decoration:
        BoxDecoration(
          // border: Border.all(color: Colors.red, width: 5),
            color: collageScreenController
                .borderColor[
            collageScreenController
                .activeColor
                .value]),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width:5),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height:5),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width:5),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height:5),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width:5),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 13
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [

            Expanded(
              flex:1,
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              flex:2,
              child: Row(
                children: [
                  Expanded(
                      flex:2,
                    child: Column(
                        children: [
                           Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child:
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                        collageScreenController.borderWidthValue.value,
                                        right: collageScreenController.borderWidthValue.value,
                                        top: collageScreenController.borderWidthValue.value,
                                        bottom: collageScreenController.borderWidthValue.value),
                                    child:
                                    Container(
                                      decoration:
                                      BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                        color:
                                        Colors.white,
                                        image:
                                        DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                                      ),
                                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                    ),
                                  ),
                                ),
                                SizedBox(width:5),
                                Expanded(
                                  flex: 1,
                                  child:
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                        collageScreenController.borderWidthValue.value,
                                        right: collageScreenController.borderWidthValue.value,
                                        top: collageScreenController.borderWidthValue.value,
                                        bottom: collageScreenController.borderWidthValue.value),
                                    child:
                                    Container(
                                      decoration:
                                      BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                        color:
                                        Colors.white,
                                        image:
                                        DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                                      ),
                                      //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                    ),
                                  ),
                                ),

                              ]
                            ),
                           ),
                          SizedBox(height:5),
                          Expanded(
                               child: Row(
                                children: [
                                  Expanded(
                                    child:
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                          collageScreenController.borderWidthValue.value,
                                          right: collageScreenController.borderWidthValue.value,
                                          top: collageScreenController.borderWidthValue.value,
                                          bottom: collageScreenController.borderWidthValue.value),
                                      child:
                                      Container(
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                          color:
                                          Colors.white,
                                          image:
                                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                                        ),
                                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Expanded(
                                    flex: 1,
                                    child:
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                          collageScreenController.borderWidthValue.value,
                                          right: collageScreenController.borderWidthValue.value,
                                          top: collageScreenController.borderWidthValue.value,
                                          bottom: collageScreenController.borderWidthValue.value),
                                      child:
                                      Container(
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                          color:
                                          Colors.white,
                                          image:
                                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                                        ),
                                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                      ),
                                    ),
                                  ),

                                ]
                            ),
                          )
                        ]
                    )
                  ),
                  SizedBox(width:5),
                  Expanded(
                    flex: 1,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    )
        : selectedIndex == 14
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 15
        ?  ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Column(
                        children: [
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          )
                        ]
                    )
                  ),

                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                          children: [
                            Expanded(
                              child:
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                    collageScreenController.borderWidthValue.value,
                                    right: collageScreenController.borderWidthValue.value,
                                    top: collageScreenController.borderWidthValue.value,
                                    bottom: collageScreenController.borderWidthValue.value),
                                child:
                                Container(
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                    color:
                                    Colors.white,
                                    image:
                                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                                  ),
                                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                ),
                              ),
                            ),
                            SizedBox(height:5),
                            Expanded(
                              child:
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                    collageScreenController.borderWidthValue.value,
                                    right: collageScreenController.borderWidthValue.value,
                                    top: collageScreenController.borderWidthValue.value,
                                    bottom: collageScreenController.borderWidthValue.value),
                                child:
                                Container(
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                    color:
                                    Colors.white,
                                    image:
                                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                                  ),
                                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                                ),
                              ),
                            )
                          ]
                      )
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 16
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              flex:1,
              child: Container()
            ),
            SizedBox(height: 5,),
            Expanded(
              flex:2,
              child: Column(
                children: [
                 Expanded(
                      child: Row(
                        children:[
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          )
                        ]
                    ),
                 ),
                  SizedBox(height: 5,),
                  Expanded(
                       child: Row(
                        children:[
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[5].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          )
                        ]
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
                flex:1,
                child: Container()
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 17
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
                flex:1,
                child: Container()
            ),
            SizedBox(height: 5,),
            Expanded(
              flex:2,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                        children:[
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Row(
                        children:[
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    child: Row(
                        children:[
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  collageScreenController.borderWidthValue.value,
                                  right: collageScreenController.borderWidthValue.value,
                                  top: collageScreenController.borderWidthValue.value,
                                  bottom: collageScreenController.borderWidthValue.value),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                                  color:
                                  Colors.white,
                                  image:
                                  DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                                ),
                                //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                              ),
                            ),
                          ),
                        ]
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
                flex:1,
                child: Container()
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 18
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Row(
          children: [
            Expanded(
                 child: Column(
                children: [
                  Expanded(
                    flex:3,
                    child: Container()
                  ),
                  Expanded(
                      flex:1,
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  )
                ]
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                  children: [
                    Expanded(
                        flex:2,
                        child: Container()
                    ),
                    Expanded(
                      flex:1,
                      child:
                      Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom: collageScreenController.borderWidthValue.value),
                        child:
                        Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                            color:
                            Colors.white,
                            image:
                            DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    Expanded(
                        flex:1,
                        child: Container()
                    ),
                  ]
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                  children: [
                    Expanded(
                        flex:1,
                        child: Container()
                    ),
                    Expanded(
                      flex:1,
                      child:
                      Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom: collageScreenController.borderWidthValue.value),
                        child:
                        Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                            color:
                            Colors.white,
                            image:
                            DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    Expanded(
                        flex:1,
                        child: Container()
                    ),
                  ]
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                  children: [
                    Expanded(
                        flex:1,
                        child: Container()
                    ),
                    Expanded(
                      flex:1,
                      child:
                      Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom: collageScreenController.borderWidthValue.value),
                        child:
                        Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                            color:
                            Colors.white,
                            image:
                            DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    Expanded(
                        flex:2,
                        child: Container()
                    ),
                  ]
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                  children: [
                    Expanded(
                        flex:1,
                        child: Container()
                    ),
                    Expanded(
                      flex:1,
                      child:
                      Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom: collageScreenController.borderWidthValue.value),
                        child:
                        Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                            color:
                            Colors.white,
                            image:
                            DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    Expanded(
                        flex:3,
                        child: Container()
                    ),
                  ]
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                  children: [
                    Expanded(
                      flex:1,
                      child:
                      Padding(
                        padding: EdgeInsets.only(
                            left:
                            collageScreenController.borderWidthValue.value,
                            right: collageScreenController.borderWidthValue.value,
                            top: collageScreenController.borderWidthValue.value,
                            bottom: collageScreenController.borderWidthValue.value),
                        child:
                        Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                            color:
                            Colors.white,
                            image:
                            DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[5].path}'))),
                          ),
                          //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                    ),
                    Expanded(
                        flex:3,
                        child: Container()
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    )
        : selectedIndex == 19
        ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: collageScreenController
                .borderColor[collageScreenController.activeColor.value]),
        child: Column(
          children: [
            Expanded(
              child:
              Padding(
                padding: EdgeInsets.only(
                    left:
                    collageScreenController.borderWidthValue.value,
                    right: collageScreenController.borderWidthValue.value,
                    top: collageScreenController.borderWidthValue.value,
                    bottom: collageScreenController.borderWidthValue.value),
                child:
                Container(
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                    color:
                    Colors.white,
                    image:
                    DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[0].path}'))),
                  ),
                  //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[1].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[2].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[3].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[4].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child:
                    Padding(
                      padding: EdgeInsets.only(
                          left:
                          collageScreenController.borderWidthValue.value,
                          right: collageScreenController.borderWidthValue.value,
                          top: collageScreenController.borderWidthValue.value,
                          bottom: collageScreenController.borderWidthValue.value),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                          color:
                          Colors.white,
                          image:
                          DecorationImage(fit: BoxFit.cover, image: FileImage(File('${collageScreenController.imageFileList[5].path}'))),
                        ),
                        //child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        : Container());
  }
}
