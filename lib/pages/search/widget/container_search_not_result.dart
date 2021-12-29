import 'package:flutter/material.dart';
import '../../../common/common.dart';
import 'package:get/get.dart';

import '../controller.dart';
import 'widget.dart';

class ContainerSearchNotResult extends StatelessWidget {
  final _controller = Get.find<SearchController>();

  final _theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildResultSearch(),
          const Divider(height: 50),
          ContainerInitSearch(),
        ],
      ),
    );
  }

  Widget _buildResultSearch() {
    return TitleAndWidgetSearch(
      title: 'Kết quả tìm kiếm',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(text: 'Rất tiếc truyện ', style: _theme.textTheme.subtitle1!.regular, children: [
              TextSpan(text: '"${_controller.textController.text}"', style: _theme.textTheme.subtitle1!.textPrimary.italic),
              TextSpan(
                text: ' chưa cập nhật trong kho truyện',
              ),
            ]),
          ),
          15.verticalSpace,
          Text(
            'Yêu cầu cập nhật truyện',
          ).outlinedButton(onPressed: _controller.onTapSendRequestUpdateStory).wrapHeight(40),
        ],
      ),
    );
  }
}
