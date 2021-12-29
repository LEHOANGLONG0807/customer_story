import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../theme/theme.dart';
import 'package:get/get.dart';

import '../controller.dart';

class TextFieldSearch extends StatelessWidget {
  final _controller = Get.find<SearchController>();

  final _isCancel = false.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          controller: _controller.textController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            fillColor: AssetColors.colorGreyE7E7E7,
            hintText: 'Nhập tên truyện',
            contentPadding: EdgeInsets.symmetric(vertical: 1),
            prefixIcon: const Icon(
              Icons.search,
              size: 24,
              color: AssetColors.colorGrey262626,
            ),
          ),
          onChanged: (val) {
            if (val.isNotEmpty) {
              _isCancel.value = true;
            }
          },
          onFieldSubmitted: (val) {
            _controller.onTapSearch();
          },
        ),
        Obx(
          () => _isCancel.value
              ? InkWell(
                  onTap: _onTapCancel,
                  child: const Icon(
                    Icons.cancel,
                    size: 24,
                    color: AssetColors.colorGrey262626,
                  ),
                ).paddingOnly(right: 10)
              : UIHelper.emptyBox,
        ),
      ],
    );
  }

  void _onTapCancel() {
    _controller.onCancelSearch();
    _isCancel.value = false;
  }
}
