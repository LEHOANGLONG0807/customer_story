import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';

import 'controller.dart';
import 'widget/widget.dart';

class StoryBoardPage extends GetView<StoryBoardController> {
  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tủ truyện của bạn',style: _theme.textTheme.headline6!.textBlack,),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton(
          onPressed: controller.onTapHistoryStory,
          child: Text(
            'Lịch sử truyện đã đọc >',
            style: _theme.textTheme.headline6!.size(18),
          ),
        ),
        20.verticalSpace,
        Expanded(
          child: Obx(
            () => GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 0.5,
              padding: const EdgeInsets.only(bottom: 20),
              mainAxisSpacing: 25,
              crossAxisSpacing: 30,
              children: controller.listStory
                  .map(
                    (item) => ItemStoryBoard(model: item, onTap: () => controller.onTapStory(item.id)),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    ).paddingOnly(right: 20, left: 20);
  }
}
