import 'package:flutter/material.dart';

extension CardWrapperExtension on Widget {
  Widget get wrapCard {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: this,
      ),
    );
  }
}
