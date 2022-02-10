import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../common/common.dart';

import 'controller.dart';
import 'widget/widget.dart';

class ListStoryPage extends GetView<ListStoryController> {
  final _textTheme=Get.textTheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.colorBlueF2F4FF,
      appBar: AppBar(
        title: Obx(
          () => Text(controller.title.value,style: _textTheme.headline6!.textWhite,),
        ),
      ),
      body: Obx(
        () => ListView.separated(
          padding: UIHelper.verticalEdgeInsets20,
          itemBuilder: (_, index) {
            if (index == controller.listStory.length - 3 && controller.isLoadMore) {
              controller.fetchStores();
            }
            return ItemStoryInList(model: controller.listStory[index], onTap: () => controller.onTapStory(controller.listStory[index].id));
          },
          separatorBuilder: (_, index) => 20.verticalSpace,
          itemCount: controller.listStory.length,
        ),
      ),
    );
  }
}
