import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../common/common.dart';
import '../../pages.dart';

class ContainerChapters extends StatelessWidget {
  final _theme = Get.theme;
  final _controller = Get.find<DetailStoryController>();
  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      key: _controller.dataKey,
      header: Container(
        height: 50.0,
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Danh sách chương', style: _theme.textTheme.headline6),
            _buildButtonSort(),
          ],
        ),
      ),
      content: Obx(
        () {
          final _models = _controller.chapterTitles;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng: ${_controller.storyModel.value.chap ?? 0} chương',
                style: _theme.textTheme.subtitle1!.regular.text595959,
              ),
              const Divider(),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) => _buildItemChapter(
                  title: _models[index].chapTitle ?? '',
                  onTap: () => _controller.onTapChapter(chapterId: _models[index].id),
                ),
                separatorBuilder: (_, index) => 10.verticalSpace,
                itemCount: _models.length,
              ),
            ],
          ).paddingSymmetric(horizontal: 20);
        },
      ),
    );
  }

  Widget _buildItemChapter({required String title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _theme.textTheme.subtitle1!.size(18).regular,
      ),
    );
  }

  Widget _buildButtonSort() {
    return InkWell(
      onTap: _controller.onTapSortChapters,
      child: Image.asset(
        (_controller.sortAZ.value ? 'ic_sort_1_9' : 'ic_sort_9_1').assetPathPNG,
        fit: BoxFit.cover,
        width: 20,
        height: 20,
      ),
    );
  }
}
