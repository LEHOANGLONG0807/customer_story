import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:truyen_chu/common/common.dart';
import '../../main.dart';
import '../../services/services.dart';
import '../../biz/biz.dart';
import '../../constants.dart';
import '../../models/models.dart';
import '../../repository/repository.dart';
import '../../routes/routes.dart';
import '../pages.dart';

class HomeController extends GetxController {
  final StoryRepositoryImpl repository;

  final DBService dbService;

  HomeController({required this.repository, required this.dbService});

  AppController get appController => Get.find();

  final _box = GetStorage();

  Map<String, dynamic> _storyHots = {};

  Map<String, dynamic> _storyUpdated = {};

  Map<String, dynamic> _storyFulls = {};

  final listStoryHots = <StoryModel>[].obs;

  final listStoryUpdated = <StoryModel>[].obs;

  final listStoryFulls = <StoryModel>[].obs;

  final pageControllerHot = PageController(initialPage: 0);

  final pageControllerUpdated = PageController(initialPage: 0);

  final pageControllerFull = PageController(initialPage: 0);

  final tags = <TagModel>[];

  int tagIdHotSelected = 0;

  int tagIdUpdateSelected = 0;

  int tagIdFullSelected = 0;

  bool _isFirst = true;

  StoryHistoryLocalModel? storyHistory;

  final showPopupStoryLastTime = false.obs;

  late RewardedAd _rewardedAd;

  @override
  void onInit() {
    _loadRewardedAd();
    tags.addAll(appController.mainCategory);
    tags.insert(0, TagModel(id: 0, name: 'Tất cả'));
    super.onInit();
    _initLoad();
    _getLastStoryReading();
  }

  void _initLoad() async {
    try {
      await fetchStoryHots(isJump: false);
      await fetchStoryUpdated(isJump: false);
      await fetchStoryFulls(isJump: false);
    } catch (e) {
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  Future fetchStoryHots({bool isJump = true}) async {
    try {
      if (!_storyHots.keys.contains(tagIdHotSelected.toString())) {
        final _response = await repository.fetchStoryHotByTagId(tagId: tagIdHotSelected);
        _storyHots.addAll({'$tagIdHotSelected': _response});
      }
      if (isJump) {
        pageControllerHot.jumpToPage(0);
      }

      listStoryHots.value = _storyHots['$tagIdHotSelected'];
      listStoryHots.refresh();
      _addTheFistStoryBoard();
    } catch (e) {
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  Future fetchStoryUpdated({bool isJump = true}) async {
    try {
      if (!_storyUpdated.keys.contains(tagIdUpdateSelected.toString())) {
        final _response = await repository.fetchStoryUpdatedByTagId(tagId: tagIdUpdateSelected);
        _storyUpdated.addAll({'$tagIdUpdateSelected': _response});
      }
      if (isJump) pageControllerUpdated.jumpToPage(0);
      listStoryUpdated.value = _storyUpdated['$tagIdUpdateSelected'];
      listStoryUpdated.refresh();
    } catch (e) {
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  Future fetchStoryFulls({bool isJump = true}) async {
    try {
      if (!_storyFulls.keys.contains(tagIdFullSelected.toString())) {
        final _response = await repository.fetchStoryFullByTagId(tagId: tagIdFullSelected);
        _storyFulls.addAll({'$tagIdFullSelected': _response});
      }
      if (isJump) pageControllerFull.jumpToPage(0);
      listStoryFulls.value = _storyFulls['$tagIdFullSelected'];
      listStoryFulls.refresh();
    } catch (e) {
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  void onTapSeeMoreTagStory() {
    Get.find<MainController>().currentTabIndex.value = 1;
  }

  void onTapSearch() {
    Get.toNamed(Routes.SEARCH);
  }

  void onTapStory(int storyId) {
    Get.toNamed(Routes.DETAIL_STORY, arguments: {'id': storyId});
  }

  void onTapSeeMoreHot() {
    Get.toNamed(Routes.LIST_STORY, arguments: {
      'title': 'Truyện hot',
      'url': '/stories/hot/?tag_id=$tagIdHotSelected',
    });
  }

  void onTapSeeMoreFull() {
    Get.toNamed(Routes.LIST_STORY, arguments: {
      'title': 'Truyện full',
      'url': '/stories/full/?tag_id=$tagIdFullSelected',
    });
  }

  void onTapSeeMoreUpdate() {
    Get.toNamed(Routes.LIST_STORY, arguments: {
      'title': 'Truyện mới cập nhật',
      'url': '/stories/updated/?tag_id=$tagIdUpdateSelected',
    });
  }

  void feedBackStoryListen() {
    try {
      repository.feedbackStoryListen();
    } catch (e) {
      print(e);
    }
  }

  void onTapTagStory(TagModel model) async {
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

  void _addTheFistStoryBoard() async {
    if (!_isFirst) return;
    try {
      final _storyBoard = await dbService.getListStoryBoard();
      if (_storyBoard.isEmpty) {
        listStoryHots.value.sublist(0, 5).forEach((element) async {
          await dbService.addStoryBoard(model: element.toStoryBroadLocalModel);
        });
        appController.isRefreshStoryBoard.value = true;
        _isFirst = false;
      }
    } catch (e) {
      print(e);
    }
  }

  void onTapContinueReading() {
    _rewardedAd.show(onUserEarnedReward: (_, a) {});
    Get.toNamed(Routes.READING_STORY, arguments: {
      'storyId': storyHistory!.id,
      'chapterId': storyHistory!.chapterId,
      'pageIndex': storyHistory!.pageIndex,
      'backDetail': true,
    });
    showPopupStoryLastTime.value = false;
  }

  void onTapPopupStoryLastTime() {
    Get.toNamed(Routes.DETAIL_STORY, arguments: {'id': storyHistory!.id});
    showPopupStoryLastTime.value = false;
  }

  void onTapCloseStoryLastTime() {
    showPopupStoryLastTime.value = false;
  }

  void _getLastStoryReading() async {
    final _json = await _box.read(LAST_STORY_READING);
    if (_json != null && _json is String) {
      storyHistory = StoryHistoryLocalModel.fromJson(jsonDecode(_json));
      showPopupStoryLastTime.value = true;
    }
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }
}
