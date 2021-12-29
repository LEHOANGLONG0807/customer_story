import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

extension WidgetExtension on Widget {
  // Expand
  Widget get fullWidth => SizedBox(width: double.maxFinite, child: this);
  Widget get fulHeight => SizedBox(height: double.maxFinite, child: this);

  Widget wrapHeight(double amount) => SizedBox(height: amount, child: this);
  Widget wrapWidth(double amount) => SizedBox(width: amount, child: this);
  Widget wrapSize(double height, double width) => SizedBox(width: width, height: height, child: this);

  Widget scrollBar({Color? color, ScrollController? controller}) => VsScrollbar(
        controller: controller,
        showTrackOnHover: true, // default false
        isAlwaysShown: true, // def
        scrollbarFadeDuration: const Duration(milliseconds: 500), // default : Duration(milliseconds: 300)
        scrollbarTimeToFade: const Duration(milliseconds: 800), // ault false
        style: VsScrollbarStyle(
          hoverThickness: 8, // default 12.0
          radius: Radius.circular(10), // default Radius.circular(8.0)
          thickness: 16, // [ default 8.0 ]
          color: color, // default ColorScheme Theme
        ),
        child: this,
      );
}
