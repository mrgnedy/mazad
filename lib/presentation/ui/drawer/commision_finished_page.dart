import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';

import '../../router.gr.dart';

class CommisionSuccess extends StatelessWidget {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/icons/right.png'),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Txt(
                'تم سداد المبلغ بنجاح\nشكراََ',
                style: TxtStyle()
                  ..textAlign.center()
                  ..textColor(ColorsD.main)
                  ..fontSize(18),
              ),
            ),
            Txt(
              'الذهاب للرئيسية',
              gesture: Gestures()
                ..onTap(() => ExtendedNavigator.rootNavigator
                    .pushNamedAndRemoveUntil(
                        Routes.mainPage, (Route<dynamic> route) => false,
                        arguments: MainPageArguments(isSeller: true))),
              style: StylesD.mazadBtnStyle.clone()
                ..height(size.height / 16)
                ..width(size.width * 0.5),
            )
          ],
        ),
      ),
    );
  }
}
