import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:truyen_chu/pages/history_reading/controller.dart';
import 'package:wakelock/wakelock.dart';
import '../../biz/biz.dart';
import '../../main.dart';
import '../../routes/routes.dart';
import '../../common/common.dart';
import '../../constants.dart';
import '../../models/models.dart';
import 'widget/widget.dart';
import '../../repository/repository.dart';
import '../../services/services.dart';

import 'setting_read_page.dart';

class ReadStoryController extends GetxController {
  ChapterRepositoryImpl get chapterRepository => Get.find();

  StoryRepositoryImpl get storyRepository => Get.find();

  DBService get dbService => Get.find();

  AppController get appController => Get.find();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _box = GetStorage();

  final _splitText = SplitTextImpl();

  final _dynamicSize = DynamicSizeImpl();

  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  final pageKey = GlobalKey();

  final currentIndexPage = 0.obs;

  final textStyle = TextStyle(color: Colors.black, fontSize: 22).obs;

  final showAction = false.obs;

  final reverseChapterList = true.obs;

  final _splitTextList = <String>[].obs;

  List<String> get splitTextList => _splitTextList;

  int storyId = -1;

  int chapterId = -1;

  int _initPageIndex = 0;

  int _currentPageChapter = 1;

  bool _firstTimeLoad = true;

  bool _backDetail = false;

  final chapterContentModel = ChapterContentModel(id: -1).obs;

  StoryModel? storyModel;

  final allChapters = <ChapterTitleModel>[].obs;

  final storyHistoryLocal = StoryHistoryLocalModel(id: -1, chapterId: -1, pageIndex: 1);

  bool _isSaveHistory = false;

  bool _isNextChapter = true, _isPreChapter = true;

  final showButtonAddBoard = true.obs;

  bool _isLoading = false;

  Size? _size;

  @override
  void onInit() async {
    _loadRewardedAd();
    Wakelock.enable();
    if (Get.arguments != null) {
      storyId = Get.arguments['storyId'] ?? -1;

      chapterId = Get.arguments['chapterId'] ?? -1;
      _initPageIndex = (Get.arguments['pageIndex'] ?? 1) - 1;
      _backDetail = Get.arguments['backDetail'] ?? false;
    }
    super.onInit();
    analytics.setCurrentScreen(screenName: Routes.READING_STORY);
    bannerAd.load();

    /// l???y fontSize t??? local
    final _fontSize = await _box.read(KEY_FONT_SIZE);
    if (_fontSize != null && _fontSize is double) {
      textStyle.value = textStyle.value.copyWith(fontSize: _fontSize);
      textStyle.refresh();
    }

    /// ki???m tra local
    await _checkStoryHistoryLocal();

    _checkStoryBoardLocal();

    _positionsListener();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _size = _dynamicSize.getSize(pageKey);
      fetchChapterContentById();
    });

    _fetchAllChapterTitle();

    _fetchStoryById();

    await analytics.setUserProperty(name: READ_STORY, value: '$storyId');
    await analytics.logEvent(name: EVENT_READ, parameters: {'id': storyId});
  }

  /// get content truy???n

  Future fetchChapterContentById() async {
    try {
      EasyLoading.show();
      if (appController.showAds) {
        appController.bannerAdMedium.dispose();
        appController.bannerAdMedium.load();
        appController.bannerAdMedium2.dispose();
        appController.bannerAdMedium2.load();
      }
      final _response =
          await chapterRepository.fetchChapterContentById(chapterId: chapterId, storyId: storyId);
      chapterContentModel.value = _response;
      storyHistoryLocal.chapterId = chapterId;

      await _initLoad();
      _saveCurrentStoryReading();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('???? x???y ra l???i!');
    }
    if (chapterId % 10 == 0 && appController.showAds) {
      _rewardedAd.show(onUserEarnedReward: (_, a) {});
    }
  }

  /// x??? l?? pageview
  Future _initLoad() async {
    _getSplitText();
    currentIndexPage.value = _firstTimeLoad ? _initPageIndex + 1 : 1;
    try {
      await Future.delayed(300.milliseconds);
      itemScrollController.jumpTo(index: _firstTimeLoad ? _initPageIndex : 0);
    } catch (e) {
      itemScrollController.scrollTo(
          index: _firstTimeLoad ? _initPageIndex - 1 : 0,
          duration: 150.milliseconds,
          curve: Curves.linear);
    }

    _firstTimeLoad = false;
  }

  /// l???y to??n b??? ch????ng

  void _fetchAllChapterTitle() async {
    try {
      final _response = await chapterRepository.fetchChapterTitleById(
          storyId: storyId, page: _currentPageChapter);
      final _list = _response.items;
      if (_list.length >= 50 && _currentPageChapter < _response.totalPages) {
        _currentPageChapter++;
        await Future.delayed(200.milliseconds);
        _fetchAllChapterTitle();
      }
      allChapters.addAll(_list);
    } catch (e) {
      EasyLoading.showError('???? x???y ra l???i!');
    }
  }

  ///l???y th??ng tin truy???n

  void _fetchStoryById() async {
    try {
      final _response = await storyRepository.getStoryById(id: storyId);
      storyModel = _response;
      storyHistoryLocal.id = storyId;
      storyHistoryLocal.chap = storyModel!.chap ?? 0;
      storyHistoryLocal.thumbnail = storyModel!.thumbnail ?? '';
      storyHistoryLocal.title = storyModel!.title ?? '';
      storyHistoryLocal.authorName = storyModel!.authorName ?? '';
      _saveCurrentStoryReading();
    } catch (e) {
      EasyLoading.showError('???? x???y ra l???i!');
    }
  }

  /// ki???m tra xem truy???n ???? l??u ??? db history
  Future _checkStoryHistoryLocal() async {
    final _story = await dbService.getStoryHistoryById(storyId: storyId);
    if (_story != null) {
      _isSaveHistory = true;
    }
  }

  /// ki???m tra xem truy???n ???? l??u ??? db board
  void _checkStoryBoardLocal() async {
    final _storyBoard = await dbService.getStoryBoardById(storyId: storyId);
    if (_storyBoard != null) {
      showButtonAddBoard.value = false;
    }
  }

  ///th??m v??o t??? truy???n

  void onTapAddStoryBoard() async {
    try {
      EasyLoading.show();
      final _boardLocalModel = storyModel!.toStoryBroadLocalModel;
      final _response = await dbService.addStoryBoard(model: _boardLocalModel);
      EasyLoading.dismiss();
      if (_response) {
        showSnackBarSuccess(message: 'Th??m v??o t??? truy???n th??nh c??ng!');
        showButtonAddBoard.value = false;
        appController.isRefreshStoryBoard.value = true;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('???? x???y ra l???i!');
    }
  }

  ///l??u setting

  void onSaveSettingFontSize({required double fontSize}) {
    textStyle.value = textStyle.value.copyWith(fontSize: fontSize);
    textStyle.refresh();
    _getSplitText();
    Get.back();
    _box.write(KEY_FONT_SIZE, fontSize);
  }

  void onSaveSettingScrollDirectionStory({required bool readHorizontal}) async {
    appController.writeScrollDirectionStory(isHorizontal: readHorizontal);
  }

  /// navigator qua detail truy???n

  void onTapDetailStory() {
    Get.close(2);
    if (_backDetail) {
      Get.toNamed(Routes.DETAIL_STORY, arguments: {'id': storyId});
    }
  }

  ///b???m tr??? v??? ch????ng tr?????c

  void onTapChapterPre() {
    if (chapterId == 1) {
      Get.dialog(DialogChangeChapter(
          message: 'B???n ??ang ??? ch????ng ?????u ti??n'
              '\n N??n kh??ng th??? tr??? v??? "Ch????ng tr?????c"!'));
      return;
    }
    onTapChooseChapter(chapterId - 1);
  }

  /// chuy???n ch????ng k??? ti???p

  void onTapChapterNext() async {
    Future.delayed(3.seconds, () {
      _isNextChapter = true;
    });
    Future.delayed(1.seconds, () {
      _isLoading = false;
    });
    if (chapterId == allChapters.last.id) {
      Get.dialog(DialogChangeChapter(
          message: 'B???n ??ang ??? ch????ng cu???i c??ng'
              '\n N??n kh??ng th??? chuy???n qua "Ch????ng sau"!'));
      return;
    }
    await onTapChooseChapter(chapterId + 1);
    currentIndexPage.value = 1;
  }

  ///vu???t qua tr??i tr??? v??? ch????ng tr?????c

  void _onTapSwipePreRead() async {
    Future.delayed(3.seconds, () {
      _isPreChapter = true;
    });
    if (chapterId == 1) {
      Get.dialog(DialogChangeChapter(
          message: 'B???n ??ang ??? ch????ng ?????u ti??n'
              '\n N??n kh??ng th??? tr??? v??? "Ch????ng tr?????c"!'));
      return;
    }
    await onTapChooseChapter(chapterId - 1);
  }

  ///ch???n ch????ng
  Future onTapChooseChapter(int id) async {
    showAction.value = false;
    chapterId = id;
    if (scaffoldKey.currentState!.isDrawerOpen) Get.back();
    await fetchChapterContentById();
  }

  void onTapListChapter() {
    scaffoldKey.currentState!.openDrawer();
  }


  /// sort truy???n

  void onTapSortChapter() {
    reverseChapterList.value = !reverseChapterList.value;
    if (reverseChapterList.value) {
      allChapters.sort((a, b) => a.id.compareTo(b.id));
    } else {
      allChapters.sort((a, b) => b.id.compareTo(a.id));
    }
    allChapters.refresh();
  }

  /// check back
  Future<bool> onBack() async {
    if (showButtonAddBoard.value) {
      Get.dialog(
        DialogQuestion(
          title: 'L??u v??o t??? truy???n',
          message: 'L??u v??o trong t??? truy???n c???a b???n\n????? ?????c ti???p l???n sau!',
          titleButtonOne: 'Kh??ng',
          titleButtonTwo: 'L??u',
          functionOne: Get.back,
          functionTwo: () {
            onTapAddStoryBoard();
            Get.back();
          },
        ),
      );
    } else {
      Get.back();
    }
    return true;
  }

  void onTapScreen() {
    showAction.value = !showAction.value;
  }

  ///listen position

  void _positionsListener() {
    itemPositionsListener.itemPositions.addListener(() {
      if (_isLoading || showAction.value) return;
      if (appController.readHorizontal.value) return;
      final _pages = itemPositionsListener.itemPositions.value.toList();
      int _index = _pages.first.index;
      if (_pages.last.index == splitTextList.length - 1) {
        _index = _pages.last.index;
      }
      currentIndexPage.value = 1 + _index;
      storyHistoryLocal.pageIndex = currentIndexPage.value;

      _saveCurrentStoryReading();
    });
  }

  bool listenScrollVerticalChangedChapter(ScrollNotification scroll) {
    if (!appController.readHorizontal.value) {
      showAction.value = false;

      if (scroll.metrics.pixels - 60 > scroll.metrics.maxScrollExtent && _isNextChapter) {
        _isNextChapter = false;
        _isLoading = true;
        onTapChapterNext();
      }
      if (scroll.metrics.pixels < scroll.metrics.minScrollExtent - 60 && _isPreChapter) {
        _isPreChapter = false;
        _onTapSwipePreRead();
      }
    }

    return false;
  }

  void _getSplitText() {
    ///chia text
    final _content = _replaceString(chapterContentModel.value.content ?? '');
    _dynamicSize.getSize(scaffoldKey);
    _splitTextList.value = _splitText.getSplitText(_size!, textStyle.value, _content);
    _splitTextList.insert(0, (chapterContentModel.value.title ?? '').replaceFirst(':', ':\n'));
    _splitTextList.refresh();
  }

  void _saveCurrentStoryReading() {
    ///l??u local truy???n ??ang ?????c
    final _json = jsonEncode(storyHistoryLocal.toJson());
    _box.write(LAST_STORY_READING, _json);
    if (_isSaveHistory) {
      dbService.updateStoryHistory(model: storyHistoryLocal);
    } else {
      dbService.addStoryHistory(model: storyHistoryLocal);
      _isSaveHistory = true;
    }
  }

  String _replaceString(String content) {
    String htmlString = content;
    htmlString = htmlString.replaceAll("&#32;", " ");
    htmlString = htmlString.replaceAll("\n", " ");
    htmlString = htmlString.replaceAll("&#33;", "!");
    htmlString = htmlString.replaceAll("&#34;", "\"");
    htmlString = htmlString.replaceAll("&#35;", "#");
    htmlString = htmlString.replaceAll("&#36;", "\$");
    htmlString = htmlString.replaceAll("&#37;", "%");
    htmlString = htmlString.replaceAll("&#38;", "&");
    htmlString = htmlString.replaceAll("&#39;", "'");
    htmlString = htmlString.replaceAll("<br><br>", "\n");
    htmlString = htmlString.replaceAll("<br>", "\n");
    htmlString = htmlString.replaceAll("<br/><br/>", "\n");
    htmlString = htmlString.replaceAll("<br/>", "\n");
    htmlString = htmlString.replaceAll("<p><p>", "\n");
    htmlString = htmlString.replaceAll("<p>", "\n");
    htmlString = htmlString.replaceAll("<p/><p/>", "\n");
    htmlString = htmlString.replaceAll("<p/>", "\n");
    htmlString = htmlString.replaceAll(new RegExp("<.+?>"), "");
    return htmlString;
  }

  ///ads
  final bannerAd = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (_) {},
      onAdFailedToLoad: (ad, err) {
        ad.dispose();
      },
    ),
  );

  late RewardedAd _rewardedAd;

  // TODO: Implement _loadRewardedAd()
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

  @override
  void onClose() {
    Wakelock.disable();
    bannerAd.dispose();
    _rewardedAd.dispose();
    itemPositionsListener.itemPositions.removeListener(() {});
    super.onClose();
  }
}
