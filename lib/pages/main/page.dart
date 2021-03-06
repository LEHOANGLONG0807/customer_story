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
          items: controller.bottomNavBarItems.asMap().keys.map((index) {
            final item = controller.bottomNavBarItems[index];
            return BottomNavigationBarItem(
                icon: Image.asset(item.icon.assetPathPNG, color: Colors.white, width: 20),
                activeIcon: Image.asset(item.icon.assetPathPNG, color: Colors.white, width: 24),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.label),
                    2.verticalSpace,
                    AnimatedContainer(
                      duration: 250.milliseconds,
                      width: 50,
                      height: 3,
                      color: controller.currentTabIndex.value == index
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ],
                ));
          }).toList(),
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
