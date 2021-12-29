import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';
import '../../../theme/theme.dart';

import '../controller.dart';

class ListProposeStoryRead extends StatelessWidget {
  final _controller = Get.find<ClassifyController>();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        padding: const EdgeInsets.only(bottom: 20),
        mainAxisSpacing: 12,
        crossAxisSpacing: 20,
        children: _controller.suggestTags.asMap().keys.map((index) {
          final _title = _controller.suggestTags[index].name!;
          final _index = index % AssetColors.colorRandom.length;
          final _color = AssetColors.colorRandom[_index];
          return ItemTagStory(title: _title, color: _color, onTap: () => _controller.onTapItemTag(_controller.suggestTags[index]));
        }).toList());
  }
}
