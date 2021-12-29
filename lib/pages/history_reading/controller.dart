import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../biz/biz.dart';
import '../../main.dart';
import '../../routes/routes.dart';
import '../../models/models.dart';
import '../../services/services.dart';

class HistoryReadingController extends GetxController {
  final DBService dbService;

  HistoryReadingController({required this.dbService});

  final _appController = Get.find<AppController>();

  final listStory = <StoryHistoryLocalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    analytics.setCurrentScreen(screenName: Routes.HISTORY_READING);
    _initLoadData();
  }

  void _initLoadData() async {
    try {
      EasyLoading.show();
      await _fetchStoryHistoryLocal();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  Future _fetchStoryHistoryLocal() async {
    final _response = await dbService.getListStoryHistory(limit: 1000);
    listStory.value = _response;
  }

  Future<bool> onTapAddStoryBoard(StoryHistoryLocalModel model) async {
    try {
      EasyLoading.show();
      final _boardLocalModel = model.toStoryBoardLocalModel;
      final _response = await dbService.addStoryBoard(model: _boardLocalModel);
      EasyLoading.dismiss();
      if (_response) {
        EasyLoading.showSuccess('Thêm vào tủ truyện thành công!');
        _appController.isRefreshStoryBoard.value = true;
      }

      return _response;
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
      return false;
    }
  }

  Future<bool> checkStoryBoard(int storyId) async {
    final _story = await dbService.getStoryBoardById(storyId: storyId);
    if (_story != null) {
      return true;
    }
    return false;
  }

  void onTapDelete(int id) async {
    try {
      EasyLoading.show();
      final _response = await dbService.deleteStoryHistoryById(storyId: id);
      EasyLoading.dismiss();
      if (_response) {
        listStory.removeWhere((element) => element.id == id);
        listStory.refresh();
        EasyLoading.showSuccess('Xóa thành công!');
      } else {
        EasyLoading.showError('Xóa thất bại!');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  void onTapItemStory(StoryHistoryLocalModel model) async {
    await Get.toNamed(Routes.READING_STORY, arguments: {
      'storyId': model.id,
      'chapterId': model.chapterId,
      'pageIndex': model.pageIndex,
      'backDetail': true,
    });
    _fetchStoryHistoryLocal();
  }
}
