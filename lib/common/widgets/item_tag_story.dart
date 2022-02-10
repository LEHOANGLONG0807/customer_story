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
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(title, style: _theme.textTheme.subtitle1!.medium, maxLines: 1, overflow: TextOverflow.ellipsis),
            )
          ),
          Container(width: 8,height: 8,color: color),
        ],
      ),
    );
  }
}
