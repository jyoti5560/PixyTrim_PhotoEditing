import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/models/filter_screen_model/single_filter_option.dart';
import 'package:flutter/material.dart';
import 'package:pixytrim/screens/camera_screen/camera_screen.dart';

import '../../common/helper/ad_helper.dart';

class CameraScreenController extends GetxController {
  RxBool isLoading = false.obs;
  File file = Get.arguments[0];
  final selectedModule = Get.arguments[1];

  RxInt selectedIndex = 0.obs;
  RxInt colorSelectedIndex = 0.obs;
  RxInt simpleSelectedIndex = 0.obs;
  RxInt bwSelectedIndex = 0.obs;
  RxInt selectedImage = 0.obs;

  RxDouble compressSize = 61.0.obs;
  RxList<File> addImageFromCameraList = <File>[].obs;
  // final GlobalKey key = GlobalKey();

  List<String> iconList = [
    Images.ic_crop,
    Images.ic_filter,

    Images.ic_brightness,
    Images.ic_blur,
    Images.ic_blend,
    Images.ic_compress,
    Images.ic_resize,
    Images.ic_edit_image,
    Images.ic_image_ratio,
    // Images.ic_layout,
  ];

  List<String> bottomToolsList = [
    "Crop",
    "Filters",
    "Adjust",
    "Blur",
    "Blend",
    "Reduce",
    "Resize",
    "Edit",
    "Ratio",
  ];

  List<SingleFilterOption> colorFilterOptions = [];
  List<SingleFilterOption> simpleFilterOptions = [];
  List<SingleFilterOption> blackWhiteFilterOptions = [];

  late AdWidget? adWidget;
  late BannerAdListener listener;

  // late RewardedAd rewardedAd;
  late InterstitialAd interstitialAd;

 /* void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }*/

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a interstitial ad: ${err.message}');
        },
      ),
    );
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('%ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );
  }

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
  void onInit() {
    // Image List Clear And Add 1st Image in List

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

    myBanner.load();
    adWidget = AdWidget(
      ad: myBanner,
    );

    addImageFromCameraList.clear();
    print('addImageFromCameraList 1 : ${addImageFromCameraList.length}');
    addImageFromCameraList.add(file);
    print('addImageFromCameraList 2 : ${addImageFromCameraList.length}');
    print('selected:---${selectedImage.value}');

    // Add All Filter in List
    // filterOptions = [
    //   SingleFilterOption(
    //       filterWidget: noFilter(),
    //       filterName: 'No Filter',
    //       filterListWidget:
    //           noFilter(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter1(),
    //       filterName: 'Filter 1',
    //       filterListWidget:
    //           filter1(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter2(),
    //       filterName: 'Filter 2',
    //       filterListWidget:
    //           filter2(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter3(),
    //       filterName: 'Filter 3',
    //       filterListWidget:
    //           filter3(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter4(),
    //       filterName: 'Filter 4',
    //       filterListWidget:
    //           filter4(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter5(),
    //       filterName: 'Filter 5',
    //       filterListWidget:
    //           filter5(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter6(),
    //       filterName: 'Filter 6',
    //       filterListWidget:
    //           filter6(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter7(),
    //       filterName: 'Filter 7',
    //       filterListWidget:
    //           filter7(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter8(),
    //       filterName: 'Filter 8',
    //       filterListWidget:
    //           filter8(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter9(),
    //       filterName: 'Filter 9',
    //       filterListWidget:
    //           filter9(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter10(),
    //       filterName: 'Filter 10',
    //       filterListWidget:
    //           filter10(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter11(),
    //       filterName: 'Filter 11',
    //       filterListWidget:
    //           filter11(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter12(),
    //       filterName: 'Filter 12',
    //       filterListWidget:
    //           filter12(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter13(),
    //       filterName: 'Filter 13',
    //       filterListWidget:
    //           filter13(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter14(),
    //       filterName: 'Filter 14',
    //       filterListWidget:
    //           filter14(width: 100, height: 100, fit: BoxFit.cover)),
    //   SingleFilterOption(
    //       filterWidget: filter15(),
    //       filterName: 'Filter 15',
    //       filterListWidget:
    //           filter15(width: 100, height: 100, fit: BoxFit.cover)),
    // ];

    print('selected:---  ${selectedImage.value}');

    // Add All color Filter in List
    colorFilterOptions = [
      SingleFilterOption(
        filterWidget: noFilter(),
        filterName: 'No Filter',
        filterListWidget: noFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: kelvinFilter(),
        filterName: 'Kelvin',
        filterListWidget:
            kelvinFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: riseFilter(),
        filterName: 'Rise',
        filterListWidget:
            riseFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: toasterFilter(),
        filterName: 'Toaster',
        filterListWidget:
            toasterFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: willowFilter(),
        filterName: 'Willow',
        filterListWidget:
            willowFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: popRocketFilter(),
        filterName: 'PopRocket',
        filterListWidget:
            popRocketFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: perioFilter(),
        filterName: 'Perio',
        filterListWidget:
            perioFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: exHourFilter(),
        filterName: 'Ex-Hour',
        filterListWidget:
            exHourFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: bluePillFilter(),
        filterName: 'BluePill',
        filterListWidget:
            bluePillFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: slowBurnFilter(),
        filterName: 'SlowBurn',
        filterListWidget:
            slowBurnFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: inkwellFilter(),
        filterName: 'Inkwell',
        filterListWidget:
            inkwellFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: yellowFilter(),
        filterName: 'Yellow',
        filterListWidget:
            yellowFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: blueFilter(),
        filterName: 'Blue',
        filterListWidget:
            blueFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: greenFilter(),
        filterName: 'Green',
        filterListWidget:
            greenFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
    ];

    simpleFilterOptions = [
      SingleFilterOption(
        filterWidget: noFilter(),
        filterName: 'No Filter',
        filterListWidget: noFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: srgb(),
        filterName: 'SRGB',
        filterListWidget: srgb(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: linear(),
        filterName: 'Linear',
        filterListWidget: linear(width: 100, height: 100, fit: BoxFit.cover),
      ),
      // SingleFilterOption(
      //   filterWidget: sepiaFilter(),
      //   filterName: 'Sepia',
      //   filterListWidget:
      //       sepiaFilter(width: 100, height: 100, fit: BoxFit.cover),
      // ),
      // SingleFilterOption(
      //   filterWidget: invertFilter(),
      //   filterName: 'Invert',
      //   filterListWidget: linear(width: 100, height: 100, fit: BoxFit.cover),
      // ),
      SingleFilterOption(
        filterWidget: greyscaleFilter(),
        filterName: 'GreyScale',
        filterListWidget:
            greyscaleFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
    ];

    blackWhiteFilterOptions = [
      SingleFilterOption(
        filterWidget: noFilter(),
        filterName: 'No Filter',
        filterListWidget: noFilter(width: 100, height: 100, fit: BoxFit.cover),
      ),
      SingleFilterOption(
        filterWidget: bw1(),
        filterName: 'B&W 1',
        filterListWidget: bw1(width: 100, height: 100, fit: BoxFit.cover),
      ),
      // SingleFilterOption(
      //   filterWidget: bw2(),
      //   filterName: 'B&W 2',
      //   filterListWidget: bw2(width: 100, height: 100, fit: BoxFit.cover),
      // ),
    ];
    loadInterstitialAd();
    super.onInit();
  }

  addCameraImageInList({required File file}) {
    addImageFromCameraList.add(file);
    print('addImageFromCameraList : ${addImageFromCameraList.length}');
  }

  List<SingleFilterOption> filterOptions = [];

  Widget noFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: Image.file(
          addImageFromCameraList[selectedImage.value],
          width: width ?? null,
          height: height ?? null,
          fit: fit ?? null,
        ),
      ),
    );
  }

  Widget kelvinFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(
            [
              0.9,
              0.5,
              0.1,
              0.0,
              0.0,
              0.3,
              0.8,
              0.1,
              0.0,
              0.0,
              0.2,
              0.3,
              0.5,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ],
          ),
          child: Image.file(
            addImageFromCameraList[selectedImage.value],
            width: width ?? null,
            height: height ?? null,
            fit: fit ?? null,
          ),
        ),
      ),
    );
  }

  Widget riseFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.3,
            -0.3,
            1.1,
            0.0,
            0.0,
            0.0,
            0.8,
            0.2,
            0.0,
            0.0,
            0.0,
            0.0,
            0.8,
            0.2,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0
          ]),
          child: Image.file(
            addImageFromCameraList[selectedImage.value],
            width: width ?? null,
            height: height ?? null,
            fit: fit ?? null,
          ),
        ),
      ),
    );
  }

  Widget toasterFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            2.1,
            0.0,
            0.0,
            0.0,
            0.0,
            -0.2,
            1.0,
            0.3,
            0.1,
            0.0,
            -0.1,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0
          ]),
          child: Image.file(
            addImageFromCameraList[selectedImage.value],
            width: width ?? null,
            height: height ?? null,
            fit: fit ?? null,
          ),
        ),
      ),
    );
  }

  Widget willowFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix(
              [
                0.0,
                1.0,
                0.0,
                0.0,
                0.0,
                0.0,
                1.0,
                0.0,
                0.0,
                0.0,
                0.0,
                1.0,
                0.0,
                0.0,
                0.0,
                0.0,
                1.0,
                0.0,
                1.0,
                0.0
              ],
            ),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget popRocketFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.8,
              0.5,
              0.0,
              0.0,
              0.0,
              0.0,
              1.1,
              0.0,
              0.0,
              0.0,
              0.0,
              0.2,
              1.1,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget perioFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.1,
              0.0,
              0.0,
              0.0,
              0.0,
              0.2,
              1.0,
              -0.4,
              0.0,
              0.0,
              -0.1,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget exHourFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.2,
              0.1,
              0.5,
              0.0,
              0.0,
              0.1,
              1.0,
              0.05,
              0.0,
              0.0,
              0.0,
              0.1,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget bluePillFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.4,
              0.4,
              -0.3,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.2,
              0.0,
              0.0,
              -1.2,
              0.6,
              0.7,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget slowBurnFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.0,
              0.0,
              0.2,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget inkwellFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.2126,
              0.7152,
              0.0722,
              0.0,
              0.0,
              0.2126,
              0.7152,
              0.0722,
              0.0,
              0.0,
              0.2126,
              0.7152,
              0.0722,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget yellowFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget blueFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget greenFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0
          ]),
          child: Image.file(
            addImageFromCameraList[selectedImage.value],
            width: width ?? null,
            height: height ?? null,
            fit: fit ?? null,
          ),
        ),
      ),
    );
  }

  Widget filter14({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget filter15({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              1.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.5,
              0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,
              fit: fit ?? null,
            )),
      ),
    );
  }

  Widget bw1({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: Image.file(
            addImageFromCameraList[selectedImage.value],
            width: width ?? null,
            height: height ?? null,
            fit: fit ?? null,
          ),
        ),
      ),
    );
  }

  // Widget bw2({double? width, double? height, BoxFit? fit}) {
  //   return Obx(
  //     () => Container(
  //       width: width ?? null,
  //       height: height ?? null,
  //       child: ColorFiltered(
  //         colorFilter: ColorFilter.matrix(
  //           [
  //             0.2126,
  //             0.7152,
  //             0.0722,
  //             0,
  //             0,
  //             0.2126,
  //             0.7152,
  //             0.0722,
  //             0,
  //             0,
  //             0.2126,
  //             0.7152,
  //             0.0722,
  //             0,
  //             0.2126,
  //             0.0722,
  //             0,
  //             0,
  //             1,
  //             0,
  //           ],
  //         ),
  //         child: Image.file(
  //           addImageFromCameraList[selectedImage.value],
  //           width: width ?? null,
  //           height: height ?? null,
  //           fit: fit ?? null,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget srgb({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
          colorFilter: ColorFilter.srgbToLinearGamma(),
          child: Image.file(
            addImageFromCameraList[selectedImage.value],
            width: width ?? null,
            height: height ?? null,
            fit: fit ?? null,
          ),
        ),
      ),
    );
  }

  Widget linear({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
          colorFilter: ColorFilter.linearToSrgbGamma(),
          child: Image.file(
            addImageFromCameraList[selectedImage.value],
            width: width ?? null,
            height: height ?? null,
            fit: fit ?? null,
          ),
        ),
      ),
    );
  }

  // Widget invertFilter({double? width, double? height, BoxFit? fit}) {
  //   return Obx(
  //     () => Container(
  //       width: width ?? null,
  //       height: height ?? null,
  //       child: ColorFiltered(
  //         colorFilter: ColorFilter.matrix([
  //           -1,
  //           0,
  //           0,
  //           0,
  //           255,
  //           0,
  //           -1,
  //           0,
  //           0,
  //           255,
  //           0,
  //           0,
  //           -1,
  //           0,
  //           255,
  //           0,
  //           0,
  //           0,
  //           1,
  //           0,
  //         ]),
  //         child: Image.file(
  //           addImageFromCameraList[selectedImage.value],
  //           width: width ?? null,
  //           height: height ?? null,
  //           fit: fit ?? null,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget sepiaFilter({double? width, double? height, BoxFit? fit}) {
  //   return Obx(
  //     () => Container(
  //       width: width ?? null,
  //       height: height ?? null,
  //       child: ColorFiltered(
  //         colorFilter: ColorFilter.matrix([
  //           -1,
  //           0,
  //           0,
  //           0,
  //           255,
  //           0,
  //           -1,
  //           0,
  //           0,
  //           255,
  //           0,
  //           0,
  //           -1,
  //           0,
  //           255,
  //           0,
  //           0,
  //           0,
  //           1,
  //           0,
  //         ]),
  //         child: Image.file(
  //           addImageFromCameraList[selectedImage.value],
  //           width: width ?? null,
  //           height: height ?? null,
  //           fit: fit ?? null,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget greyscaleFilter({double? width, double? height, BoxFit? fit}) {
    return Obx(
      () => Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            -1,
            0,
            0,
            0,
            255,
            0,
            -1,
            0,
            0,
            255,
            0,
            0,
            -1,
            0,
            255,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: Image.file(
            addImageFromCameraList[selectedImage.value],
            width: width ?? null,
            height: height ?? null,
            fit: fit ?? null,
          ),
        ),
      ),
    );
  }

  loading() {
    isLoading(true);
    isLoading(false);
  }
}
