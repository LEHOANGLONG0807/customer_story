import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/common.dart';
import 'package:get/get.dart';
import '../../../theme/asset_colors.dart';

import 'widget.dart';

class TabViewStoryRead extends StatefulWidget {
  @override
  _TabViewStoryReadState createState() => _TabViewStoryReadState();
}

class _TabViewStoryReadState extends State<TabViewStoryRead> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final _currentIndex = 0.obs;

  final _listTitle = ['Thể loại', 'Danh sách đề xuất'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        20.verticalSpace,
        _buildTabBar(),
        20.verticalSpace,
        Expanded(
          child: KeepAlivePage(child: _buildTabBarView()),
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);
    return Obx(
      () => TabBar(
        controller: _tabController,
        unselectedLabelStyle: theme.textTheme.subtitle1!.regular,
        unselectedLabelColor: theme.hintColor,
        labelStyle: theme.textTheme.subtitle1,
        labelColor: Colors.black,
        isScrollable: true,
        labelPadding: EdgeInsets.only(right: 10),
        tabs: _listTitle.asMap().keys.map((index) {
          final _isFocus = index == _currentIndex.value;
          return Container(
            height: 47,
            padding: UIHelper.horizontalEdgeInsets20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: _isFocus ? theme.primaryColor : AssetColors.colorGreyE7E7E7,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _listTitle[index],
                  style: theme.textTheme.subtitle1!.weight(_isFocus ? FontWeight.bold : FontWeight.normal),
                ),
              ],
            ),
          );
        }).toList(),
        onTap: (index) => _currentIndex.value = index,
        indicator: const BoxDecoration(),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        KeepAlivePage(child: ListCategoryStoryRead()),
        KeepAlivePage(child: ListProposeStoryRead()),
      ],
    );
  }
}
