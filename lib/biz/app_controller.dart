import 'dart:io';

import 'package:battery/battery.dart';
import 'package:device_info/device_info.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:truyen_chu/common/helper/ad_helper.dart';
import '../constants.dart';
import '../main.dart';
import '../models/models.dart';

class AppController extends GetxController {
  final isRefreshStoryBoard = false.obs;

  final _battery = Battery();

  final _box = GetStorage();

  final batteryPercent = 0.obs;

  final readHorizontal = true.obs;

  String? deviceId;

  @override
  void onInit() {
    super.onInit();
    bannerAdMedium.load();
    bannerAdMedium2.load();
    bannerAdMedium3.load();
    _getSettingRead();
    _listenBattery();
    _getDeviceId();
  }

  final mainCategory = [
    TagModel(id: 1, name: 'Tiên Hiệp'),
    TagModel(id: 2, name: 'Kiếm Hiệp'),
    TagModel(id: 3, name: 'Ngôn Tình'),
    TagModel(id: 4, name: 'Đô Thị'),
    TagModel(id: 8, name: 'Huyền Huyễn'),
    TagModel(id: 10, name: 'Quân Sự'),
    TagModel(id: 12, name: 'Sắc'),
    TagModel(id: 13, name: 'Đam Mỹ'),
    TagModel(id: 14, name: 'Bách Hợp'),
    TagModel(id: 15, name: 'Xuyên Không'),
    TagModel(id: 17, name: 'Trọng Sinh'),
    TagModel(id: 18, name: 'Trinh Thám'),
    TagModel(id: 21, name: 'Cung Đấu'),
    TagModel(id: 22, name: 'Nữ Cường'),
    TagModel(id: 24, name: 'Gia Đấu'),
    TagModel(id: 28, name: 'Cổ Đại'),
    TagModel(id: 29, name: 'Mạt Thế'),
    TagModel(id: 30, name: 'Ngược'),
    TagModel(id: 36, name: 'Sủng'),
    TagModel(id: 39, name: 'Hệ Thống'),
  ];

  final subCategory = [
    TagModel(id: 5, name: 'Khoa Huyễn'),
    TagModel(id: 6, name: 'Võng Du'),
    TagModel(id: 7, name: 'Dị Giới'),
    TagModel(id: 9, name: 'Linh Dị'),
    TagModel(id: 11, name: 'Lịch Sử'),
    TagModel(id: 16, name: 'Thám Hiểm'),
    TagModel(id: 19, name: 'Dị Năng'),
    TagModel(id: 20, name: 'Quan Trường'),
    TagModel(id: 23, name: 'Đông Phương'),
    TagModel(id: 25, name: 'Hài Hước'),
    TagModel(id: 26, name: 'Truyện Teen'),
    TagModel(id: 27, name: 'Điền Văn'),
    TagModel(id: 31, name: 'Khác'),
    TagModel(id: 32, name: 'Phương Tây'),
    TagModel(id: 33, name: 'Nữ Phụ'),
    TagModel(id: 34, name: 'Light Novel'),
    TagModel(id: 35, name: 'Việt Nam'),
    TagModel(id: 37, name: 'Đoản Văn'),
    TagModel(id: 38, name: 'Xuyên Nhanh'),
  ];

  final popularStoryTags = [
    TagModel(id: 3, name: 'Ngôn Tình'),
    TagModel(id: 4, name: 'Đô Thị'),
    TagModel(id: 15, name: 'Xuyên Không'),
    TagModel(id: 22, name: 'Nữ Cường'),
    TagModel(isCategory: false, id: 4, name: 'Tiên Hiệp Hay'),
    TagModel(isCategory: false, id: 7, name: 'Ngôn Tình Hay'),
    TagModel(isCategory: false, id: 9, name: 'Ngôn Tình Ngược'),
    TagModel(isCategory: false, id: 10, name: 'Ngôn Tình Sủng'),
    TagModel(isCategory: false, id: 13, name: 'Đam Mỹ Hay'),
  ];

  void _listenBattery() async {
    /// nghe thay dổi của % pin
    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      final _batteryPercent = await _battery.batteryLevel;
      batteryPercent.value = _batteryPercent;
    });
  }

  void _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId; // unique ID on Android
    }
    await analytics.setUserId(deviceId);
  }

  void _getSettingRead() async {
    final _readHorizontal = await _box.read(SCROLL_DIRECTION) ?? false;
    readHorizontal.value = _readHorizontal;
  }

  void writeScrollDirectionStory({required bool isHorizontal}) {
    readHorizontal.value = isHorizontal;
    _box.write(SCROLL_DIRECTION, isHorizontal);
  }

  final bannerAdMedium = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: AdRequest(),
    size: AdSize.mediumRectangle,
    listener: BannerAdListener(
      onAdLoaded: (_) {},
      onAdFailedToLoad: (ad, err) {
        ad.dispose();
      },
    ),
  );
  final bannerAdMedium2 = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: AdRequest(),
    size: AdSize.mediumRectangle,
    listener: BannerAdListener(
      onAdLoaded: (ad) {},
      onAdFailedToLoad: (ad, err) {
        ad.dispose();
      },
    ),
  );
  final bannerAdMedium3 = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: AdRequest(),
    size: AdSize.mediumRectangle,
    listener: BannerAdListener(
      onAdLoaded: (ad) {},
      onAdFailedToLoad: (ad, err) {
        ad.dispose();
      },
    ),
  );

  @override
  void onClose() {
    super.onClose();
  }
}
