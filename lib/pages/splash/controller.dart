import 'package:get/get.dart';
import '../../main.dart';
import '../../routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    analytics.setCurrentScreen(screenName: Routes.SPLASH);
    analytics.logAppOpen();
    _navigator();
  }

  void _navigator() async {
    await Future.delayed(2.seconds);
    Get.offNamed(Routes.MAIN);
  }
}
