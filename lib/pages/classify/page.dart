import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/extensions/text_extension.dart';
import '../home/widget/widget.dart';
import '../../theme/theme.dart';

import 'controller.dart';
import 'widget/widget.dart';

class ClassifyPage extends GetView<ClassifyController> {
  final _textTheme=Get.textTheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.colorBlueF2F4FF,
      appBar: AppBar(
        title:  Text('Phân loại',style: _textTheme.headline6!.textBlack,),
      ),
      body: TabBarTypeClassify(tabLabels: [
        'Truyện đọc',
        'Truyện nghe'
      ], pages: [
        TabViewStoryRead(),
        PageViewStoryListen(),
      ]),
    );
  }
}
