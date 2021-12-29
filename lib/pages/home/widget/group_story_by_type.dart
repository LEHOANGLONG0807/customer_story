import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';

class GroupStoryByTypeWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final VoidCallback? onTapSeeMore;

  GroupStoryByTypeWidget({required this.child, required this.title, this.onTapSeeMore});

  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              title,
              style: _theme.textTheme.subtitle1,
            ),
            const Spacer(),
            InkWell(
              onTap: onTapSeeMore,
              child: Text(
                'Xem thêm >',
                style: _theme.textTheme.bodyText2!.medium.textPrimary,
              ),
            )
          ],
        ),
        15.verticalSpace,
        child,
      ],
    ).wrapCard;
  }
}
