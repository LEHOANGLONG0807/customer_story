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
          child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.search,
            readOnly: true,
            onTap: controller.onTapSearch,
            decoration: InputDecoration(
              fillColor: AssetColors.colorGreyE7E7E7,
              hintText: 'Nhập tên truyện',
              contentPadding: EdgeInsets.symmetric(vertical: 1),
              prefixIcon: const Icon(
                Icons.search,
                size: 24,
                color: AssetColors.colorGrey262626,
              ),
            ),
          ).paddingSymmetric(horizontal: 20),
          20.verticalSpace,
          Expanded(child: _buildContainerStoryRead().paddingSymmetric(horizontal: 10)),
        ],
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
                _buildTagStory(),
                const Divider(height: 50),
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
                const Divider(height: 50),
                GroupStoryByTypeWidget(
                  title: 'Mới cập nhật',
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
                const Divider(height: 50),
                GroupStoryByTypeWidget(
                  title: 'Đã hoàn thành',
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
      child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 3.5,
          padding: const EdgeInsets.only(bottom: 20),
          mainAxisSpacing: 12,
          crossAxisSpacing: 20,
          children: _list.asMap().keys.map((index) {
            final _title = _list[index].name ?? '';
            final _index = index % AssetColors.colorRandom.length;
            final _color = AssetColors.colorRandom[_index];
            return ItemTagStory(
                title: _title,
                color: _color,
                onTap: () => controller.onTapTagStory(_list[index]));
          }).toList())
    );
  }
}
