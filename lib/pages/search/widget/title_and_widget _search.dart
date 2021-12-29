import 'package:flutter/material.dart';
import '../../../common/common.dart';
import 'package:get/get.dart';

class TitleAndWidgetSearch extends StatelessWidget {
  final String title;
  final Widget child;
  final double paddingTitle;

  TitleAndWidgetSearch({required this.title, required this.child, this.paddingTitle = 0});

  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _theme.textTheme.subtitle1).paddingSymmetric(horizontal: paddingTitle),
        20.verticalSpace,
        child,
      ],
    );
  }
}
