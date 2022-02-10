import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';

import 'controller.dart';
import 'widget/widget.dart';

class HistoryReadingPage extends GetView<HistoryReadingController> {
  final _textTheme=Get.textTheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử',style: _textTheme.headline6!.textWhite,),
        actions: [ItemGuide()],
      ),
      body: Obx(
        () => controller.listStory.isEmpty
            ? _buildNotFoundBook()
            : ListView.separated(
                padding: UIHelper.verticalEdgeInsets20,
                itemBuilder: (_, index) {
                  final _model = controller.listStory[index];
                  return ItemStoryHistory(
                    model: _model,
                    onTap: () => controller.onTapItemStory(_model),
                    onDelete: () => controller.onTapDelete(_model.id),
                  );
                },
                separatorBuilder: (_, index) => const Divider(height: 30),
                itemCount: controller.listStory.length,
              ),
      ),
    );
  }

  Widget _buildNotFoundBook() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(),
        Image.asset('ic_not_found_book'.assetPathPNG, width: 100),
        20.verticalSpace,
        Text('Không có dữ liệu', style: Get.textTheme.subtitle1!.regular),
      ],
    );
  }
}
