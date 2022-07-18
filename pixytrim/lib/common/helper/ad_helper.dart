import 'dart:io';

class AdHelper {
  // ads ids initializing
  static const androidBannerId = "ca-app-pub-1292586033963553/1589686091";
  static const androidInterstitialId = "ca-app-pub-1292586033963553/4038657985";

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return androidBannerId;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return androidInterstitialId;
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
