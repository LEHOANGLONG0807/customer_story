import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../repository/repository.dart';
import '../../constants.dart';
import '../../routes/routes.dart';

class ListStoryController extends GetxController {
  final StoryRepositoryImpl homeRepository;

  ListStoryController({required this.homeRepository});

  final title = ''.obs;

  String url = '';

  final listStory = <StoryModel>[].obs;

  int _currentPage = 1;

  bool isLoadMore = false;

  bool _loading = false;

  bool _isFormDetail = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      title.value = Get.arguments['title'] ?? '';
      url = Get.arguments['url'] ?? '';
      _isFormDetail = Get.arguments['isFormDetail'] ?? false;
    }
    _initLoad();
  }

  void _initLoad() async {
    analytics.setCurrentScreen(screenName: Routes.LIST_STORY);
    _currentPage = 1;
    isLoadMore = false;
    _loading = false;
    listStory.value = <StoryModel>[];
    try {
      EasyLoading.show();
      await fetchStores();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  Future fetchStores() async {
    if (_loading) {
      return;
    }
    _loading = true;
    final _response = await homeRepository.fetchStoryByURL(url: url, page: _currentPage);
    if (_response.length >= RESULT_LIMIT) {
      _currentPage++;
      isLoadMore = true;
    } else {
      isLoadMore = false;
    }
    listStory.addAll(_response);
    listStory.refresh();

    _loading = false;
  }

  void onTapStory(int storyId) async {
    if (_isFormDetail) {
      Get.back(result: storyId);
    } else {
      final _result = await Get.toNamed(Routes.DETAIL_STORY, arguments: {'id': storyId, 'isFormList': true});
      if (_result != null && _result is Map) {
        title.value = _result['title'] ?? '';
        url = _result['url'] ?? '';
      }
      _initLoad();
    }
  }
}
