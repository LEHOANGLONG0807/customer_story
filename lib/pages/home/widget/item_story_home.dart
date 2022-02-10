import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';
import '../../../models/models.dart';

class ItemStoryHome extends StatelessWidget {
  final StoryModel model;
  final VoidCallback? onTap;

  ItemStoryHome({required this.model, this.onTap});

  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            _buildImage(),
            10.verticalSpace,
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
            style: _theme.textTheme.caption!.semiBold.text262626.heightLine(13).size(10),
          ),
          const Spacer(),
          5.verticalSpace,
          _buildStatus(),
          Text(
            '${model.chap ?? 0} chương',
            style: _theme.textTheme.overline!.size(8).letterSpacing0p1.text595959,
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        mainAxisSpacing: 0,
        crossAxisSpacing: 2,
        children: [
          if (model.isHot ?? false)
            Image.asset(
              'ic_hot'.assetPathPNG,
              fit: BoxFit.fill,
            ),
          if (model.isNew ?? false)
            Image.asset(
              'ic_new'.assetPathPNG,
              fit: BoxFit.fill,
            ),
          if (model.isFull ?? false)
            Image.asset(
              'ic_full'.assetPathPNG,
              fit: BoxFit.fill,
            ),
        ]);
  }
}
