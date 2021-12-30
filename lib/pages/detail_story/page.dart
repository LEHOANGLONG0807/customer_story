import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../theme/theme.dart';
import '../../common/common.dart';

import 'controller.dart';
import 'widget/widget.dart';

class DetailStoryPage extends GetView<DetailStoryController> {
  final _theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.backgroundColor.value,
        appBar: _buildAppBar(),
        body: SliverHeaderAppBar(
          buildHeader: _buildHeader(),
          bodyContent: _buildContent(),
        ),
        bottomNavigationBar: _buildButtonReading(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      title: Obx(() => controller.showTitle.value
          ? Text(
              controller.storyModel.value.title ?? '',
              maxLines: 1,
              style: _theme.textTheme.headline6!.textWhite,
            )
          : UIHelper.emptyBox),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      actions: [
        Obx(
          () => controller.showButtonAddBoard.value
              ? TextButton(
                  onPressed: controller.onTapAddStoryBoard,
                  child: controller.showTitle.value
                      ? Image.asset(
                          'ic_add_book'.assetPathPNG,
                          color: Colors.white,
                          width: 20,
                        )
                      : Text(
                          '+ Thêm vào tủ truyện',
                          style: TextStyle(color: Colors.white),
                        ),
                )
              : UIHelper.emptyBox,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final _model = controller.storyModel.value;
    return Container(
      height: 150,
      width: double.infinity,
      padding: UIHelper.horizontalEdgeInsets20,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _model.title ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.subtitle1!.textWhite.medium,
                ),
                const Spacer(),
                Row(
                  children: [
                    InkWell(
                      onTap: controller.onTapAuthorTitle,
                      child: Text(
                        '${_model.authorName ?? ''}',
                        style: _theme.textTheme.subtitle2!.textColor(AssetColors.colorGreyB4B2B2).regular,
                      ),
                    ).paddingOnly(bottom: 5),
                    5.horizontalSpace,
                    const Icon(Icons.arrow_forward_ios_outlined, color: Colors.white, size: 12)
                  ],
                ),
                10.verticalSpace,
                Text(
                  '${(_model.isFull ?? false) ? 'Hoàn thành' : 'Đang ra'} - Chương ${_model.chap ?? 0}',
                  style: _theme.textTheme.subtitle2!.textColor(AssetColors.colorGreyB4B2B2).regular,
                ),
              ],
            ).wrapHeight(130),
          ),
          20.horizontalSpace,
          Container(
            width: 100,
            height: 130,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: CachedImageNetworkWidget(
              url: _model.thumbnail ?? '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              controller.loadMoreChapters(scrollInfo);
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  _buildInfoStory(),
                  const Divider(thickness: 10),
                  ContainerChapters(),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
        ),
        _buildButtonScrollTop(),
      ],
    );
  }

  Widget _buildInfoStory() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoReview(),
            _buildCountView(),
          ],
        ),
        20.verticalSpace,
        Container(
          width: double.infinity,
          height: controller.bannerAdMedium.size.height.toDouble(),
          child: AdWidget(ad: controller.bannerAdMedium),
        ),
        20.verticalSpace,
        _buildIntroduce(),
        const Divider(height: 40),
        ContainerRating(),
        30.verticalSpace,
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Widget _buildIntroduce() {
    final _model = controller.storyModel.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giới thiệu',
          style: _theme.textTheme.subtitle1,
        ),
        10.verticalSpace,
        _buildDesc(),
        10.verticalSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (_model.listTag ?? [])
                .map(
                  (e) => Chip(
                    label: Text(e.name ?? ''),
                  ).wrapHeight(30).paddingOnly(right: 5),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoReview() {
    final _model = controller.storyModel.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${_model.star ?? 0}', style: _theme.textTheme.headline5!.textBlack),
            5.horizontalSpace,
            Icon(
              Icons.star,
              color: _theme.primaryColor,
            ),
          ],
        ),
        Text(
          '${_model.totalRate ?? 0} Lượt đánh giá',
          style: _theme.textTheme.caption,
        )
      ],
    );
  }

  Widget _buildCountView() {
    final _count = controller.storyModel.value.totalRead ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(_count > 1000 ? '${(_count / 1000).toStringAsFixed(1)}K' : _count.toString(), style: _theme.textTheme.headline5!.textBlack),
        Text('Lượt đọc', style: _theme.textTheme.caption),
      ],
    );
  }

  Widget _buildButtonReading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 70 + MediaQuery.of(Get.context!).padding.bottom,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(child: Text('Nghe truyện').elevatedButton(onPressed: null)),
          20.horizontalSpace,
          Expanded(child: Text('Đọc truyện').elevatedButton(onPressed: controller.onTapReadingStory)),
        ],
      ),
    );
  }

  Widget _buildButtonScrollTop() {
    return Obx(
      () => controller.showButtonScrollTop.value
          ? Positioned(
              right: 30,
              bottom: 100,
              child: InkWell(
                onTap: controller.onTapButtonScrollTop,
                child: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: _theme.primaryColor),
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : UIHelper.emptyBox,
    );
  }

  Widget _buildDesc() {
    final _model = controller.storyModel.value;
    final _isExpanded = false.obs;
    return Obx(
      () => AnimatedContainer(
        duration: 500.milliseconds,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HtmlView(
              htmlData: controller.replaceHtmlData(_model.desc ?? '', _isExpanded.value ? 5000 : 300),
              textStyle: _theme.textTheme.subtitle2!.regular.heightLine(18),
            ).fullWidth,
            IconButton(
              onPressed: () => _isExpanded.value = !_isExpanded.value,
              icon: Image.asset((_isExpanded.value ? 'ic_desc_down' : 'ic_desc_drop').assetPathPNG),
            )
          ],
        ),
      ),
    );
  }
}
