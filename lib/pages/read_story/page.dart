import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: const Color(0xffDED9C5),
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
                        style: _theme.textTheme.subtitle1!.text3F2F0E,
                      ).wrapHeight(25),
                      _buildContainerRead(),
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
                        ).wrapHeight(20),
                    ],
                  ).paddingOnly(top: 10, right: 20, left: 20, bottom: 10),
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
          child: IndexedStack(
            index: controller.appController.readHorizontal.value ? 0 : 1,
            children: [
              ///scroll horizontal
              Visibility(
                maintainState: true,
                visible: controller.appController.readHorizontal.value,
                child: PageView.builder(
                  controller: controller.pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.splitTextList.length,
                  itemBuilder: (context, index) {
                    final _text = controller.splitTextList[index];
                    if (index == 0) {
                      return Center(
                        child: Text(
                          _text,
                          textAlign: TextAlign.center,
                          style: _theme.textTheme.headline5!.text3F2F0E,
                        ),
                      );
                    }
                    return Text(
                      _text,
                      style: controller.textStyle.value.text3F2F0E,
                    );
                  },
                ),
              ),

              /// scroll vertical
              Visibility(
                maintainState: true,
                visible: !controller.appController.readHorizontal.value,
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
                            Container(
                              width: controller.bannerAdMedium.size.width.toDouble(),
                              height: controller.bannerAdMedium.size.height.toDouble(),
                              child: AdWidget(
                                ad: controller.bannerAdMedium,
                              ),
                            ),
                            Text(
                              _text,
                              textAlign: TextAlign.center,
                              style: _theme.textTheme.headline5!.text3F2F0E,
                            ),
                          ],
                        );
                      }
                      if (index == controller.splitTextList.length - 1) {
                        return Column(
                          children: [
                            Text(
                              _text,
                              style: controller.textStyle.value.text3F2F0E,
                            ),
                            Container(
                              width: controller.bannerAdMedium2.size.width.toDouble(),
                              height: controller.bannerAdMedium2.size.height.toDouble(),
                              child: AdWidget(
                                ad: controller.bannerAdMedium2,
                              ),
                            ),
                          ],
                        );
                      }
                      return Text(
                        _text,
                        style: controller.textStyle.value.text3F2F0E,
                      );
                    },
                    itemScrollController: controller.itemScrollController,
                    itemPositionsListener: controller.itemPositionsListener,
                  ),
                ),
              ),

              ///scroll vertical
//              SingleChildScrollView(
//                controller: controller.scrollController,
//                physics: const BouncingScrollPhysics(),
//                child: Column(
//                  children: [
//                    Center(
//                      child: Text(
//                        (controller.chapterContentModel.value.title ?? '').replaceFirst(':', ':\n'),
//                        textAlign: TextAlign.center,
//                        style: _theme.textTheme.headline5!.text3F2F0E,
//                      ),
//                    ),
//                    ...controller.splitTextList.map((e) {
//                      return Text(
//                        e,
//                        style: controller.textStyle.value.text3F2F0E,
//                      );
//                    }),
//                  ],
//                ),
//              ),
            ],
          )),
    );
  }

  Widget _buildAppBar() {
    return AnimatedContainer(
      duration: 250.milliseconds,
      width: double.infinity,
      height: controller.showAction.value ? 80 : 0,
      color: const Color(0xffD2CDB9),
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
