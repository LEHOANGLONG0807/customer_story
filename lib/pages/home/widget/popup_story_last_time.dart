import 'package:flutter/material.dart';
import '../../pages.dart';
import '../../../theme/theme.dart';
import '../../../common/common.dart';
import 'package:get/get.dart';

class PopUpStoryLastTime extends StatelessWidget {
  final _theme = Get.theme;
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _controller.onTapPopupStoryLastTime,
      child: Container(
        margin: const EdgeInsets.all(16),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AssetColors.colorGreyBFBFBF.withOpacity(0.5),
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final _model = _controller.storyHistory;
    return Row(
      children: [
        Container(
          width: 50,
          height: 70,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: CachedImageNetworkWidget(
            url: _model?.thumbnail ?? '',
          ),
        ),
        15.horizontalSpace,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _model?.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _theme.textTheme.subtitle2!.textBlack.heightLine(17),
              ),
              Text(
                'Đang đọc chương ${_model?.chapterId}',
                style: _theme.textTheme.bodyText2!.regular.textBFBFBF,
              ),
            ],
          ),
        ),
        5.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: _controller.onTapCloseStoryLastTime,
              child: const Icon(Icons.close),
            ),
            Text('Đọc tiếp').elevatedButton(onPressed: _controller.onTapContinueReading).wrapHeight(35)
          ],
        ),
      ],
    );
  }
}
