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
  final ChapterRepositoryImpl chapterRepository;

  final StoryRepositoryImpl storyRepository;

  final DBService dbService;

  ReadStoryController(
      {required this.chapterRepository, required this.storyRepository, required this.dbService});

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

    /// lấy fontSize từ local
    final _fontSize = await _box.read(KEY_FONT_SIZE);
    if (_fontSize != null && _fontSize is double) {
      textStyle.value = textStyle.value.copyWith(fontSize: _fontSize);
      textStyle.refresh();
    }

    /// kiểm tra local
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

  /// get content truyện

  Future fetchChapterContentById() async {
    try {
      EasyLoading.show();
      appController.bannerAdMedium.dispose();
      appController.bannerAdMedium.load();
      appController.bannerAdMedium2.dispose();
      appController.bannerAdMedium2.load();
      final _response =
          await chapterRepository.fetchChapterContentById(chapterId: chapterId, storyId: storyId);
      chapterContentModel.value = _response;
      storyHistoryLocal.chapterId = chapterId;

      await _initLoad();
      _saveCurrentStoryReading();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
    if (chapterId % 10 == 0 && appController.showAds) {
      _rewardedAd.show(onUserEarnedReward: (_, a) {});
    }
  }

  /// xử lý pageview
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

  /// lấy toàn bộ chương

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
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  ///lấy thông tin truyện

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
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  /// kiểm tra xem truyện đã lưu ở db history
  Future _checkStoryHistoryLocal() async {
    final _story = await dbService.getStoryHistoryById(storyId: storyId);
    if (_story != null) {
      _isSaveHistory = true;
    }
  }

  /// kiểm tra xem truyện đã lưu ở db board
  void _checkStoryBoardLocal() async {
    final _storyBoard = await dbService.getStoryBoardById(storyId: storyId);
    if (_storyBoard != null) {
      showButtonAddBoard.value = false;
    }
  }

  ///thêm vào tủ truyện

  void onTapAddStoryBoard() async {
    try {
      EasyLoading.show();
      final _boardLocalModel = storyModel!.toStoryBroadLocalModel;
      final _response = await dbService.addStoryBoard(model: _boardLocalModel);
      if (_response) {
        showSnackBarSuccess(message: 'Thêm vào tủ truyện thành công!');
        showButtonAddBoard.value = false;
        appController.isRefreshStoryBoard.value = true;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Đã xảy ra lỗi!');
    }
  }

  ///lưu setting

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

  /// navigator qua detail truyện

  void onTapDetailStory() {
    Get.close(2);
    if (_backDetail) {
      Get.toNamed(Routes.DETAIL_STORY, arguments: {'id': storyId});
    }
  }

  ///bấm trở về chương trước

  void onTapChapterPre() {
    if (chapterId == 1) {
      Get.dialog(DialogChangeChapter(
          message: 'Bạn đang ở chương đầu tiên'
              '\n Nên không thế trở về "Chương trước"!'));
      return;
    }
    onTapChooseChapter(chapterId - 1);
  }

  /// chuyển chương kế tiếp

  void onTapChapterNext() async {
    Future.delayed(3.seconds, () {
      _isNextChapter = true;
    });
    Future.delayed(1.seconds, () {
      _isLoading = false;
    });
    if (chapterId == allChapters.last.id) {
      Get.dialog(DialogChangeChapter(
          message: 'Bạn đang ở chương cuối cùng'
              '\n Nên không thế chuyển qua "Chương sau"!'));
      return;
    }
    await onTapChooseChapter(chapterId + 1);
    currentIndexPage.value = 1;
  }

  ///vuốt qua trái trở về chương trước

  void _onTapSwipePreRead() async {
    Future.delayed(3.seconds, () {
      _isPreChapter = true;
    });
    if (chapterId == 1) {
      Get.dialog(DialogChangeChapter(
          message: 'Bạn đang ở chương đầu tiên'
              '\n Nên không thế trở về "Chương trước"!'));
      return;
    }
    await onTapChooseChapter(chapterId - 1);
  }

  ///chọn chương
  Future onTapChooseChapter(int id) async {
    showAction.value = false;
    chapterId = id;
    if (scaffoldKey.currentState!.isDrawerOpen) Get.back();
    await fetchChapterContentById();
  }

  void onTapListChapter() {
    scaffoldKey.currentState!.openDrawer();
  }

  void onTapSetting() {
    Get.to(() => SettingReadPage());
//    itemScrollController.scrollTo(index: _firstTimeLoad ? _initPageIndex : 0, duration: 150.milliseconds, curve: Curves.linear);
  }

  /// sort truyện

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
          title: 'Lưu vào tủ truyện',
          message: 'Lưu vào trong tủ truyện của bạn\nđể đọc tiếp lần sau!',
          titleButtonOne: 'Không',
          titleButtonTwo: 'Lưu',
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
    ///lưu local truyện đang đọc
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
