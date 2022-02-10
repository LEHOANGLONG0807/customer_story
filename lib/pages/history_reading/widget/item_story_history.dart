import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:truyen_chu/pages/pages.dart';
import 'package:truyen_chu/theme/theme.dart';
import '../../../common/common.dart';
import '../../../models/models.dart';

class ItemStoryHistory extends StatelessWidget {
  final StoryHistoryLocalModel model;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  ItemStoryHistory({required this.model, this.onTap, this.onDelete});
  final _theme = Get.theme;
  final _isAdBoard = true.obs;
  final _controller = Get.find<HistoryReadingController>();
  @override
  Widget build(BuildContext context) {
    _checkStoryInBoard();
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      closeOnScroll: true,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.transparent,
          iconWidget: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AssetColors.colorRedEA3D2F.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.close,
              color: AssetColors.colorRedEA3D2F,
              size: 20,
            ),
          ),
          onTap: onDelete,
          foregroundColor: Colors.transparent,
        ),
      ],
      child: _buildItem(),
    );
  }

  Widget _buildItem() {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        margin: UIHelper.horizontalEdgeInsets20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            15.horizontalSpace,
            _buildContent(),
            10.horizontalSpace,
            Obx(
                  () => Icon(Icons.add).elevatedButton(onPressed: _isAdBoard.value ? null : _onAdd).wrapHeight(30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 70,
      height: 100,
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
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: _theme.textTheme.subtitle1!.medium.heightLine(16),
          ),
          Text(
            'Đang xem chương ${model.chapterId} - Trang ${model.pageIndex}',
            style: _theme.textTheme.caption!.textBFBFBF,
          ),

        ],
      ),
    );
  }

  void _onAdd() async {
    _isAdBoard.value = await _controller.onTapAddStoryBoard(model);
  }

  void _checkStoryInBoard() async {
    _isAdBoard.value = await _controller.checkStoryBoard(model.id);
  }
}
