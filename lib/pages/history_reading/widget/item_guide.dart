import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:truyen_chu/common/common.dart';

class ItemGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showPopover(
          context: context,
          transitionDuration: const Duration(milliseconds: 150),
          bodyBuilder: (context) => Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vuốt sang trái để xóa truyện trong lịch sử.'),
                10.verticalSpace,
                Text('Bấm button + để thêm vào tủ truyện'),
              ],
            ),
          ),
          onPop: () => print('Popover was popped!'),
          direction: PopoverDirection.bottom,
          width: 200,
          arrowHeight: 10,
          arrowWidth: 10,
        );
      },
      icon: const Icon(Icons.speaker_notes_outlined),
    );
  }
}
