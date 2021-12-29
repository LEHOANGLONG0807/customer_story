import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'biz/app_controller.dart';
import 'language/languages.dart';
import 'main.dart';
import 'pages/pages.dart';
import 'repository/repository.dart';
import 'routes/routes.dart';
import 'services/services.dart';
import 'theme/theme.dart';

final FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

class StoryWordApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    final initialBinding = BindingsBuilder(() {
      Get.put(AppController());
      Get.put(APIService());
      Get.put(DBService());
      Get.put(StoryRepositoryImpl(apiService: Get.find()));
      Get.put(SearchRepositoryImpl(apiService: Get.find()));
      Get.put(ChapterRepositoryImpl(apiService: Get.find()));
      Get.put(HomeController(repository: Get.find(), dbService: Get.find()));
    });
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 500)
      ..errorWidget = const Icon(
        Icons.clear,
        color: Colors.red,
        size: 50,
      )
      ..successWidget = const Icon(
        Icons.done,
        color: Colors.green,
        size: 50,
      )
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = AssetColors.primary
      ..backgroundColor = Colors.transparent
      ..indicatorColor = AssetColors.primary
      ..textColor = Colors.white
      ..maskType = EasyLoadingMaskType.black
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;

    return GetMaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      debugShowCheckedModeBanner: false,
      theme: StoryWordThemeData.themeData,
      darkTheme: StoryWordThemeData.themeData,
      getPages: AppPages.pages,
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
      initialBinding: initialBinding,
      builder: EasyLoading.init(),
      defaultTransition: Transition.native,
      initialRoute: Routes.SPLASH,
    );
  }
}
