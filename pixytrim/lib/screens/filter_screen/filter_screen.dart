import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'dart:ui' as ui;

import '../../common/custom_color.dart';
import '../../common/helper/ad_helper.dart';

class FilterScreen extends StatefulWidget {
  @override
  FilterScreenState createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen>
    with SingleTickerProviderStateMixin {
  // FilterScreenController filterScreenController = Get.put(FilterScreenController());
  CameraScreenController csController = Get.find<CameraScreenController>();
  File? file;
  final GlobalKey key = GlobalKey();

  late TabController categoryTabController;

  late AdWidget? adWidget;

  late BannerAdListener listener;

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    sizes: [
      AdSize.banner,
    ],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
      },

      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.

        ad.dispose();
        print('Ad failed to load: $error');
      },

      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );

    adWidget = AdWidget(
      ad: myBanner,
    );
    myBanner.load();
    categoryTabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print('selectedImage : ${csController.selectedImage.value}');
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: filterImage(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  filterCategoryView(),
                  filterCategoryBar(),
                  SizedBox(height: 5),
                  Container(
                    height: 48,
                    child: adWidget,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget filterCategoryBar() {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: TabBar(
        isScrollable: true,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColor.kBlackColor,
        labelPadding:
            EdgeInsets.only(top: 10.0, bottom: 5, left: 10, right: 15),
        unselectedLabelColor: AppColor.kBlackColor.withOpacity(0.35),
        controller: categoryTabController,
        labelStyle: TextStyle(fontSize: 16),
        tabs: [
          Tab(text: "Simple"),
          Tab(text: "Color"),
          Tab(text: "B&W"),
          // Container(child: Tab(text: "Border Radius")),
          // Container(child: Tab(text: "WallPapers")),
        ],
      ),
    );
  }

  Widget filterCategoryView() {
    return Container(
      height: Get.height * 0.13,
      child: TabBarView(
        controller: categoryTabController,
        children: [
          simpleFilterList(),
          colorFilterList(),
          BlackWhiteFilterList(),
          // LayoutScreen(),
          // BorderWidthScreen(),
          // BorderColorScreen(),
          // BorderRadiusScreen(),
          // WallPapersScreen(),
        ],
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
                      "Filters",
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
                    },
                    child: Container(child: Icon(Icons.check_rounded)),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget simpleFilterList() {
    return Container(
      height: 140,
      child: ListView.builder(
        itemCount: csController.simpleFilterOptions.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final filter = csController.simpleFilterOptions[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                csController.simpleSelectedIndex.value = index;
                print(
                    'selectedIndex : ${csController.simpleSelectedIndex.value}');
              });
            },
            child: Column(
              children: [
                Container(
                  height: 75,
                  width: 75,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(right: 10),
                  decoration: borderGradientDecoration(),
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: csController
                          .simpleFilterOptions[index].filterListWidget,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${filter.filterName}  ",
                      style: TextStyle(
                        fontFamily: "",
                        color: csController.simpleSelectedIndex.value == index
                            ? Colors.black87
                            : Colors.grey.shade600,
                        fontWeight:
                            csController.simpleSelectedIndex.value == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget colorFilterList() {
    return Container(
      height: 140,
      child: ListView.builder(
        itemCount: csController.colorFilterOptions.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                csController.colorSelectedIndex.value = index;
                print(
                    'selectedIndex : ${csController.colorSelectedIndex.value}');
              });
            },
            child: Column(
              children: [
                Container(
                  height: 75,
                  width: 75,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(right: 10),
                  decoration: borderGradientDecoration(),
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: csController
                          .colorFilterOptions[index].filterListWidget,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "${csController.colorFilterOptions[index].filterName}  ",
                  style: TextStyle(
                      fontFamily: "",
                      color: csController.colorSelectedIndex.value == index
                          ? Colors.black87
                          : Colors.grey.shade600,
                      fontWeight: csController.colorSelectedIndex.value == index
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget BlackWhiteFilterList() {
    return Container(
      height: 140,
      child: ListView.builder(
        itemCount: csController.blackWhiteFilterOptions.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                csController.bwSelectedIndex.value = index;
                print('selectedIndex : ${csController.bwSelectedIndex.value}');
              });
            },
            child: Column(
              children: [
                Container(
                  height: 75,
                  width: 75,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(right: 10),
                  decoration: borderGradientDecoration(),
                  child: Container(
                    height: 95,
                    width: 95,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: csController
                          .blackWhiteFilterOptions[index].filterListWidget,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "${csController.blackWhiteFilterOptions[index].filterName}  ",
                  style: TextStyle(
                      fontFamily: "",
                      color: csController.bwSelectedIndex.value == index
                          ? Colors.black87
                          : Colors.grey.shade600,
                      fontWeight: csController.bwSelectedIndex.value == index
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  displayImage() {
    if (categoryTabController.index == 0) {
      return csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty &&
              csController.simpleSelectedIndex.value == 0
          ? csController.simpleFilterOptions[0].filterWidget
          : csController.addImageFromCameraList[csController.selectedImage.value].path
                      .toString()
                      .isNotEmpty &&
                  csController.simpleSelectedIndex.value == 1
              ? csController.simpleFilterOptions[1].filterWidget
              : csController.addImageFromCameraList[csController.selectedImage.value].path
                          .toString()
                          .isNotEmpty &&
                      csController.simpleSelectedIndex.value == 2
                  ? csController.simpleFilterOptions[2].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path
                              .toString()
                              .isNotEmpty &&
                          csController.simpleSelectedIndex.value == 3
                      ? csController.simpleFilterOptions[3].filterWidget
                      : csController.addImageFromCameraList[csController.selectedImage.value].path
                                  .toString()
                                  .isNotEmpty &&
                              csController.simpleSelectedIndex.value == 4
                          ? csController.simpleFilterOptions[4].filterWidget
                          : csController.addImageFromCameraList[csController.selectedImage.value].path
                                      .toString()
                                      .isNotEmpty &&
                                  csController.simpleSelectedIndex.value == 5
                              ? csController.simpleFilterOptions[5].filterWidget
                              : csController.addImageFromCameraList[csController.selectedImage.value].path
                                          .toString()
                                          .isNotEmpty &&
                                      csController.simpleSelectedIndex.value ==
                                          6
                                  ? csController
                                      .simpleFilterOptions[6].filterWidget
                                  : csController
                                              .addImageFromCameraList[csController.selectedImage.value]
                                              .path
                                              .toString()
                                              .isNotEmpty &&
                                          csController.simpleSelectedIndex.value == 7
                                      ? csController.simpleFilterOptions[7].filterWidget
                                      : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.simpleSelectedIndex.value == 8
                                          ? csController.simpleFilterOptions[8].filterWidget
                                          : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.simpleSelectedIndex.value == 9
                                              ? csController.simpleFilterOptions[9].filterWidget
                                              : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.simpleSelectedIndex.value == 10
                                                  ? csController.simpleFilterOptions[10].filterWidget
                                                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.simpleSelectedIndex.value == 11
                                                      ? csController.simpleFilterOptions[11].filterWidget
                                                      : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.simpleSelectedIndex.value == 12
                                                          ? csController.simpleFilterOptions[12].filterWidget
                                                          : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.simpleSelectedIndex.value == 13
                                                              ? csController.simpleFilterOptions[13].filterWidget
                                                              : Container();
    } else if (categoryTabController.index == 1) {
      return csController
                  .addImageFromCameraList[csController.selectedImage.value].path
                  .toString()
                  .isNotEmpty &&
              csController.colorSelectedIndex.value == 0
          ? csController.colorFilterOptions[0].filterWidget
          : csController.addImageFromCameraList[csController.selectedImage.value].path
                      .toString()
                      .isNotEmpty &&
                  csController.colorSelectedIndex.value == 1
              ? csController.colorFilterOptions[1].filterWidget
              : csController.addImageFromCameraList[csController.selectedImage.value].path
                          .toString()
                          .isNotEmpty &&
                      csController.colorSelectedIndex.value == 2
                  ? csController.colorFilterOptions[2].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path
                              .toString()
                              .isNotEmpty &&
                          csController.colorSelectedIndex.value == 3
                      ? csController.colorFilterOptions[3].filterWidget
                      : csController.addImageFromCameraList[csController.selectedImage.value].path
                                  .toString()
                                  .isNotEmpty &&
                              csController.colorSelectedIndex.value == 4
                          ? csController.colorFilterOptions[4].filterWidget
                          : csController.addImageFromCameraList[csController.selectedImage.value].path
                                      .toString()
                                      .isNotEmpty &&
                                  csController.colorSelectedIndex.value == 5
                              ? csController.colorFilterOptions[5].filterWidget
                              : csController.addImageFromCameraList[csController.selectedImage.value].path
                                          .toString()
                                          .isNotEmpty &&
                                      csController.colorSelectedIndex.value == 6
                                  ? csController
                                      .colorFilterOptions[6].filterWidget
                                  : csController
                                              .addImageFromCameraList[csController.selectedImage.value]
                                              .path
                                              .toString()
                                              .isNotEmpty &&
                                          csController.colorSelectedIndex.value == 7
                                      ? csController.colorFilterOptions[7].filterWidget
                                      : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.colorSelectedIndex.value == 8
                                          ? csController.colorFilterOptions[8].filterWidget
                                          : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.colorSelectedIndex.value == 9
                                              ? csController.colorFilterOptions[9].filterWidget
                                              : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.colorSelectedIndex.value == 10
                                                  ? csController.colorFilterOptions[10].filterWidget
                                                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.colorSelectedIndex.value == 11
                                                      ? csController.colorFilterOptions[11].filterWidget
                                                      : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.colorSelectedIndex.value == 12
                                                          ? csController.colorFilterOptions[12].filterWidget
                                                          : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.colorSelectedIndex.value == 13
                                                              ? csController.colorFilterOptions[13].filterWidget
                                                              : Container();
    } else if (categoryTabController.index == 2) {
      return csController.addImageFromCameraList[csController.selectedImage.value].path
                  .toString()
                  .isNotEmpty &&
              csController.bwSelectedIndex.value == 0
          ? csController.blackWhiteFilterOptions[0].filterWidget
          : csController.addImageFromCameraList[csController.selectedImage.value].path
                      .toString()
                      .isNotEmpty &&
                  csController.bwSelectedIndex.value == 1
              ? csController.blackWhiteFilterOptions[1].filterWidget
              : csController.addImageFromCameraList[csController.selectedImage.value].path
                          .toString()
                          .isNotEmpty &&
                      csController.bwSelectedIndex.value == 2
                  ? csController.blackWhiteFilterOptions[2].filterWidget
                  : csController.addImageFromCameraList[csController.selectedImage.value].path
                              .toString()
                              .isNotEmpty &&
                          csController.bwSelectedIndex.value == 3
                      ? csController.blackWhiteFilterOptions[3].filterWidget
                      : csController.addImageFromCameraList[csController.selectedImage.value].path
                                  .toString()
                                  .isNotEmpty &&
                              csController.bwSelectedIndex.value == 4
                          ? csController.blackWhiteFilterOptions[4].filterWidget
                          : csController.addImageFromCameraList[csController.selectedImage.value].path
                                      .toString()
                                      .isNotEmpty &&
                                  csController.bwSelectedIndex.value == 5
                              ? csController
                                  .blackWhiteFilterOptions[5].filterWidget
                              : csController.addImageFromCameraList[csController.selectedImage.value].path
                                          .toString()
                                          .isNotEmpty &&
                                      csController.bwSelectedIndex.value == 6
                                  ? csController
                                      .blackWhiteFilterOptions[6].filterWidget
                                  : csController.addImageFromCameraList[csController.selectedImage.value].path
                                              .toString()
                                              .isNotEmpty &&
                                          csController.bwSelectedIndex.value == 7
                                      ? csController.blackWhiteFilterOptions[7].filterWidget
                                      : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.bwSelectedIndex.value == 8
                                          ? csController.blackWhiteFilterOptions[8].filterWidget
                                          : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.bwSelectedIndex.value == 9
                                              ? csController.blackWhiteFilterOptions[9].filterWidget
                                              : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.bwSelectedIndex.value == 10
                                                  ? csController.blackWhiteFilterOptions[10].filterWidget
                                                  : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.bwSelectedIndex.value == 11
                                                      ? csController.blackWhiteFilterOptions[11].filterWidget
                                                      : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.bwSelectedIndex.value == 12
                                                          ? csController.blackWhiteFilterOptions[12].filterWidget
                                                          : csController.addImageFromCameraList[csController.selectedImage.value].path.toString().isNotEmpty && csController.bwSelectedIndex.value == 13
                                                              ? csController.blackWhiteFilterOptions[13].filterWidget
                                                              : Container();
    }
  }

  Widget filterImage() {
    return Obx(
      () => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: RepaintBoundary(
          key: key,
          child: Container(
            child: displayImage(),
          ),
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

  showAlertDialog() {
    Widget cancelButton = IconsButton(
      onPressed: () {
        Get.back();
      },
      text: 'No',
      color: AppColor.kBorderGradientColor3,
      textStyle: TextStyle(color: Colors.white),
    );

    Widget continueButton = IconsButton(
      onPressed: () async {
        csController.interstitialAd.show();
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
      msg: "Do you want to Exit ?",
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

  // Future saveImage() async {
  //   await GallerySaver.saveImage("${csController.addImageFromCameraList[csController.selectedImage.value].path}",
  //       albumName: "OTWPhotoEditingDemo");
  // }

}
