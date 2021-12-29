import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlView extends StatelessWidget {
  HtmlView({
    required this.htmlData,
    this.textStyle,
  });

  final String htmlData;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      htmlData,
      textStyle: textStyle ?? TextStyle(),
      webView: true,
      customStylesBuilder: (e) {
        switch (e.className) {
          case 'ql-align-left':
            return {'text-align': 'left'};
          case 'ql-align-center':
            return {'text-align': 'center'};
          case 'ql-align-right':
            return {'text-align': 'right'};
          case 'bold-16':
            return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '16dp', 'color': '#000000'};
          case 'normal-14-white':
            return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '14dp', 'color': '#ffffff'};
          case 'normal-14-black':
            return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '14dp', 'color': '#000000'};
        }
        switch (e.localName) {
          case 'p':
            return {'text-align': 'justify'};
        }
        return null;
      },
    );
  }
}

enum CssStyleClass { ql_align_left, ql_align_center, ql_align_right, bold_16, normal_14_white, normal_14_black }

extension CssStyleClassExt on CssStyleClass {
  String get name {
    switch (this) {
      case CssStyleClass.ql_align_left:
        return "ql-align-left";
      case CssStyleClass.ql_align_center:
        return "ql-align-center";
      case CssStyleClass.ql_align_right:
        return "ql-align-right";
      case CssStyleClass.bold_16:
        return "bold-16";
      case CssStyleClass.normal_14_white:
        return "normal-14-white";
      case CssStyleClass.normal_14_black:
        return "normal-14-black";
    }
  }
}
