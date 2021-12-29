import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

extension ElevatedButtonFromTextExtension on Widget {
  ElevatedButton elevatedButton({required VoidCallback? onPressed, Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: this,
      style: ElevatedButton.styleFrom(
        primary: color ?? AssetColors.primary,
      ),
    );
  }

  OutlinedButton outlinedButton({required VoidCallback? onPressed, Color? color}) {
    return OutlinedButton(
        onPressed: onPressed,
        child: this,
        style: ElevatedButton.styleFrom(
          side: BorderSide(width: 1.5, color: color ?? AssetColors.primary),
        ));
  }
}
