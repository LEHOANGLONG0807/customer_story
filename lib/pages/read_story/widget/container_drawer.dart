import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../../common/common.dart';

import '../../pages.dart';

class ContainerDrawer extends StatelessWidget {
  final _controller = Get.find<ReadStoryController>();
  ScrollController? _scrollController;
  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    if (_controller.reverseChapterList.value) {
      _scrollController = ScrollController(initialScrollOffset: _controller.chapterContentModel.value.id * 60 - Get.height / 2);
    } else {
      _scrollController =
          ScrollController(initialScrollOffset: (_controller.allChapters.length - _controller.chapterContentModel.value.id) * 60 - Get.height / 2);
    }
    return Container(
      width: double.infinity,
      color: _theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildContainerHeader(),
          const Divider(),
          Expanded(
            child: _buildListChapter(),
          ),
        ],
      ),
    );
  }

  Widget _buildListChapter() {
    return Obx(
      () => ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.only(left: 10),
        itemBuilder: (_, index) {
          final _chapterTitle = _controller.allChapters[index];
          final _idChapterSelected = _controller.chapterContentModel.value.id;
          return _buildItemChapter(
            title: _chapterTitle.chapTitle ?? '',
            isSelected: _chapterTitle.id == _idChapterSelected,
            onTap: () => _controller.onTapChooseChapter(_chapterTitle.id),
          );
        },
        itemCount: _controller.allChapters.length,
        separatorBuilder: (_, int index) => const Divider(height: 0),
      ).scrollBar(color: Colors.black, controller: _scrollController),
    );
  }

  Widget _buildItemChapter({required String title, bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 59,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _theme.textTheme.subtitle1!.textColor(isSelected ? AssetColors.primary : Colors.black).weight(isSelected ? FontWeight.bold : FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildContainerHeader() {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(10, 0, 5, 5),
      width: double.infinity,
      color: _theme.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(onPressed: Get.back, icon: const Icon(Icons.close, size: 26,color: Colors.white,)),
          _buildContainerStory(),
          const Spacer(),
          _buildTotalChapterAndSort(),
        ],
      ),
    );
  }

  Widget _buildContainerStory() {
    return InkWell(
      onTap: _controller.onTapDetailStory,
      child: Row(
        children: [
          _buildImage(),
          14.horizontalSpace,
          _buildContent(),
          10.horizontalSpace,
          const Icon(Icons.arrow_forward_ios,color: Colors.white,),
        ],
      ).wrapHeight(100),
    );
  }

  Widget _buildTotalChapterAndSort() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_controller.storyModel?.chap ?? 0} chương - ${(_controller.storyModel?.isFull ?? false) ? 'Hoàn thành' : 'Đang ra'}',
          style: _theme.textTheme.subtitle1!.regular.textWhite,
        ),
        InkWell(
          onTap: _controller.onTapSortChapter,
          child: Text(
            'Đảo thứ tự',
            style: _theme.textTheme.subtitle1!.textWhite,
          ),
        )
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      width: 70,
      height: 100,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: CachedImageNetworkWidget(
        url: _controller.storyModel?.thumbnail ?? '',
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          Text(
            _controller.storyModel?.title ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: _theme.textTheme.subtitle1!.textWhite.size(18).semiBold.heightLine(20),
          ),
          10.horizontalSpace,
          Text(
            _controller.storyModel?.authorName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _theme.textTheme.subtitle1!.regular.textWhite,
          ),
        ],
      ),
    );
  }
}
