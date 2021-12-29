import 'package:flutter/material.dart';
import '../../theme/theme.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get thin => weight(FontWeight.w100);

  TextStyle get extraLight => weight(FontWeight.w200);

  TextStyle get light => weight(FontWeight.w300);

  TextStyle get regular => weight(FontWeight.w400);

  TextStyle get medium => weight(FontWeight.w500);

  TextStyle get semiBold => weight(FontWeight.w600);

  TextStyle get bold => weight(FontWeight.w700);

  TextStyle get maxWeight => weight(FontWeight.w900);

  TextStyle get italic => fontStyleT(FontStyle.italic);

  TextStyle get normal => fontStyleT(FontStyle.normal);

  TextStyle size(double size) => this.copyWith(fontSize: size);

  TextStyle textColor(Color v) => this.copyWith(color: v);

  TextStyle weight(FontWeight v) => this.copyWith(fontWeight: v);

  TextStyle fontStyleT(FontStyle v) => this.copyWith(fontStyle: v);

  TextStyle setDecoration(TextDecoration v) => this.copyWith(decoration: v);

  // TextStyle fontFamilies(String v) => this.copyWith(fontFamily:'cvcv');

  TextStyle letterSpaC(double v) => this.copyWith(letterSpacing: v);

  TextStyle heightLine(double v) => this.copyWith(height: v / fontSize!);

  TextStyle get textBFBFBF => textColor(AssetColors.colorGreyBFBFBF);

  TextStyle get text262626 => textColor(AssetColors.colorGrey262626);

  TextStyle get textWhite => textColor(Colors.white);

  TextStyle get textPrimary => textColor(AssetColors.primary);

  TextStyle get textBlack => textColor(Colors.black);

  TextStyle get text595959 => textColor(AssetColors.colorGrey595959);

  TextStyle get text001E62 => textColor(AssetColors.colorBlue001E62);

  TextStyle get text3F2F0E => textColor(Color(0xff3F2F0E));

  TextStyle get text434343 => textColor(AssetColors.colorGrey434343);

  TextStyle get decorationUnderline => setDecoration(TextDecoration.underline);

  TextStyle get letterSpacing0p1 => letterSpaC(0.1);
}
