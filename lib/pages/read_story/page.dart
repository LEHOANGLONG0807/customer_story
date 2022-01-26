import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../common/common.dart';
import 'widget/widget.dart';

import 'controller.dart';

class ReadStoryPage extends GetView<ReadStoryController> {
  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onBack,
      child: Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: Colors.white,
        body: Obx(() {
          final _index = controller.currentIndexPage.value;
          return Stack(
            children: [
              SafeArea(
                child: InkWell(
                  onTap: controller.onTapScreen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _index == 1 ? '' : controller.chapterContentModel.value.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _theme.textTheme.subtitle1!.textBlack,
                      ).wrapHeight(25),
                      _buildContainerRead(),
                      if (!controller.showAction.value && controller.appController.showAds)
                        Container(
                          width: double.infinity,
                          height: controller.bannerAd.size.height.toDouble(),
                          child: AdWidget(ad: controller.bannerAd),
                        ),
                      if (!controller.showAction.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$_index/${controller.splitTextList.length}'),
                            ContainerBattery(),
                          ],
                        ).wrapHeight(20).paddingSymmetric(horizontal: 10),
                    ],
                  ).paddingAll(10),
                ),
              ),
              _buildAppBar(),
            ],
          );
        }),
        drawer: Drawer(
          child: ContainerDrawer(),
        ).wrapWidth(Get.width * 0.9),
        bottomNavigationBar: ContainerBottomReadAction(),
      ),
    );
  }

  Widget _buildContainerRead() {
    return Expanded(
      child: Container(
        key: controller.pageKey,
        child: NotificationListener<ScrollNotification>(
          onNotification: controller.listenScrollVerticalChangedChapter,
          child: ScrollablePositionedList.builder(
            itemCount: controller.splitTextList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final _text = controller.splitTextList[index];
              if (index == 0) {
                return Column(
                  children: [
                    if (controller.appController.showAds)
                      Container(
                        width: controller.appController.bannerAdMedium.size.width.toDouble(),
                        height: controller.appController.bannerAdMedium.size.height.toDouble(),
                        child: AdWidget(
                          ad: controller.appController.bannerAdMedium,
                        ),
                      ),
                    Text(
                      _text,
                      textAlign: TextAlign.center,
                      style: _theme.textTheme.headline5!.textBlack,
                    ),
                  ],
                );
              }
              if (index == controller.splitTextList.length - 1) {
                return Column(
                  children: [
                    Text(
                      _text,
                      style: controller.textStyle.value.textBlack,
                    ),
                    if (controller.appController.showAds)
                      Container(
                        width: controller.appController.bannerAdMedium2.size.width.toDouble(),
                        height: controller.appController.bannerAdMedium2.size.height.toDouble(),
                        child: AdWidget(
                          ad: controller.appController.bannerAdMedium2,
                        ),
                      ),
                  ],
                );
              }
              return Text(
                _text,
                style: controller.textStyle.value.textBlack,
              );
            },
            itemScrollController: controller.itemScrollController,
            itemPositionsListener: controller.itemPositionsListener,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AnimatedContainer(
      duration: 250.milliseconds,
      width: double.infinity,
      height: controller.showAction.value ? 80 : 0,
      color: AssetColors.colorGreyE7E7E7,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (controller.showAction.value)
            BackButton(
              onPressed: controller.onBack,
            )
          else
            UIHelper.emptyBox,
          Obx(
            () => controller.showButtonAddBoard.value
                ? TextButton(
                    onPressed: controller.onTapAddStoryBoard,
                    child: Row(
                      children: [
                        Text(
                          'Thêm vào tủ truyện',
                          style: _theme.textTheme.subtitle1!.text434343,
                        ),
                        5.horizontalSpace,
                        Image.asset(
                          'ic_add_book'.assetPathPNG,
                          width: 26,
                        )
                      ],
                    ),
                  )
                : UIHelper.emptyBox,
          ),
        ],
      ),
    );
  }
}
