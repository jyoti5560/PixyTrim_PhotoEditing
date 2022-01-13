import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/common/store_session_local/store_session_local.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';
import 'package:pixytrim/screens/collage_screen/border_color_screen/border_color_screen.dart';
import 'package:pixytrim/screens/collage_screen/border_radius_screen/border_radius_screen.dart';
import 'package:pixytrim/screens/collage_screen/border_width_screen/border_width_screen.dart';
import 'package:pixytrim/screens/collage_screen/layout_screen/layout_screen.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'collage_screen_widgets.dart';
import 'wallpaper_screen/wallpapers_screen.dart';

class CollageScreen extends StatefulWidget {
  @override
  _CollageScreenState createState() => _CollageScreenState();
}

class _CollageScreenState extends State<CollageScreen>
    with SingleTickerProviderStateMixin {
  final collageScreenController = Get.find<CollageScreenController>();

  late TabController _tabController;
  final GlobalKey key = GlobalKey();
  File? file;
  List<String> localCollageList = [];
  LocalStorage localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: RepaintBoundary(
                    key: key,
                    child: Container(
                        width: Get.width,
                        child: Obx(
                          () => collageScreenController.isLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : ImageListModule(),
                        ),
                    ),
                  ),
                      )),
                  tabBar(),
                  tabBarView(),
                ],
              ),
            )
          ],
        ),
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
                    ),
                  ),
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
          Container(child: Tab(text: "Layout")),
          Container(child: Tab(text: "Border Width")),
          Container(child: Tab(text: "Border Color")),
          Container(child: Tab(text: "Border Radius")),
          Container(child: Tab(text: "WallPapers")),
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
          LayoutScreen(),
          BorderWidthScreen(),
          BorderColorScreen(),
          BorderRadiusScreen(),
          WallPapersScreen(),
        ],
      ),
    );
  }

  Future _capturePng() async {
    try {
      print('inside');
      DateTime time = DateTime.now();
      String photoName =
          "${time.day}_${time.month}_${time.year}_${time.second}_${time.minute}_${time.hour}";
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
      File imgFile = new File('$directory/$photoName.jpg');
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
    Fluttertoast.showToast(
        msg: "Save in to Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    Get.back();
  }

  showAlertDialog() {
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(fontFamily: ""),
      ),
      onPressed: () {
        Get.back();
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(fontFamily: ""),
      ),
      onPressed: () async {
        collageScreenController.borderWidthValue.value = 0.0;
        collageScreenController.activeColor.value = 0;
        collageScreenController.borderRadiusValue.value = 0.0;
        collageScreenController.isActiveWallpaper.value = false;

        if(collageScreenController.imageFileList.isNotEmpty){
          for(int i = 0; i < collageScreenController.imageFileList.length; i++){

            localCollageList.add('${collageScreenController.imageFileList[i].file.path}');
          }
          print('localCollageList : $localCollageList');
          if(localCollageList.isNotEmpty){
            await localStorage.storeMainCollageList(localCollageList);
          }
        }

        Get.back();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        "Do you want to save in Draft ?",
        style: TextStyle(fontFamily: ""),
      ),
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
}

class ImageListModule extends StatefulWidget {
  const ImageListModule({Key? key}) : super(key: key);

  @override
  _ImageListModuleState createState() => _ImageListModuleState();
}

class _ImageListModuleState extends State<ImageListModule> {
  final collageScreenController = Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => collageScreenController.imageFileList.length == 2
          ? twoImageSelectedModule(collageScreenController.selectedIndex.value)
          : collageScreenController.imageFileList.length == 3
              ? threeImageSelectedModule(
                  collageScreenController.selectedIndex.value)
              : collageScreenController.imageFileList.length == 4
          ? fourImageSelectedModule(collageScreenController.selectedIndex.value)
          : collageScreenController.imageFileList.length == 5
          ? fiveImageSelectedModule(collageScreenController.selectedIndex.value)
          : collageScreenController.imageFileList.length == 6
          ? sixImageSelectedModule(collageScreenController.selectedIndex.value)
          : collageScreenController.imageFileList.length == 7
          ? sevenImageSelectedModule(collageScreenController.selectedIndex.value)
              : Container(),
    );
  }

  Widget twoImageSelectedModule(int selectedIndex) {
    return Obx(() => selectedIndex == 0
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(
                  // scale: collageScreenController.scale.value,
                  // previousScale:
                  //     collageScreenController.previousScale.value,
                  index: 0),
              SizedBox(width: 5),
              SingleImageShowModule(
                  // scale: collageScreenController.scale1.value,
                  // previousScale:
                  //     collageScreenController.previousScale1.value,
                  index: 1),
            ],
          ),
        )
        : selectedIndex == 1
            ? Container(
              decoration: collageMainImageBoxDecoration(),
              child: Column(
                children: [
                  SingleImageShowModule(
                      // scale: collageScreenController.scale.value,
                      // previousScale:
                      //     collageScreenController.previousScale.value,
                      index: 0),
                  SizedBox(height: 5),
                  SingleImageShowModule(
                      // scale: collageScreenController.scale1.value,
                      // previousScale:
                      //     collageScreenController.previousScale1.value,
                      index: 1),
                ],
              ),
            )
            : selectedIndex == 2
                ? Container(
                  decoration: collageMainImageBoxDecoration(),
                  child: Column(
                    children: [
                      SingleImageShowModule(
                        // scale: collageScreenController.scale.value,
                        // previousScale:
                        //     collageScreenController.previousScale.value,
                        index: 0, flex: 2,
                      ),
                      SizedBox(height: 5),
                      SingleImageShowModule(
                        // scale: collageScreenController.scale1.value,
                        // previousScale: collageScreenController
                        //     .previousScale1.value,
                        index: 1, flex: 1,
                      ),
                    ],
                  ),
                )
                : selectedIndex == 3
                    ? Container(
                      decoration: collageMainImageBoxDecoration(),
                      child: Column(
                        children: [
                          SingleImageShowModule(
                            // scale: collageScreenController.scale.value,
                            // previousScale: collageScreenController
                            //     .previousScale.value,
                            index: 0, flex: 1,
                          ),
                          SizedBox(height: 5),
                          SingleImageShowModule(
                            // scale: collageScreenController.scale1.value,
                            // previousScale: collageScreenController
                            //     .previousScale1.value,
                            index: 1, flex: 2,
                          ),
                        ],
                      ),
                    )
                    : selectedIndex == 4
                        ? Container(
                          decoration: collageMainImageBoxDecoration(),
                          child: Row(
                            children: [
                              SingleImageShowModule(
                                // scale:
                                //     collageScreenController.scale.value,
                                // previousScale: collageScreenController
                                //     .previousScale.value,
                                index: 0, flex: 1,
                              ),
                              SizedBox(width: 5),
                              SingleImageShowModule(
                                // scale: collageScreenController
                                //     .scale1.value,
                                // previousScale: collageScreenController
                                //     .previousScale1.value,
                                index: 1, flex: 2,
                              ),
                            ],
                          ),
                        )
                        : selectedIndex == 5
                            ? Container(
                              decoration: collageMainImageBoxDecoration(),
                              child: Row(
                                children: [
                                  SingleImageShowModule(
                                    // scale: collageScreenController
                                    //     .scale.value,
                                    // previousScale:
                                    //     collageScreenController
                                    //         .previousScale.value,
                                    index: 0, flex: 2,
                                  ),
                                  SizedBox(width: 5),
                                  SingleImageShowModule(
                                    // scale: collageScreenController
                                    //     .scale1.value,
                                    // previousScale:
                                    //     collageScreenController
                                    //         .previousScale1.value,
                                    index: 1, flex: 1,
                                  ),
                                ],
                              ),
                            )
                            : selectedIndex == 6
                                ? Container(
                                  decoration:
                                      collageMainImageBoxDecoration(),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(child: Container()),
                                            SingleImageShowModule(
                                              // scale:
                                              //     collageScreenController
                                              //         .scale.value,
                                              // previousScale:
                                              //     collageScreenController
                                              //         .previousScale
                                              //         .value,
                                              index: 0, flex: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SingleImageShowModule(
                                              // scale:
                                              //     collageScreenController
                                              //         .scale1.value,
                                              // previousScale:
                                              //     collageScreenController
                                              //         .previousScale1
                                              //         .value,
                                              index: 1, flex: 1,
                                            ),
                                            Expanded(child: Container()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : selectedIndex == 7
                                    ? Container(
                                      decoration:
                                          collageMainImageBoxDecoration(),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                SingleImageShowModule(
                                                  // scale:
                                                  //     collageScreenController
                                                  //         .scale.value,
                                                  // previousScale:
                                                  //     collageScreenController
                                                  //         .previousScale
                                                  //         .value,
                                                  index: 0, flex: 1,
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
                                                // SizedBox(width: 5),
                                                SingleImageShowModule(
                                                  // scale:
                                                  //     collageScreenController
                                                  //         .scale1.value,
                                                  // previousScale:
                                                  //     collageScreenController
                                                  //         .previousScale1
                                                  //         .value,
                                                  index: 1, flex: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : selectedIndex == 8
                                        ? Container(
                                          decoration:
                                              collageMainImageBoxDecoration(),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Container()),
                                                    SizedBox(width: 5),
                                                    SingleImageShowModule(
                                                      index: 0,
                                                      flex: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    SingleImageShowModule(
                                                      index: 1,
                                                      flex: 2,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Container()),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : selectedIndex == 9
                                            ? Container(
                                              decoration:
                                                  collageMainImageBoxDecoration(),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        SingleImageShowModule(
                                                          index: 0,
                                                          flex: 2,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                            flex: 1,
                                                            child:
                                                                Container()),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child:
                                                                Container()),
                                                        SizedBox(width: 5),
                                                        SingleImageShowModule(
                                                          index: 1,
                                                          flex: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            : selectedIndex == 10
                                                ? Container(
                                                  decoration:
                                                      collageMainImageBoxDecoration(),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            SingleImageShowModule(
                                                              index: 0,
                                                              flex: 1,
                                                            ),
                                                            SizedBox(
                                                                width: 5),
                                                            SingleImageShowModule(
                                                              index: 1,
                                                              flex: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                : selectedIndex == 11
                                                    ? Container(
                                                      decoration:
                                                          collageMainImageBoxDecoration(),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                SingleImageShowModule(
                                                                    index:
                                                                        0),
                                                                SizedBox(
                                                                    height:
                                                                        5),
                                                                SingleImageShowModule(
                                                                    index:
                                                                        1),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                        ],
                                                      ),
                                                    )
                                                    : Container());
  }

  Widget threeImageSelectedModule(int selectedIndex) {
    return Obx(() => selectedIndex == 0
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(width: 5),
              SingleImageShowModule(index: 1),
              SizedBox(width: 5),
              SingleImageShowModule(index: 2),
            ],
          ),
        )
        : selectedIndex == 1
            ? Container(
              decoration: collageMainImageBoxDecoration(),
              child: Column(
                children: [
                  SingleImageShowModule(index: 0),
                  SizedBox(height: 5),
                  SingleImageShowModule(index: 1),
                  SizedBox(height: 5),
                  SingleImageShowModule(index: 2),
                ],
              ),
            )
            : selectedIndex == 2
                ? Container(
                  decoration: collageMainImageBoxDecoration(),
                  child: Column(
                    children: [
                      SingleImageShowModule(index: 0),
                      SizedBox(height: 5),
                      Expanded(
                        child: Row(
                          children: [
                            SingleImageShowModule(index: 1),
                            SizedBox(width: 5),
                            SingleImageShowModule(index: 2),
                          ],
                        ),
                      )
                    ],
                  ),
                )
                : selectedIndex == 3
                    ? Container(
                      decoration: collageMainImageBoxDecoration(),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SingleImageShowModule(index: 0),
                                SizedBox(width: 5),
                                SingleImageShowModule(index: 1),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          SingleImageShowModule(index: 2),
                        ],
                      ),
                    )
                    : selectedIndex == 4
                        ? Container(
                          decoration: collageMainImageBoxDecoration(),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SingleImageShowModule(index: 0),
                                    SizedBox(height: 5),
                                    SingleImageShowModule(index: 1),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              SingleImageShowModule(index: 2),
                            ],
                          ),
                        )
                        : selectedIndex == 5
                            ? Container(
                              decoration: collageMainImageBoxDecoration(),
                              child: Row(
                                children: [
                                  SingleImageShowModule(index: 0),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SingleImageShowModule(index: 1),
                                        SizedBox(height: 5),
                                        SingleImageShowModule(index: 2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : selectedIndex == 6
                                ? Container(
                                  decoration:
                                      collageMainImageBoxDecoration(),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            SingleImageShowModule(index: 0),
                                            SizedBox(width: 5),
                                            SingleImageShowModule(index: 1),
                                            SizedBox(width: 5),
                                            SingleImageShowModule(index: 2),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                )
                                : selectedIndex == 7
                                    ? Container(
                                        decoration:
                                            collageMainImageBoxDecoration(),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container()),
                                                  SingleImageShowModule(
                                                    index: 0,
                                                    flex: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container()),
                                                  SingleImageShowModule(
                                                    index: 1,
                                                    flex: 2,
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container()),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  SingleImageShowModule(
                                                    index: 2,
                                                    flex: 2,
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container()),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ))
                                    : selectedIndex == 8
                                        ? Container(
                                          decoration:
                                              collageMainImageBoxDecoration(),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SingleImageShowModule(
                                                        index: 0),
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
                                                    SingleImageShowModule(
                                                        index: 1),
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
                                                    SingleImageShowModule(
                                                        index: 2),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : selectedIndex == 9
                                            ? Container(
                                                decoration:
                                                    collageMainImageBoxDecoration(),
                                                child: Row(
                                                  children: [
                                                    SingleImageShowModule(
                                                        index: 0),
                                                    SizedBox(width: 5),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          SingleImageShowModule(
                                                            index: 1,
                                                            flex: 1,
                                                          ),
                                                          SizedBox(
                                                              height: 5),
                                                          SingleImageShowModule(
                                                            index: 2,
                                                            flex: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ))
                                            : selectedIndex == 10
                                                ? Container(
                                                    decoration:
                                                        collageMainImageBoxDecoration(),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      5),
                                                              SingleImageShowModule(
                                                                index: 0,
                                                                flex: 2,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        SingleImageShowModule(
                                                            index: 1),
                                                        SizedBox(width: 5),
                                                        SingleImageShowModule(
                                                            index: 2),
                                                      ],
                                                    ))
                                                : selectedIndex == 11
                                                    ? Container(
                                                      decoration:
                                                          collageMainImageBoxDecoration(),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                SingleImageShowModule(
                                                                    index:
                                                                        0),
                                                                SizedBox(
                                                                    height:
                                                                        5),
                                                                Expanded(
                                                                  child:
                                                                      Container(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 5),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                SingleImageShowModule(
                                                                    index:
                                                                        1),
                                                                SizedBox(
                                                                    width:
                                                                        5),
                                                                SingleImageShowModule(
                                                                    index:
                                                                        2),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                    : selectedIndex == 12
                                                        ? Container(
                                                          decoration:
                                                              collageMainImageBoxDecoration(),
                                                          child: Row(
                                                            children: [
                                                              SingleImageShowModule(
                                                                  index: 0),
                                                              SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Column(
                                                                  children: [
                                                                    SingleImageShowModule(
                                                                        index:
                                                                            1),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    SingleImageShowModule(
                                                                        index:
                                                                            2),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                        : selectedIndex == 13
                                                            ? Container(
                                                                  decoration:
                                                              collageMainImageBoxDecoration(),
                                                                  child: Row(
                                                            children: [
                                                              SingleImageShowModule(
                                                                  index:
                                                                      0),
                                                              SizedBox(
                                                                  width:
                                                                      5),
                                                              SingleImageShowModule(
                                                                  index:
                                                                      1,
                                                                  flex:
                                                                      2),
                                                              SizedBox(
                                                                  width:
                                                                      5),
                                                              SingleImageShowModule(
                                                                  index:
                                                                      2),
                                                            ],
                                                                  ),
                                                                )
                                                            : Container());
  }

Widget fourImageSelectedModule(int selectedIndex){
    return Obx(() =>
    selectedIndex == 0
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 1
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1,  flex:2,),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2,  flex:2,),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 2
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1,  flex:2,),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 2,  flex:2,),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 3
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 4
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 5
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),

              SizedBox(height: 5),
              SingleImageShowModule(index: 3),

            ],
          ),
        )
        : selectedIndex == 6
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0,  flex:2,),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 2,  flex:2,),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 7
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1,  flex:2,),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3,  flex:2,),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 8
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 1,  flex:2,),
                    SizedBox(height: 5),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          SingleImageShowModule(index: 2),
                          SizedBox(width: 5),
                          SingleImageShowModule(index: 3),
                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 9
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(height: 5),
              SingleImageShowModule(index: 3),

            ],
          ),
        )
        : selectedIndex == 10
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(width: 5),
              SingleImageShowModule(index: 3),

            ],
          ),
        )
        : selectedIndex == 11
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height: 5),
              SingleImageShowModule(index: 2),
              SizedBox(height: 5),
              SingleImageShowModule(index: 3),
            ],
          ),
        )
        : selectedIndex == 12
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
              SingleImageShowModule(index: 1),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 13
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(width: 5),
              SingleImageShowModule(index: 1),
              SizedBox(width: 5),
              SingleImageShowModule(index: 2),
              SizedBox(width: 5),
              SingleImageShowModule(index: 3),
            ],
          ),
        )
        : selectedIndex == 14
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
              SingleImageShowModule(index: 1),
              SizedBox(height: 5),
              SingleImageShowModule(index: 2),
              SizedBox(height: 5),
              SingleImageShowModule(index: 3),
            ],
          ),
        )
        : selectedIndex == 15
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    SingleImageShowModule(index: 0, flex:4,),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                    SingleImageShowModule(index: 1, flex:4,),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                    SingleImageShowModule(index: 2, flex:4,),
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    SingleImageShowModule(index: 3, flex:4,),
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 16
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SingleImageShowModule(index: 0),
                        SizedBox(width: 5),
                        SingleImageShowModule(index: 1),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: Row(
                      children: [
                        SingleImageShowModule(index: 2),
                        SizedBox(width: 5),
                        SingleImageShowModule(index: 3),
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
        )
        : Container());
  }

Widget fiveImageSelectedModule(int selectedIndex){
    return Obx(() =>
    selectedIndex == 0
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 2, flex:2,),
                    SizedBox(height: 5),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          SingleImageShowModule(index: 3),
                          SizedBox(width: 5),
                          SingleImageShowModule(index: 4),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 1
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height: 5),

              SingleImageShowModule(index: 2),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4, flex:2,),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 2
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(width: 5),
              SingleImageShowModule(index: 2),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4, flex:2,),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 3
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height: 5),
              SingleImageShowModule(index: 2),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 4
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      SingleImageShowModule(index: 0),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 1),
                    ],
                  )
              ),
              SizedBox(width: 5),
              SingleImageShowModule(index: 2),
              SizedBox(width: 5),
              Expanded(
                  child: Column(
                    children: [
                      SingleImageShowModule(index: 3),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 4),
                    ],
                  )
              ),
            ],
          ),
        )
        : selectedIndex == 5
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),

              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),

                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 6
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0, flex:2,),
              SizedBox(height: 5),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 7
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                flex:2,
                child: Row(
                    children: [
                      SingleImageShowModule(index: 0),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 1),
                    ]
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                flex:1,
                child: Row(
                    children: [
                      SingleImageShowModule(index: 2),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 3),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 4),
                    ]
                ),
              ),


            ],
          ),
        )
        : selectedIndex == 8
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 9
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
              SizedBox(width: 5),
              SingleImageShowModule(
                  index: 4),

            ],
          ),
        )
        : selectedIndex == 10
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 11
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3, flex:2,),
                  ],
                ),
              ),
              SizedBox(width: 5),
              SingleImageShowModule(index: 4),
            ],
          ),
        )
        : selectedIndex == 12
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(height:5),
                    Expanded(
                        flex:1,
                        child: Row(
                            children:[
                              SingleImageShowModule(index: 1),
                              SizedBox(width:5),
                              SingleImageShowModule(index: 2),
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
                    SingleImageShowModule(index: 3),
                    SizedBox(height:5),
                    SingleImageShowModule(index: 4, flex:2,),

                  ],
                ),
              )

            ],
          ),
        )
        : selectedIndex == 13
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
              Expanded(
                flex:2,
                child: Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: Row(
                        children: [
                          SingleImageShowModule(index: 1),
                          SizedBox(width: 5),
                          SingleImageShowModule(index: 2),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex:1,
                      child: Column(
                        children: [
                          SingleImageShowModule(index: 3),
                          SizedBox(height: 5),
                          SingleImageShowModule(index: 4, flex:2,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 14
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4, flex:2,),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 15
        ?  Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 16
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0, flex:2,),
              SizedBox(width: 5),
              Expanded(
                flex:1,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 17
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
              Expanded(
                flex:2,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SingleImageShowModule(index: 1),
                          SizedBox(height: 5),
                          SingleImageShowModule(index: 2),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        children: [
                          SingleImageShowModule(index: 3),
                          SizedBox(height: 5),
                          SingleImageShowModule(index: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 18
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(width: 5),
              SingleImageShowModule(index: 1),
              SizedBox(width: 5),
              SingleImageShowModule(index: 2),
              SizedBox(width: 5),
              SingleImageShowModule(index: 3),
              SizedBox(width: 5),
              SingleImageShowModule(index: 4),
            ],
          ),
        )
        : selectedIndex == 19
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),
            ],
          ),
        )
        : Container());
  }

Widget sixImageSelectedModule(int selectedIndex){
    return Obx(() =>
    selectedIndex == 0
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),

                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 1
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 2
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                flex:2,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(height: 5),
                    Expanded(
                      flex: 1,
                      child: Row(
                          children: [
                            SingleImageShowModule(index: 1),
                            SizedBox(width:5),
                            SingleImageShowModule(index: 2),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                flex:1,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 5),

                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 3
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                flex:1,
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      flex:1,
                      child: Row(
                          children: [
                            SingleImageShowModule(index: 3),
                            SizedBox(width:5),
                            SingleImageShowModule(index: 4),
                          ]
                      ),
                    ),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 5, flex:2,),

                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 4
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      SingleImageShowModule(index: 0, flex:2,),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 1),
                    ],
                  )
              ),
              SizedBox(width: 5),
              Expanded(
                  child: Column(
                    children: [
                      SingleImageShowModule(index: 2),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 3),
                    ],
                  )
              ),
              SizedBox(width: 5),
              Expanded(
                  child: Column(
                    children: [
                      SingleImageShowModule(index: 4),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 5, flex:2,),
                    ],
                  )
              ),
            ],
          ),
        )
        : selectedIndex == 5
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),

              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),

              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5, flex:2,),
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 6
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    children:[
                      SingleImageShowModule(index: 0, flex:2,),
                      SizedBox(height:5),
                      SingleImageShowModule(index: 1),
                    ]
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                    children:[
                      SingleImageShowModule(index: 2),
                      SizedBox(height:5),
                      SingleImageShowModule(index: 3, flex:2,),
                    ]
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                    children:[
                      SingleImageShowModule(index: 4, flex:2,),
                      SizedBox(height:5),
                      SingleImageShowModule(index: 5),
                    ]
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 7
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                    children: [
                      SingleImageShowModule(index: 0, flex:2,),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 1),
                    ]
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                    children: [
                      SingleImageShowModule(index: 2),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 3, flex:2,),
                    ]
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                    children: [
                      SingleImageShowModule(index: 4, flex:2,),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 5),
                    ]
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 8
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3, flex:2,),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4, flex:2,),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                  child: Container()
              )

            ],
          ),
        )
        : selectedIndex == 9
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                  child: Container()
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),


            ],
          ),
        )
        : selectedIndex == 10
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                    children: [
                      SingleImageShowModule(index: 0),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 1),
                    ]
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                flex:1,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),


            ],
          ),
        )
        : selectedIndex == 11
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0, flex:2,),
              SizedBox(height: 5),
              Expanded(
                flex:1,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 12
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height:5),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
              SizedBox(height:5),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 4),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 13
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [

              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
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
                                      SingleImageShowModule(index: 1),
                                      SizedBox(width:5),
                                      SingleImageShowModule(index: 2),

                                    ]
                                ),
                              ),
                              SizedBox(height:5),
                              Expanded(
                                child: Row(
                                    children: [
                                      SingleImageShowModule(index: 3),
                                      SizedBox(width:5),
                                      SingleImageShowModule(index: 4),

                                    ]
                                ),
                              )
                            ]
                        )
                    ),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 14
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 15
        ?  Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    Expanded(
                        child: Column(
                            children: [
                              SingleImageShowModule(index: 1),
                              SizedBox(height: 5),
                              SingleImageShowModule(index: 2),
                            ]
                        )
                    ),

                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                            children: [
                              SingleImageShowModule(index: 3),
                              SizedBox(height:5),
                              SingleImageShowModule(index: 4),
                            ]
                        )
                    ),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),

                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 16
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                  flex:1,
                  child: Container()
              ),
              SizedBox(height: 5),
              Expanded(
                flex:2,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                          children:[
                            SingleImageShowModule(index: 0),
                            SizedBox(width: 5),
                            SingleImageShowModule(index: 1),
                            SizedBox(width: 5),
                            SingleImageShowModule(index: 2),
                          ]
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Row(
                          children:[
                            SingleImageShowModule(index: 3),
                            SizedBox(width: 5),
                            SingleImageShowModule(index: 4),
                            SizedBox(width: 5),
                            SingleImageShowModule(index: 5),
                          ]
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                  flex:1,
                  child: Container()
              ),
            ],
          ),
        )
        : selectedIndex == 17
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                  flex:1,
                  child: Container()
              ),
              SizedBox(height: 5),
              Expanded(
                flex:2,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                          children:[
                            SingleImageShowModule(index: 0),
                            SizedBox(width: 5),
                            SingleImageShowModule(index: 1),
                          ]
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Row(
                          children:[
                            SingleImageShowModule(index: 2),
                            SizedBox(width: 5),
                            SingleImageShowModule(index: 3),
                          ]
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Row(
                          children:[
                            SingleImageShowModule(index: 4),
                            SizedBox(width: 5),
                            SingleImageShowModule(index: 5),
                          ]
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                  flex:1,
                  child: Container()
              ),
            ],
          ),
        )
        : selectedIndex == 18
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    children: [
                      Expanded(
                          flex:3,
                          child: Container()
                      ),
                      SingleImageShowModule(index: 0),
                    ]
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                    children: [
                      Expanded(
                          flex:2,
                          child: Container()
                      ),
                      SingleImageShowModule(index: 1),
                      Expanded(
                          flex:1,
                          child: Container()
                      ),
                    ]
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                    children: [
                      Expanded(
                          flex:1,
                          child: Container()
                      ),
                      SingleImageShowModule(index: 2),
                      Expanded(
                          flex:1,
                          child: Container()
                      ),
                    ]
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                    children: [
                      Expanded(
                          flex:1,
                          child: Container()
                      ),
                      SingleImageShowModule(index: 3),
                      Expanded(
                          flex:2,
                          child: Container()
                      ),
                    ]
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                    children: [
                      Expanded(
                          flex:1,
                          child: Container()
                      ),
                      SingleImageShowModule(index: 4),
                      Expanded(
                          flex:3,
                          child: Container()
                      ),
                    ]
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                    children: [
                      SingleImageShowModule(index: 5),
                      Expanded(
                          flex:3,
                          child: Container()
                      ),
                    ]
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 19
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              SingleImageShowModule(index: 0),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),

                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),
            ],
          ),
        )
        : Container());
  }

Widget sevenImageSelectedModule(int selectedIndex){
    return Obx(() =>
    selectedIndex == 0
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 5),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 6, flex:2,),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 1
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0, flex:2,),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 5),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 6, flex:2,),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 2
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 1),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 4),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),
              SizedBox(height: 5),
              SingleImageShowModule(index: 6),
            ],
          ),
        )
        : selectedIndex == 3
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 5),
                  ],
                ),
              ),
              SizedBox(width: 5),
              SingleImageShowModule(index: 6),
            ],
          ),
        )
        : selectedIndex == 4
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                  flex:2,
                  child: Column(
                    children: [
                      SingleImageShowModule(index: 0),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 1),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 2),
                    ],
                  )
              ),
              SizedBox(width: 5),
              Expanded(
                  flex:1,
                  child: Column(
                    children: [
                      SingleImageShowModule(index: 3),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 4),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 5),
                      SizedBox(height: 5),
                      SingleImageShowModule(index: 6),
                    ],
                  )
              ),

            ],
          ),
        )
        : selectedIndex == 5
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                flex:2,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),

              SizedBox(height: 5),
              Expanded(
                flex:1,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 6),
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 6
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                flex:2,
                child: Row(
                    children:[
                      SingleImageShowModule(index: 0),
                      SizedBox(width:5),
                      SingleImageShowModule(index: 1),
                    ]
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                flex:1,
                child: Row(
                    children:[
                      SingleImageShowModule(index: 2),
                      SizedBox(width:5),
                      SingleImageShowModule(index: 3),
                    ]
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                    children:[
                      SingleImageShowModule(index: 4),
                      SizedBox(width:5),
                      SingleImageShowModule(index: 5),
                      SizedBox(width:5),
                      SingleImageShowModule(index: 6),
                    ]
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 7
        ? Container(
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.red, width: 5),
              color: collageScreenController
                  .borderColor[
              collageScreenController
                  .activeColor.value]),
          child: Column(
            children: [
              SingleImageShowModule(index: 0, flex:2,),
              SizedBox(height: 5),
              Expanded(
                flex:1,
                child: Row(
                    children: [
                      SingleImageShowModule(index: 1),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 2),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 3),
                    ]
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                flex:1,
                child: Row(
                    children: [
                      SingleImageShowModule(index: 4),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 5),
                      SizedBox(width: 5),
                      SingleImageShowModule(index: 6),
                    ]
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 8
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(width: 5),
              SingleImageShowModule(index: 3),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 4),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 5),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 6),
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 9
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                  child: Row(
                      children:[
                        SingleImageShowModule(index: 0),
                        SizedBox(width:5),
                        SingleImageShowModule(index: 1),
                        SizedBox(width:5),
                        SingleImageShowModule(index: 2),
                      ]
                  )
              ),
              SizedBox(height: 5),
              Expanded(
                  child: Row(
                      children:[
                        SingleImageShowModule(index: 3),
                        SizedBox(width:5),
                        SingleImageShowModule(index: 4),
                      ]
                  )
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 5, flex:2,),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 6),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 10
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 1),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 4),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    SingleImageShowModule(index: 5, flex:2,),
                    SizedBox(height: 5),
                    SingleImageShowModule(index: 6),
                  ],
                ),
              ),


            ],
          ),
        )
        : selectedIndex == 11
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                      children: [
                        SingleImageShowModule(index: 0),
                        SizedBox(height:5),
                        SingleImageShowModule(index: 1),
                      ]
                  )

              ),
              SizedBox(width: 5),
              Expanded(
                  child: Column(
                      children: [
                        SingleImageShowModule(index: 2),
                        SizedBox(height:5),
                        SingleImageShowModule(index: 3),
                        SizedBox(height:5),
                        SingleImageShowModule(index: 4),
                      ]
                  )
              ),
              SizedBox(width: 5),
              Expanded(
                  child: Column(
                      children: [
                        SingleImageShowModule(index: 5),
                        SizedBox(height:5),
                        SingleImageShowModule(index: 6),
                      ]
                  )

              ),

            ],
          ),
        )
        : selectedIndex == 12
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 1),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 2),
                  ],
                ),
              ),
              SizedBox(height:5),
              SingleImageShowModule(index: 3),
              SizedBox(height:5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 4),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 5),
                    SizedBox(width:5),
                    SingleImageShowModule(index: 6),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 13
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [

              Expanded(
                flex:1,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width:5),
                    Expanded(
                        child: Row(
                            children:[
                              SingleImageShowModule(index: 1),
                              SizedBox(width:5),
                              SingleImageShowModule(index: 2),
                            ]
                        )
                    )
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                flex:2,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 3),
                    SizedBox(width:5),
                    Expanded(
                        child: Column(
                            children: [
                              SingleImageShowModule(index: 4),
                              SizedBox(height:5),
                              Expanded(
                                  child: Row(
                                      children: [
                                        SingleImageShowModule(index: 5),
                                        SizedBox(width:5),
                                        SingleImageShowModule(index: 6),
                                      ]
                                  )
                              )

                            ]
                        )
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
        : selectedIndex == 14
        ? Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1,flex:2,),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 3, flex:2,),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  children: [
                    SingleImageShowModule(index: 4),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 5),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 6),
                  ],
                ),
              ),
            ],
          ),
        )
        : selectedIndex == 15
        ?  Container(
          decoration: collageMainImageBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                flex:1,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 0),
                    SizedBox(width: 5),
                    SingleImageShowModule(index: 1, flex:2,),

                  ],
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                flex:2,
                child: Row(
                  children: [
                    SingleImageShowModule(index: 2),
                    SizedBox(width: 5),
                    Expanded(
                        flex:2,
                        child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                    children: [
                                      SingleImageShowModule(index: 3),
                                      SizedBox(width:5),
                                      SingleImageShowModule(index: 4),
                                    ]
                                ),
                              ),
                              SizedBox(height: 5),
                              Expanded(
                                child: Row(
                                    children: [
                                      SingleImageShowModule(index: 5),
                                      SizedBox(width:5),
                                      SingleImageShowModule(index: 6),
                                    ]
                                ),
                              )
                            ]
                        )
                    ),

                  ],
                ),
              ),
            ],
          ),
        )
        : Container());
  }
}
