import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import 'widget/widget.dart';
import '../../theme/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'controller.dart';

class HomePage extends GetView<HomeController> {
  final BannerAd _myBanner = BannerAd(
    size: AdSize.banner,
    adUnitId: '	ca-app-pub-3940256099942544/6300978111',
    listener: BannerAdListener(),
    request: AdRequest(),
  );

  @override
  Widget build(BuildContext context) {
    _myBanner.load();
    return Scaffold(
      backgroundColor: AssetColors.colorBlueF2F4FF,
      body: SafeArea(
        child: TabBarTypeActionStory(
          tabLabels: ['Đọc truyện',],
          pages: [KeepAlivePage(child: _buildContainerStoryRead())],
        ),
      ),
    );
  }

  Widget _buildContainerStoryRead() {
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GroupStoryByTypeWidget(
                  title: 'Truyện hot',
                  onTapSeeMore: controller.onTapSeeMoreHot,
                  child: ContainerStoryHome(
                    models: controller.listStoryHots.value,
                    pageController: controller.pageControllerHot,
                    callBack: (val) {
                      controller.tagIdHotSelected = val;
                      controller.fetchStoryHots();
                    },
                  ),
                ),
                20.verticalSpace,
                GroupStoryByTypeWidget(
                  title: 'Truyện mới cập nhật',
                  onTapSeeMore: controller.onTapSeeMoreUpdate,
                  child: ContainerStoryHome(
                    models: controller.listStoryUpdated.value,
                    pageController: controller.pageControllerUpdated,
                    callBack: (val) {
                      controller.tagIdUpdateSelected = val;
                      controller.fetchStoryUpdated();
                    },
                  ),
                ),
                20.verticalSpace,
                GroupStoryByTypeWidget(
                  title: 'Truyện đã hoàn thành',
                  onTapSeeMore: controller.onTapSeeMoreFull,
                  child: ContainerStoryHome(
                    models: controller.listStoryFulls.value,
                    pageController: controller.pageControllerFull,
                    callBack: (val) {
                      controller.tagIdFullSelected = val;
                      controller.fetchStoryFulls();
                    },
                  ),
                ),
                20.verticalSpace,
                _buildTagStory(),
                20.verticalSpace,
              ],
            ).paddingSymmetric(horizontal: 12),
          ),
          if (controller.showPopupStoryLastTime.value) PopUpStoryLastTime(),
        ],
      ),
    );
  }

  Widget _buildTagStory() {
    final _list = controller.appController.popularStoryTags;
    return GroupStoryByTypeWidget(
      title: 'Thẻ truyện',
      onTapSeeMore: controller.onTapSeeMoreTagStory,
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: _list.asMap().keys.map((index) {
          final _title = _list[index].name ?? '';
          final _index = index % AssetColors.colorRandom.length;
          final _color = AssetColors.colorRandom[_index];
          return ItemTagStory(
            title: _title,
            color: _color,
            onTap: () => controller.onTapTagStory(_list[index]),
          );
        }).toList(),
      ).fullWidth,
    );
  }
}
