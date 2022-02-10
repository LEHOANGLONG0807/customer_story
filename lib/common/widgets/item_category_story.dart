import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/models/models.dart';
import '../common.dart';

class ItemCategoryStory extends StatelessWidget {
  final TagModel model;
  final Color color;
  final VoidCallback? onTap;
  final bool showColor;

  ItemCategoryStory(
      {required this.model, this.color = Colors.white, this.onTap, this.showColor = true});
  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                model.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _theme.textTheme.subtitle2!.medium,
              ),
            ),
          ),
          Container(width: 8,height: 8,color: color),
        ],
      ),
    );
  }
}
