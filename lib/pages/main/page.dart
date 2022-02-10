import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controller.dart';
import '../../common/common.dart';

class MainPage extends GetResponsiveView<MainController> {
  @override
  Widget phone() {
    final _theme = Get.theme;
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: controller.bottomNavBarItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Image.asset(item.icon.assetPathPNG, color: Colors.white, width: 24),
                  activeIcon: Image.asset(item.icon.assetPathPNG, color: Colors.white, width: 24),
                  label: item.label,
                ),
              )
              .toList(),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          backgroundColor: _theme.primaryColor,
          showUnselectedLabels: true,
          currentIndex: controller.currentTabIndex.value,
          onTap: controller.onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: _theme.textTheme.caption!.bold,
          unselectedLabelStyle: _theme.textTheme.caption!.regular,
        ),
        body: getCurrentWidget(),
      ),
    );
  }

  Widget getCurrentWidget() {
    return IndexedStack(
      index: controller.currentTabIndex.value,
      children: controller.bottomNavBarItems
          .asMap()
          .keys
          .map(
            (index) => Visibility(
              maintainState: true,
              visible: controller.currentTabIndex.value == index,
              child: controller.bottomNavBarItems[index].page,
            ).paddingOnly(),
          )
          .toList(),
    );
  }
}
