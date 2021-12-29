import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/models.dart';
import '../../pages.dart';
import '../../../theme/theme.dart';

import 'widget.dart';

// ignore: must_be_immutable
class PageViewStoryInGroup extends StatelessWidget {
  final List<StoryModel> models;
  final PageController pageController;

  PageViewStoryInGroup({required this.models, required this.pageController});

  final _currentIndexPage = 0.0.obs;

  final List<List<int>> _numberPage = [];

  final _controller = Get.find<HomeController>();

  void _initBuild() {
    _countPageView();
    pageController.addListener(() {
      _currentIndexPage.value = pageController.page!;
    });
  }

  @override
  Widget build(BuildContext context) {
    _initBuild();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: Get.width,
          child: PageView(
            controller: pageController,
            children: _numberPage.map((e) {
              return _buildGirdStory(e);
            }).toList(),
          ),
        ),
        _buildRowStep(),
      ],
    );
  }

  Widget _buildGirdStory(List<int> list) {
    return GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 75 / 180,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
        children: models.sublist(list[0], list[1]).map((item) {
          return ItemStoryHome(
            model: item,
            onTap: () => _controller.onTapStory(item.id),
          );
        }).toList());
  }

  Widget _buildRowStep() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _numberPage.asMap().keys.map((e) => _buildItemStep(isFocus: e < _currentIndexPage.value + 0.4 && e > _currentIndexPage.value - 0.6)).toList(),
      ),
    );
  }

  Widget _buildItemStep({bool isFocus = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: isFocus ? Colors.black : AssetColors.colorGreyB4B2B2),
    );
  }

  void _countPageView() {
    final _length = models.length;
    int _count = _length ~/ 8;
    if (_length % 8 > 0) {
      _count++;
    }
    for (int i = 0; i < _count; i++) {
      if (i == _count - 1) {
        _numberPage.add([i * 8, _length]);
      } else {
        _numberPage.add([i * 8, i * 8 + 8]);
      }
    }
  }
}
