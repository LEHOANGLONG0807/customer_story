import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';
import '../../../models/models.dart';

import '../controller.dart';
import 'widget.dart';

class ContainerStoryHome extends StatelessWidget {
  final Function(int)? callBack;
  final List<StoryModel> models;
  final PageController pageController;

  ContainerStoryHome({required this.models, required this.pageController, this.callBack});
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTabBarNotTabView(
          onTabChanged: callBack,
        ),
        20.verticalSpace,
        if (models.isEmpty) UIHelper.emptyBox else GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 75 / 150,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            mainAxisSpacing: 10,
            crossAxisSpacing: 6,
            children: (models.length>8?models.sublist(0,8):models).map((item) {
              return ItemStoryHome(
                model: item,
               onTap: () => _controller.onTapStory(item.id),
              );
            }).toList()),
      ],
    );
  }
}
