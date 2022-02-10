import 'package:get/get.dart';
import 'package:truyen_chu/routes/routes.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../pages.dart';

class MainController extends GetxController {
  late List<BottomNavBarModel> bottomNavBarItems;

  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    bottomNavBarItems = [
      BottomNavBarModel(icon: 'ic_home', label: 'Trang chủ', page: HomePage()),
      BottomNavBarModel(icon: 'ic_classify', label: 'Phân Loại', page: ClassifyPage()),
      BottomNavBarModel(icon: 'ic_story_board', label: 'Tủ truyện', page: StoryBoardPage()),
      BottomNavBarModel(icon: 'ic_story_board', label: 'Lịch Sử', page: HistoryReadingPage()),
    ];
  }

  void onItemTapped(int index) {
    currentTabIndex.value = index;
    if (index == 0) {
      analytics.setCurrentScreen(screenName: Routes.HOME);
    }
    if (index == 1) {
      analytics.setCurrentScreen(screenName: Routes.CLASSIFY);
    }
    if (index == 2) {
      analytics.setCurrentScreen(screenName: Routes.STORY_BOARD);
    }
    if (index == 3) {
      Get.find<HistoryReadingController>().initLoadData();
      analytics.setCurrentScreen(screenName: Routes.HISTORY_READING);
    }
  }

  @override
  void onClose() {
    currentTabIndex.close();
    super.onClose();
  }
}
