import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../theme/theme.dart';
import 'package:get/get.dart';

import '../controller.dart';

class ListCategoryStoryRead extends StatelessWidget {
  final _controller = Get.find<ClassifyController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildMainCategory(),
             // _buildSubCategory(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainCategory() {
    final _models = _controller.mainCategory+_controller.subCategory;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3.5,
      padding: const EdgeInsets.only(bottom: 12),
      mainAxisSpacing: 12,
      crossAxisSpacing: 20,
      children: _models.asMap().keys.map((index) {
        final _index = index % AssetColors.colorRandom.length;
        final _color = AssetColors.colorRandom[_index];
        return ItemCategoryStory(
          model: _models[index],
          color: _color,
          onTap: () => _controller.onTapItemCategory(_models[index]),
        );
      }).toList(),
    );
  }

  Widget _buildSubCategory() {
    final _models = _controller.subCategory;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 2.3,
      padding: const EdgeInsets.only(bottom: 20),
      mainAxisSpacing: 12,
      crossAxisSpacing: 20,
      children: _models.map((item) {
        return ItemCategoryStory(
          model: item,
          showColor: false,
          onTap: () => _controller.onTapItemCategory(item),
        );
      }).toList(),
    );
  }
}
