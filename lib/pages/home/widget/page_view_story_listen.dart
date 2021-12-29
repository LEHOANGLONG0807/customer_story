import 'package:flutter/material.dart';
import '../../../common/common.dart';

class PageViewStoryListen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(30),
      child: Image.asset('img_listen_story'.assetPathPNG),
    );
  }
}
