import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/biz/biz.dart';
import '../../constants.dart';
import '../../enum.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../repository/repository.dart';
import '../../routes/routes.dart';

class SearchController extends GetxController {
  final StoryRepositoryImpl homeRepository;

  final SearchRepositoryImpl searchRepository;

  SearchController({required this.homeRepository, required this.searchRepository});

  final appController = Get.find<AppController>();

  final textController = TextEditingController();

  final statusSearch = StatusSearch.INIT_SEARCH.obs;

  final storyHots = <StoryModel>[].obs;

  final resultSearch = <StoryModel>[].obs;

  int _currentPage = 1;

  bool isLoadMore = false;

  bool _loading = false;

  @override
  void onInit() {
    super.onInit();
    analytics.setCurrentScreen(screenName: Routes.SEARCH);
    _initLoad();
  }

  void _initLoad() async {
    try {
      EasyLoading.show();
      await _fetchStoryHots();
    } catch (e) {
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
    EasyLoading.dismiss();
  }

  Future _fetchStoryHots() async {
    final _response = await homeRepository.fetchStoryHotByTagId(tagId: 0, limit: RESULT_LIMIT);
    storyHots.value = _response;
  }

  void onTapSearch() async {
    if (textController.text.isEmpty) return;
    _currentPage = 0;
    resultSearch.value = <StoryModel>[];
    try {
      EasyLoading.show();
      await searchStory();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
    await analytics.setUserProperty(name: SEARCH_STORY, value: textController.text);
    await analytics.logEvent(name: EVENT_SEARCH, parameters: {'key': textController.text});
    await analytics.logSearch(searchTerm: textController.text);
  }

  Future searchStory() async {
    if (_loading) {
      return;
    }
    _loading = true;
    final _response = await searchRepository.searchStoryByTitle(title: textController.text, page: _currentPage);
    if (_response.length >= RESULT_LIMIT) {
      _currentPage++;
      isLoadMore = true;
    } else {
      isLoadMore = false;
    }
    resultSearch.addAll(_response);
    resultSearch.refresh();
    if (resultSearch.isEmpty) {
      statusSearch.value = StatusSearch.NOT_VALUE;
    } else {
      statusSearch.value = StatusSearch.HAVE_VALUE;
    }
    _loading = false;
  }

  void onCancelSearch() {
    textController.text = '';
    statusSearch.value = StatusSearch.INIT_SEARCH;
  }

  void onTapTypeStory(TagModel model) async {
    if (model.isCategory) {
      Get.toNamed(Routes.LIST_STORY, arguments: {'title': model.name ?? '', 'url': '/stories/?tag_id=${model.id}'});
      await analytics.setUserProperty(name: TAG_STORY, value: '${model.id}');
      await analytics.logEvent(name: EVENT_LIST_BY_TAG, parameters: {'id': model.id});
    } else {
      Get.toNamed(Routes.LIST_STORY, arguments: {'title': model.name ?? '', 'url': '/stories/suggest/?tag_id=${model.id}'});
      await analytics.setUserProperty(name: SUGGEST_TAG_STORY, value: '${model.id}');
      await analytics.logEvent(name: EVENT_LIST_BY_SUGGEST_TAG, parameters: {'id': model.id});
    }
  }

  void onTapSendRequestUpdateStory() async {
    try {
      EasyLoading.show();
      final response = await homeRepository.feedbackStorySearch(key: textController.text);
      if (response) {
        textController.clear();
        statusSearch.value = StatusSearch.INIT_SEARCH;
        EasyLoading.showSuccess('Đã gửi yêu cầu cập nhật truyện: ${textController.text}');
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  void onTapStory(int storyId) {
    Get.toNamed(Routes.DETAIL_STORY, arguments: {'id': storyId});
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
