import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/common/common.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../biz/app_controller.dart';
import '../../main.dart';
import '../../services/services.dart';
import '../../constants.dart';
import '../../models/models.dart';
import '../../repository/repository.dart';
import '../../routes/routes.dart';

class DetailStoryController extends GetxController {
  final StoryRepositoryImpl storyRepository;

  final ChapterRepositoryImpl chapterRepository;

  final DBService dbService;

  DetailStoryController({required this.chapterRepository, required this.storyRepository, required this.dbService});

  int storyId = -1;

  final dataKey = new GlobalKey();

  final appController = Get.find<AppController>();

  final scrollController = ScrollController();

  final detailScrollController = ScrollController();

  final showTitle = false.obs;

  final nativeAdController = NativeAdmobController();

  final showButtonScrollTop = false.obs;

  final showReview = true.obs;

  final sortAZ = true.obs;

  final countStar = 0.0.obs;

  final showButtonAddBoard = false.obs;

  final storyModel = StoryModel(id: -1).obs;

  final chapterTitles = <ChapterTitleModel>[].obs;

  int _currentPage = 1;

  bool _isLoadMore = false;

  bool _loading = false;

  bool _isFormList = false;

  int _totalPageChapter = 0;

  final backgroundColor = AssetColors.color4F1F33.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      storyId = Get.arguments['id'] ?? -1;
      _isFormList = Get.arguments['isFormList'] ?? false;
    }
    nativeAdController.reloadAd();

    _initLoad();
    analytics.setCurrentScreen(screenName: Routes.DETAIL_STORY);
    _listeningScroll();
  }

  void _initLoad() async {
    sortAZ.value = true;
    _currentPage = 1;
    _isLoadMore = false;
    _loading = false;
    _totalPageChapter = 0;
    chapterTitles.value = [];
    try {
      EasyLoading.show();
      await _getStoryDetail();
      if (storyModel.value.chap! > 0) {
        await _fetchChapterTitles();
      }
      EasyLoading.dismiss();
      _checkStoryBoardLocal();
      final _random = Random().nextInt(8);
      backgroundColor.value = AssetColors.colorRandomDetail[_random];
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  Future _getStoryDetail() async {
    final _response = await storyRepository.getStoryById(id: storyId);
    if (_response != null) {
      storyModel.value = _response;
      if ((_response.myRate ?? 0) > 0) {
        showReview.value = false;
      } else {
        showReview.value = true;
      }
      await analytics.setUserProperty(name: DETAIL_STORY, value: '${storyModel.value.id}');
      await analytics.logEvent(name: EVENT_DETAIL, parameters: {'id': storyModel.value.id});
    } else {
      Get.dialog(DialogOneButton(title: 'Thông báo', message: 'Truyện đã bị xóa\nVui lòng chọn truyện khác.', titleButton: 'Đồng ý'));
      return;
    }
  }

  Future _fetchChapterTitles() async {
    if (_loading) {
      return;
    }
    _loading = true;
    final _response = await chapterRepository.fetchChapterTitleById(storyId: storyId, page: _currentPage);
    final _list = _response.items;
    if (_totalPageChapter == 0) {
      _totalPageChapter = _response.totalPages;
    }
    if (_list.length >= RESULT_LIMIT_CHAPTER && _currentPage < _response.totalPages) {
      _currentPage++;
      _isLoadMore = true;
    } else {
      _isLoadMore = false;
    }
    chapterTitles.addAll(_list);
    chapterTitles.refresh();
    _loading = false;
  }

  void _checkStoryBoardLocal() async {
    final _story = await dbService.getStoryBoardById(storyId: storyId);
    if (_story != null) {
      showButtonAddBoard.value = false;
    } else {
      showButtonAddBoard.value = true;
    }
  }

  void onTapAddStoryBoard() async {
    try {
      EasyLoading.show();
      final _boardLocalModel = storyModel.value.toStoryBroadLocalModel;
      final _response = await dbService.addStoryBoard(model: _boardLocalModel);
      if (_response) {
        EasyLoading.showSuccess('Thêm vào tủ truyện thành công!');
        showButtonAddBoard.value = false;
        appController.isRefreshStoryBoard.value = true;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  void onTapSortChapters() {
    sortAZ.value = !sortAZ.value;
    chapterTitles.value = [];
    _isLoadMore = false;
    _loading = false;
    if (sortAZ.value) {
      _initSortAZ();
    } else {
      _initSortZA();
    }
  }

  void _initSortZA() async {
    _currentPage = _totalPageChapter;
    await _fetchChapterTitlesZA();
  }

  void _initSortAZ() async {
    _currentPage = 1;
    await _fetchChapterTitles();
  }

  Future _fetchChapterTitlesZA() async {
    if (_loading) {
      return;
    }
    _loading = true;
    final _response = await chapterRepository.fetchChapterTitleById(storyId: storyId, page: _currentPage);
    final _list = _response.items;
    _list.sort((a, b) => b.id.compareTo(a.id));
    if (_currentPage > 1) {
      _currentPage--;
      _isLoadMore = true;
    } else {
      _isLoadMore = false;
    }
    chapterTitles.addAll(_list);
    chapterTitles.refresh();
    _loading = false;
  }

  void onTapAuthorTitle() async {
    await analytics.setUserProperty(name: AUTHOR_STORY, value: '${storyModel.value.authorId}');
    await analytics.logEvent(name: EVENT_AUTHOR, parameters: {'id': storyModel.value.authorId});
    if (_isFormList) {
      final _args = {'title': storyModel.value.authorName ?? '', 'url': '/stories/?author_id=${storyModel.value.authorId ?? -1}'};
      Get.back(result: _args);
    } else {
      final _result = await Get.toNamed(Routes.LIST_STORY, arguments: {
        'title': storyModel.value.authorName ?? '',
        'url': '/stories/?author_id=${storyModel.value.authorId ?? -1}',
        'isFormDetail': true,
      });
      if (_result != null && _result is int) {
        storyId = _result;
        _initLoad();
      }
    }
  }

  void onTapReadingStory() async {
    final _historyLocalModel = await dbService.getStoryHistoryById(storyId: storyId);
    if (_historyLocalModel != null) {
      await Get.toNamed(Routes.READING_STORY, arguments: {
        'storyId': _historyLocalModel.id,
        'chapterId': _historyLocalModel.chapterId,
        'pageIndex': _historyLocalModel.pageIndex,
      });
      _checkStoryBoardLocal();
    } else {
      onTapChapter();
    }
  }

  void onTapChapter({int? chapterId}) async {
    final _chapterId = chapterId ?? 1;
    await Get.toNamed(Routes.READING_STORY, arguments: {
      'storyId': storyModel.value.id,
      'chapterId': _chapterId,
    });
    _checkStoryBoardLocal();
  }

  void onTapButtonScrollTop() {
    Scrollable.ensureVisible(dataKey.currentContext!, curve: Curves.linearToEaseOut);
  }

  void onTapSendRatting() async {
    try {
      EasyLoading.show();
      final _response = await storyRepository.reviewStory(storyId: storyId, star: countStar.value.toInt());
      if (_response) {
        EasyLoading.showSuccess('Đánh giá thành công!');
        showReview.value = false;
      }
      EasyLoading.dismiss();
      await analytics.logEvent(name: EVENT_RATING, parameters: {'star': countStar.value.toInt()});
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  void loadMoreChapters(ScrollNotification notification) {
    showButtonScrollTop.value = notification.metrics.pixels > 2600;
    if (_isLoadMore && notification.metrics.pixels + 300 >= notification.metrics.maxScrollExtent) {
      if (sortAZ.value) {
        _fetchChapterTitles();
      } else {
        _fetchChapterTitlesZA();
      }
    }
  }

  void _listeningScroll() {
    detailScrollController.addListener(() {
      if (detailScrollController.offset + 30 >= detailScrollController.position.maxScrollExtent) {
        showTitle.value = true;
      } else {
        showTitle.value = false;
      }
    });
  }

  String replaceHtmlData(String content, int maxSubString, {String firstStart = "[", String lastEnd = "]"}) {
    return content.replaceFirst(subStringBetweenTwo(content, firstStart, lastEnd), "").length < maxSubString + 10
        ? content.replaceFirst(subStringBetweenTwo(content, firstStart, lastEnd), "")
        : content.replaceFirst(subStringBetweenTwo(content, firstStart, lastEnd), "").substring(0, maxSubString) + "...";
  }

  String subStringBetweenTwo(String content, String start, String end) {
    if (content.isEmpty) return "";
    final startIndex = content.indexOf(start);
    final endIndex = content.indexOf(end, startIndex + start.length);
    if (startIndex == -1 || endIndex == -1) return "";
    return content.substring(startIndex, endIndex + end.length);
  }

  @override
  void onClose() {
    scrollController.dispose();
    detailScrollController.dispose();
    super.onClose();
  }
}
