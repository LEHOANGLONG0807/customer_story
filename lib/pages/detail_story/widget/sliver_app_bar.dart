import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';
import '../../pages.dart';

class SliverHeaderAppBar extends StatelessWidget {
  final Widget bodyContent;

  final Widget buildHeader;

  SliverHeaderAppBar({required this.bodyContent, required this.buildHeader});

  static const kExpandedHeight = 150.0; //400
  final _controller = Get.find<DetailStoryController>();
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _controller.detailScrollController,
      physics: const ClampingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          Obx(
            () => SliverAppBar(
              expandedHeight: kExpandedHeight,
              toolbarHeight: 0,
              floating: false,
              pinned: false,
              leading: UIHelper.emptyBox,
              backgroundColor: _controller.backgroundColor.value,
              flexibleSpace: FlexibleSpaceBar(background: buildHeader),
            ),
          ),
        ];
      },
      body: bodyContent,
    );
  }
}
