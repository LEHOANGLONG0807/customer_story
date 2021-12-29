import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';
import '../../../models/models.dart';

class ItemStorySuggestSearch extends StatelessWidget {
  final VoidCallback? onTap;
  final StoryModel model;

  ItemStorySuggestSearch({required this.model, this.onTap});

  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            _buildImage(),
            10.horizontalSpace,
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 55,
      height: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: CachedImageNetworkWidget(
        url: model.thumbnail ?? '',
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.title ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _theme.textTheme.subtitle2!.medium.heightLine(16),
          ),
          const Spacer(),
          Text(
            model.authorName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _theme.textTheme.caption!.textBFBFBF,
          ),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: new TextSpan(
                style: _theme.textTheme.caption!.textBFBFBF,
                children: (model.listTag ?? [])
                    .map(
                      (e) => TextSpan(
                        text: '${e.name ?? ''} - ',
                      ),
                    )
                    .toList()),
          ),
        ],
      ),
    );
  }
}
