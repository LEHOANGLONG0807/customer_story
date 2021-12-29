import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../models/models.dart';

import 'widget.dart';

class ContainerStoryHome extends StatelessWidget {
  final Function(int)? callBack;
  final List<StoryModel> models;
  final PageController pageController;

  ContainerStoryHome({required this.models, required this.pageController, this.callBack});

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
        if (models.isEmpty) UIHelper.emptyBox else PageViewStoryInGroup(models: models, pageController: pageController),
      ],
    );
  }
}
