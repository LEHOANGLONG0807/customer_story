import 'package:flutter/material.dart';
import '../../list_story/widget/widget.dart';
import 'package:get/get.dart';

import '../controller.dart';
import 'widget.dart';

class ContainerSearchResult extends StatelessWidget {
  final _controller = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    return TitleAndWidgetSearch(
      title: 'Kết quả tìm kiếm',
      paddingTitle: 20,
      child: Expanded(
        child: Obx(
          () => ListView.separated(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            itemBuilder: (_, index) {
              if (index == _controller.resultSearch.length - 3 && _controller.isLoadMore) {
                _controller.searchStory();
              }
              return ItemStoryInList(
                model: _controller.resultSearch[index],
                onTap: () => _controller.onTapStory(_controller.resultSearch[index].id),
              );
            },
            separatorBuilder: (_, index) => const Divider(height: 30),
            itemCount: _controller.resultSearch.length,
          ),
        ),
      ),
    );
  }
}
