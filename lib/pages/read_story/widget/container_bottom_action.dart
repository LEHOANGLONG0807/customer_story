import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../../common/common.dart';

import '../../pages.dart';

class ContainerBottomReadAction extends StatelessWidget {
  final ReadStoryController controller;

  ContainerBottomReadAction(this.controller);

  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: 250.milliseconds,
        width: double.infinity,
        height: controller.showAction.value ? 130 : 0,
        padding: UIHelper.paddingAll16,
        color: AssetColors.colorGreyE7E7E7,
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: controller.onTapChapterPre,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back_ios),
                        Text(
                          'Chương trước',
                          style: _theme.textTheme.subtitle1!.regular.text595959,
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  InkWell(
                    onTap: controller.onTapListChapter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.menu),
                        Text(
                          'Danh sách chương',
                          style: _theme.textTheme.subtitle1!.regular.text595959,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: controller.onTapChapterNext,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Chương sau',
                          style: _theme.textTheme.subtitle1!.regular.text595959,
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  InkWell(
                    onTap: controller.onTapSetting,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.settings),
                        Text(
                          'Cài đặt',
                          style: _theme.textTheme.subtitle1!.regular.text595959,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
