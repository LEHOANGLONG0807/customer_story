import 'package:flutter/material.dart';

extension GradientWidget on Widget {
  Widget gradientTopBottom({List<Color>? colors}) => Stack(
        alignment: Alignment.center,
        children: [
          this,
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colors ?? [Colors.transparent, Colors.black.withOpacity(0.5)],
              ),
            ),
          ),
        ],
      );
}
