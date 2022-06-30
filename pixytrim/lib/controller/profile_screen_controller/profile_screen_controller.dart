import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/helper/ad_helper.dart';

class ProfileScreenController extends GetxController {
  String? userId;
  String? uName;
  String? uEmail;
  String? uPhotoUrl;
  RxBool isLoading = false.obs;

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
    await getUserDetails();

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

  getUserDetails() async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    uName = prefs.getString('userName') ?? "";
    uEmail = prefs.getString('email') ?? "";
    uPhotoUrl = prefs.getString('photo') ?? "";
    print("Username: $uPhotoUrl");
    isLoading(false);
  }

  clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('userName');
    print('usename: ${prefs.remove('userName')}');
    prefs.remove('email');
    prefs.remove('photo');
    prefs.setBool('isLoggedIn', false);
  }
}
