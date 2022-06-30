import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pixytrim/common/store_session_local/store_session_local.dart';

import '../../common/helper/ad_helper.dart';

class PreviousSessionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  LocalStorage localStorage = LocalStorage();
  RxList<String> localSessionList = RxList();
  RxList<String> localSessionListNew = RxList();
  RxList<String> searchResult = RxList();
  //File localSessionName = Get.arguments[0];
  RxList<String> localCollageList = RxList();

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
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getLocalSessionList();
    await getLocalCollageSessionList();
    super.onInit();

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
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }

  getLocalSessionList() async {
    isLoading(true);
    localSessionList.value = await localStorage.getMainList();
    if (localSessionList.isEmpty) {
      localSessionList.value = [];
    }
    print("local session list: $localSessionList");

    // renameImage();
    // for(int i = (localSessionList.length-1); i>=0 ; i--) {
    //   //renameImage();
    //   localSessionListNew.add(localSessionList[i]);
    // }
    isLoading(false);
  }

  // Future renameImage() async {
  //   String ogPath = localSessionList.path;
  //   String frontPath = ogPath.split('cache')[0];
  //   print('frontPath: $frontPath');
  //   List<String> ogPathList = ogPath.split('/');
  //   print('ogPathList: $ogPathList');
  //   String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
  //   print('ogExt: $ogExt');
  //   DateTime today = new DateTime.now();
  //   String dateSlug = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
  //   localSessionList = await localSessionList.rename("${frontPath}cache/PhotoEditingDemo_$dateSlug.$ogExt");
  //   //print('File : ${widget.file}');
  //  // print('File Path : ${widget.file.path}');
  // }

  getLocalCollageSessionList() async {
    isLoading(true);
    localCollageList.value = await localStorage.getCollageMainList();
    if (localCollageList.isEmpty) {
      localCollageList.value = [];
    }
    isLoading(false);
  }

  deleteLocalSessionList() async {
    await localStorage.deleteImage();
  }

  updateLocalSessionList(int i) async {
    print("index: $i");
    isLoading(true);
    localSessionList.removeAt(i);
    localStorage.updateImageList(localSessionList);
    getLocalSessionList();
    isLoading(false);
  }

  updateLocalCollageSessionList(int i) async {
    print("index: $i");
    isLoading(true);
    localCollageList.removeAt(i);
    localStorage.updateCollageImageList(localCollageList);
    getLocalCollageSessionList();
    isLoading(false);
  }

  deleteCollageLocalSessionList() async {
    await localStorage.deleteCollageImage();
  }
}
