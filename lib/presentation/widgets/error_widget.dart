import 'package:division/division.dart';
import 'package:flutter/material.dart';

class OnErrorWidget extends StatelessWidget {
  final errorMsg;
  final Function callback;
  OnErrorWidget([this.errorMsg = 'حدث خطأ في الإتصال', this.callback]);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Txt(
        '$errorMsg',
        gesture: Gestures()..onTap(callback),
      ),
    );
  }
}
