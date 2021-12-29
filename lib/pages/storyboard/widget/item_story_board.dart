import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/models/models.dart';
import '../../../common/common.dart';

class ItemStoryBoard extends StatelessWidget {
  final StoryBoardLocalModel model;
  final VoidCallback? onTap;

  ItemStoryBoard({required this.model, this.onTap});

  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            _buildImage(),
            5.verticalSpace,
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: CachedImageNetworkWidget(
          url: model.thumbnail ?? '',
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.title ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _theme.textTheme.subtitle2!.semiBold.text262626.heightLine(16),
          ),

//          _buildStatus(),
          const Spacer(),
          Text('${model.chap ?? 0} Chương', style: _theme.textTheme.caption!.textBFBFBF),
        ],
      ),
    );
  }

//  Widget _buildStatus() {
//    return GridView.count(
//        crossAxisCount: 3,
//        childAspectRatio: 2,
//        shrinkWrap: true,
//        physics: const NeverScrollableScrollPhysics(),
//        padding: EdgeInsets.zero,
//        mainAxisSpacing: 0,
//        crossAxisSpacing: 2,
//        children: ['ic_full', 'ic_hot', 'ic_new'].map((item) {
//          return Image.asset(
//            item.assetPathPNG,
//            fit: BoxFit.fill,
//          );
//        }).toList());
//  }
}
