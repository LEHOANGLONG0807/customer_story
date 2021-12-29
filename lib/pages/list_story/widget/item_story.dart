import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/models.dart';
import '../../../common/common.dart';

class ItemStoryInList extends StatelessWidget {
  final VoidCallback? onTap;
  final StoryModel model;

  ItemStoryInList({required this.model, this.onTap});

  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 105,
        margin: UIHelper.horizontalEdgeInsets20,
        child: Row(
          children: [
            _buildImage(),
            15.horizontalSpace,
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 70,
      height: 105,
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
            style: _theme.textTheme.subtitle1!.medium.heightLine(17),
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
              children: [
                TextSpan(
                  text: '${model.listTag![0].name ?? ''}',
                ),
                ...(model.listTag ?? []).sublist(1).map(
                      (e) => TextSpan(
                        text: ' - ${e.name ?? ''}',
                      ),
                    ),
              ],
            ),
          ),
          Text(
            '${model.chap ?? 0} Chương - ${(model.isFull ?? false) ? 'Hoàn thành' : 'Đang ra'}',
            style: _theme.textTheme.caption!.textBFBFBF,
          ),
        ],
      ),
    );
  }
}
