import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../pages.dart';
import '../../../common/common.dart';

class ContainerRating extends StatelessWidget {
  final _controller = Get.find<DetailStoryController>();
  final _theme = Get.theme;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: 250.milliseconds,
        height: _controller.showReview.value ? null : 0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đánh giá nhanh',
                  style: _theme.textTheme.subtitle1,
                ),
                TextButton(
                  style: TextButton.styleFrom(onSurface: Colors.grey),
                  onPressed: _controller.countStar.value > 0 ? _controller.onTapSendRatting : null,
                  child: Text(
                    'Gửi >>',
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                RatingBar(
                  initialRating: _controller.countStar.value,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 10,
                  itemSize: 24,
                  minRating: 0,
                  ratingWidget: RatingWidget(
                    full: Icon(
                      Icons.star,
                      color: _theme.primaryColor,
                    ),
                    empty: Icon(Icons.star_outline_outlined, color: _theme.primaryColor),
                    half: UIHelper.emptyBox,
                  ),
                  itemPadding: UIHelper.horizontalEdgeInsets2,
                  onRatingUpdate: (rating) {
                    _controller.countStar.value = rating;
                  },
                ),
                const Spacer(),
                if (_controller.countStar.value > 0)
                  Text(
                    '${_controller.countStar.value.toInt()}',
                    style: _theme.textTheme.headline5,
                  ),
                if (_controller.countStar.value > 0)
                  Text(
                    '/10',
                    style: _theme.textTheme.subtitle1!.regular,
                  )
              ],
            ).wrapHeight(40),
          ],
        ),
      ),
    );
  }
}
