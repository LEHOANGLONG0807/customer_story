import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../common/common.dart';

import 'controller.dart';
import 'widget/widget.dart';

class StoryBoardPage extends GetView<StoryBoardController> {
  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.colorBlueF2F4FF,
      appBar: AppBar(
        title: Text(
          'Tủ truyện',
          style: _theme.textTheme.headline6!.textWhite,
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Obx(
      () => GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        padding: const EdgeInsets.only(bottom: 20),
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        children: controller.listStory
            .map(
              (item) => ItemStoryBoard(model: item, onTap: () => controller.onTapStory(item.id)),
            )
            .toList(),
      ),
    ).paddingOnly(right: 20, left: 20, top: 20);
  }
}
