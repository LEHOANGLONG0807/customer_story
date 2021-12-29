import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common.dart';

class ItemTagStory extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? onTap;

  ItemTagStory({required this.title, required this.color, this.onTap});
  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(title, style: _theme.textTheme.subtitle1!.medium, maxLines: 1, overflow: TextOverflow.ellipsis)],
        ),
      ),
    );
  }
}
