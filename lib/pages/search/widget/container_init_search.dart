import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../theme/theme.dart';
import 'package:get/get.dart';

import '../controller.dart';
import 'widget.dart';

class ContainerInitSearch extends StatelessWidget {
  final _controller = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //  _buildStoryHot(),
          _buildPopularStoryType(),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildStoryHot() {
    return TitleAndWidgetSearch(
      title: 'Truyện Hot',
      child: Obx(
        () => GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2.1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          children: _controller.storyHots
              .map(
                (item) => ItemStorySuggestSearch(
                  model: item,
                  onTap: () => _controller.onTapStory(item.id),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPopularStoryType() {
    final _list = _controller.appController.popularStoryTags;
    return TitleAndWidgetSearch(
      title: 'Thể loại truyện phổ biến',
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
                    onTap: () => _controller.onTapTypeStory(_list[index]));
              }).toList())
          .fullWidth,
    );
  }
}
