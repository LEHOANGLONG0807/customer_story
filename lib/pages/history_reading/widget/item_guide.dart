import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

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
            child: Text('Vuốt sang trái để xóa truyện trong lịch sử.'),
          ),
          onPop: () => print('Popover was popped!'),
          direction: PopoverDirection.bottom,
          width: 200,
          arrowHeight: 10,
          arrowWidth: 10,
        );
      },
      icon: const Icon(Icons.error_outline),
    );
  }
}
