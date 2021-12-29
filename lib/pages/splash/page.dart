import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/common.dart';

import 'controller.dart';

class SplashPage extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img_splash'.assetPathPNG),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
