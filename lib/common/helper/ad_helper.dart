import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8682274379612225/7102240642';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8682274379612225/5375076067';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8682274379612225/6994429433";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8682274379612225/2417740235";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
