import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/models/models.dart';
import '../common.dart';

class ItemCategoryStory extends StatelessWidget {
  final TagModel model;
  final Color color;
  final VoidCallback? onTap;
  final bool showColor;

  ItemCategoryStory({required this.model, this.color = Colors.white, this.onTap, this.showColor = true});
  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
        ),
        child: Row(
          children: [
            if (showColor)
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Image.asset('ic_${model.id}'.assetPathPNG),
              ),
            if (showColor) 10.horizontalSpace,
            Expanded(
              child: Center(
                child: Text(
                  model.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.subtitle2!.medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
