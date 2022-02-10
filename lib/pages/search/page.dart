import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../common/common.dart';
import '../../enum.dart';

import 'controller.dart';
import 'widget/widget.dart';

class SearchPage extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.colorBlueF2F4FF,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          title: TextFieldSearch(),
          actions: [
            InkWell(
              onTap:  controller.onTapSearch,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            20.verticalSpace,
            Expanded(
              child: Obx(
                () => _buildContent(),
              ),
            ),
          ],
        ));
  }

  Widget _buildContent() {
    final _status = controller.statusSearch.value;
    final _widget = _status == StatusSearch.INIT_SEARCH
        ? ContainerInitSearch().paddingSymmetric(horizontal: 20)
        : (_status == StatusSearch.HAVE_VALUE
            ? ContainerSearchResult()
            : ContainerSearchNotResult().paddingSymmetric(horizontal: 20));
    return _widget;
  }
}
