import 'package:flutter/material.dart';
import '../../../common/common.dart';
import 'package:get/get.dart';
import '../../pages.dart';
import '../../../theme/theme.dart';

import '../controller.dart';

typedef TabChangedCallback = void Function(int tabIndex);

class CustomTabBarNotTabView extends StatefulWidget {
  final TabChangedCallback? onTabChanged;
  final double? paddingTabBar;

  CustomTabBarNotTabView({
    this.onTabChanged,
    this.paddingTabBar,
  });

  @override
  _CustomTabBarNotTabViewState createState() => _CustomTabBarNotTabViewState();
}

class _CustomTabBarNotTabViewState extends State<CustomTabBarNotTabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _index = 0.obs;

  final _controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _controller.tags.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _theme = Get.theme;

  Widget build(BuildContext context) {
    return Obx(() {
      return TabBar(
        controller: _tabController,
        unselectedLabelStyle: _theme.textTheme.subtitle2!.regular,
        unselectedLabelColor: _theme.hintColor,
        labelStyle: _theme.textTheme.subtitle2!.medium,
        indicatorWeight: 0,
        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
        labelColor: Colors.white,
        tabs: _controller.tags.asMap().keys.map((index) {
          final _title = _controller.tags[index].name ?? '';
          return Tab(child: _buildItemTabBar(title: _title, isFocus: _index.value == index));
        }).toList(),
        indicator: const BoxDecoration(),
        isScrollable: true,
        onTap: (val) {
          widget.onTabChanged?.call(_controller.tags[val].id);
          _index.value = val;
        },
      );
    });
  }

  Widget _buildItemTabBar({required String title, bool isFocus = false}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        color: isFocus ? _theme.primaryColor : Color(0xffF0F0F0),
      ),
      child: Text(
        title,
        style: _theme.textTheme.button!.medium.textColor(isFocus ? Colors.white : AssetColors.textBlack),
      ),
    );
  }
}
