import 'package:flutter/material.dart';
import '../../../common/widgets/base_dialog.dart';

class DialogChangeChapter extends StatelessWidget {
  final String message;

  DialogChangeChapter({required this.message});

  @override
  Widget build(BuildContext context) {
    return DialogOneButton(title: 'Thông báo', message: message, titleButton: 'OK');
  }
}
