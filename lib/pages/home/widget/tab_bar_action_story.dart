import 'package:flutter/material.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../../common/common.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../controller.dart';

class TabBarTypeActionStory extends StatefulWidget {
  final List<String> tabLabels;
  final List<Widget> pages;

  TabBarTypeActionStory({
    required this.tabLabels,
    required this.pages,
  });

  @override
  _TabBarTypeActionStoryState createState() => _TabBarTypeActionStoryState();
}

class _TabBarTypeActionStoryState extends State<TabBarTypeActionStory> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final _controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.pages.length, vsync: this);
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
        const Divider(height: 0, indent: 20, endIndent: 80),
        20.verticalSpace,
        Expanded(
          child: KeepAlivePage(child: _buildTabBarView()),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TabBar(
            controller: _tabController,
            unselectedLabelStyle: theme.textTheme.subtitle1!.size(16),
            unselectedLabelColor: AssetColors.colorGrey595959,
            labelStyle: theme.textTheme.headline6,
            labelPadding: EdgeInsets.zero,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: theme.primaryColor,
            onTap: (val) async {
              if (val == 1) {
                _controller.feedBackStoryListen();
                await analytics.setUserProperty(name: LISTEN_STORY, value: '+1');
                await analytics.logEvent(name: EVENT_LISTEN);
              }
            },
            tabs: widget.tabLabels.map((e) => Tab(text: e)).toList(),
          ),
        ),
        10.horizontalSpace,
        InkWell(
          onTap: _controller.onTapSearch,
          child: const Icon(
            Icons.search,
            size: 30,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: widget.pages,
    );
  }
}
