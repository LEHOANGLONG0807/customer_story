import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages.dart';
import '../../common/common.dart';

class SettingReadPage extends StatelessWidget {
  ReadStoryController get _controller => Get.find();
  final _theme = Get.theme;
  final _fontSize = 16.0.obs;
  final _readHorizontal = false.obs;
  @override
  Widget build(BuildContext context) {
    _readHorizontal.value = _controller.appController.readHorizontal.value;
    _fontSize.value = _controller.textStyle.value.fontSize!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    _fontSize.refresh();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          _buildSettingFontSize(),
          20.verticalSpace,
          // _buildScrollDirectionStory(),
          const Spacer(),
          Text('Lưu lại').elevatedButton(
            onPressed: () {
              if (_controller.appController.readHorizontal.value != _readHorizontal.value) {
                _controller.onSaveSettingScrollDirectionStory(readHorizontal: _readHorizontal.value);
              }
              _controller.onSaveSettingFontSize(fontSize: _fontSize.value);
            },
          ).fullWidth,
        ],
      ).paddingAll(20),
    );
  }

  Widget _buildSettingFontSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kích thước chữ',
          style: _theme.textTheme.subtitle1,
        ),
        10.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _fontSize.value,
                label: _fontSize.value.round().toString(),
                onChanged: (val) => _fontSize.value = val,
                min: 15,
                max: 26,
                divisions: 11,
              ),
            ),
            Text(
              'A',
              style: TextStyle(fontSize: _fontSize.value),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildScrollDirectionStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kiểu đọc',
          style: _theme.textTheme.subtitle1,
        ),
        10.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _readHorizontal.value,
                onChanged: (val) => _readHorizontal.value = true,
                title: Text(
                  'Vuốt ngang',
                  style: _theme.textTheme.subtitle1!.regular,
                ),
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: !_readHorizontal.value,
                onChanged: (val) => _readHorizontal.value = false,
                title: Text(
                  'Vuốt dọc',
                  style: _theme.textTheme.subtitle1!.regular,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
