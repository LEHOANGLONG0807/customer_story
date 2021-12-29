import 'package:flutter/material.dart';
import 'package:truyen_chu/pages/pages.dart';
import '../../../common/common.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../main.dart';

class TabBarTypeClassify extends StatefulWidget {
  final List<String> tabLabels;
  final List<Widget> pages;
  final TabController? tabController;

  TabBarTypeClassify({
    required this.tabLabels,
    required this.pages,
    this.tabController,
  });

  @override
  _TabBarTypeClassifyState createState() => _TabBarTypeClassifyState();
}

class _TabBarTypeClassifyState extends State<TabBarTypeClassify> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final _controller = Get.find<ClassifyController>();

  @override
  void initState() {
    super.initState();
    if (widget.tabController == null) {
      _tabController = TabController(length: widget.pages.length, vsync: this);
    }
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
        _buildTabBar(),
        const Divider(height: 0),
        Expanded(
          child: KeepAlivePage(child: _buildTabBarView()),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);
    return TabBar(
      controller: widget.tabController ?? _tabController,
      unselectedLabelStyle: theme.textTheme.subtitle1!.regular,
      unselectedLabelColor: theme.hintColor,
      labelStyle: theme.textTheme.subtitle1,
      labelColor: Colors.black,
      indicatorColor: theme.primaryColor,
      onTap: (val) async {
        if (val == 1) {
          _controller.feedBackStoryListen();
          await analytics.setUserProperty(name: LISTEN_STORY, value: '+1');
          await analytics.logEvent(name: EVENT_LISTEN);
        }
      },
      tabs: widget.tabLabels.map((e) => Tab(text: e)).toList(),
    ).paddingSymmetric(horizontal: 20);
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: widget.tabController ?? _tabController,
      children: widget.pages,
    );
  }
}
