import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common.dart';

class DialogQuestion extends StatelessWidget {
  final String title, message, titleButtonOne, titleButtonTwo;
  final VoidCallback? functionOne, functionTwo;
  final bool isClose;

  DialogQuestion({
    required this.title,
    required this.message,
    required this.titleButtonOne,
    required this.titleButtonTwo,
    this.functionOne,
    this.functionTwo,
    this.isClose = true,
  });

  final _theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: UIHelper.horizontalEdgeInsets16,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            40.verticalSpace,
            4.verticalSpace,
            _buildTitleAndMessage(),
            25.verticalSpace,
            _buildRowButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndMessage() {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: _theme.textTheme.headline6!.textPrimary,
        ),
        20.verticalSpace,
        Text(
          message,
          textAlign: TextAlign.center,
          style: _theme.textTheme.subtitle2!.regular.text262626,
        ),
      ],
    ).paddingSymmetric(horizontal: 25);
  }

  Widget _buildRowButton() {
    return Row(
      children: [
        _buildButton(title: titleButtonOne, onTap: functionOne),
        _buildButton(title: titleButtonTwo, onTap: functionTwo, isPrimary: true),
      ],
    );
  }

  Widget _buildButton({required String title, bool isPrimary = false, VoidCallback? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Get.back();
          onTap?.call();
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            color: isPrimary ? _theme.primaryColor : Colors.transparent,
            border: Border.all(
              color: Colors.black.withOpacity(0.09),
            ),
          ),
          child: Text(
            title,
            style: _theme.textTheme.bodyText1!.textColor(isPrimary ? Colors.white : Colors.black).semiBold,
          ),
        ),
      ),
    );
  }
}

class DialogOneButton extends StatelessWidget {
  final String title, message, titleButton;
  final VoidCallback? function;

  DialogOneButton({
    required this.title,
    required this.message,
    required this.titleButton,
    this.function,
  });

  final _theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: UIHelper.horizontalEdgeInsets24,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            35.verticalSpace,
            _buildTitleAndMessage(),
            35.verticalSpace,
            Row(),
            Text(titleButton).elevatedButton(onPressed: () {
              Get.back();
              function?.call();
            }).wrapHeight(45),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndMessage() {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: _theme.textTheme.headline6!.text001E62,
        ),
        20.verticalSpace,
        Text(
          message,
          textAlign: TextAlign.center,
          style: _theme.textTheme.subtitle2!.regular.text262626,
        ),
      ],
    ).paddingSymmetric(horizontal: 25);
  }
}
