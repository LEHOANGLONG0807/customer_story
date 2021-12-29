import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../biz/biz.dart';
import '../../../common/common.dart';

class ContainerBattery extends StatelessWidget {
  final _appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 32,
          height: 22,
          child: Image.asset(
            'ic_battery'.assetPathPNG,
            width: 32,
            height: 22,
            fit: BoxFit.fill,
            color: Color(0xff3F2F0E).withOpacity(0.8),
          ),
        ),
        Obx(
          () => Text(
            '${_appController.batteryPercent}%',
            style: Get.textTheme.caption!.size(8).textWhite.heightLine(9),
          ),
        ),
      ],
    );
  }
}
