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
    return TabBar(
      controller: _tabController,
      unselectedLabelStyle: theme.textTheme.subtitle1!.regular,
      unselectedLabelColor: theme.hintColor,
      labelStyle: theme.textTheme.subtitle1,
      labelColor: Colors.black,
      labelPadding: EdgeInsets.only(right: 10),
      tabs: _listTitle.map((item) {
        return Tab(text: item);
      }).toList(),
      onTap: (index) => _currentIndex.value = index,
      indicatorColor: AssetColors.primary,
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
