import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/services/services.dart';
import '../../biz/biz.dart';
import '../../models/models.dart';
import '../../routes/routes.dart';

class StoryBoardController extends GetxController {
  final DBService dbService;

  StoryBoardController({required this.dbService});

  final _appController = Get.find<AppController>();

  final listStory = <StoryBoardLocalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initLoadData();
    ever<bool?>(_appController.isRefreshStoryBoard, (val) {
      if (val ?? false) {
        _fetchStoryBoardLocal();
        _appController.isRefreshStoryBoard.value = false;
      }
    });
  }

  void _initLoadData() async {
    try {
      EasyLoading.show();
      _fetchStoryBoardLocal();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  void _fetchStoryBoardLocal() async {
    final _response = await dbService.getListStoryBoard(limit: 1000);
    listStory.value = _response;
  }

  void onTapHistoryStory() {
    Get.toNamed(Routes.HISTORY_READING);
  }

  void onTapStory(int storyId) {
    Get.toNamed(Routes.DETAIL_STORY, arguments: {'id': storyId});
  }
}
