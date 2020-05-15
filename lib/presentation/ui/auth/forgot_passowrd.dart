import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

enum ForgetPasswordSteps { sendVCode, verifyCode, rechangePassword }

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController phoneCtrler = TextEditingController();
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
            child: Txt(
              'استرجاع كلمة المرور',
              style: TxtStyle()
                ..textColor(ColorsD.main)
                ..fontSize(24)
                ..textAlign.right()
                ..alignment.coordinate(0.8, 0.5),
            ),
            preferredSize: Size.fromHeight(size.height / 16)),
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TetFieldWithTitle(
              title: 'رقم الجوال',
              textEditingController: phoneCtrler,
              icon: Container(
                  width: size.width / 7,
                  child: Txt('+966',
                      style: TxtStyle()
                        ..textDirection(TextDirection.ltr)
                        ..alignment.centerRight()
                        ..width(size.width / 9))),
            ),
            sendForgetPWRebuilder()
          ],
        ),
      ),
    );
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  sendForgetPassword() {
    authRM.setState(
        (state) => state.sendForgetPassword('+966${phoneCtrler.text}').then((code) {
              Clipboard.setData(ClipboardData(text: code));
              HapticFeedback.vibrate();
            }), onError: (context, error) {
      print('$error');
      AlertDialogs.failed(
          context: context,
          content: 'من فضلك تأكد من صحة رقم الجوال وأعد المحاولة');
    }, onData: (context, data) {
      // Clipboard.setData(ClipboardData(text: ))
      ExtendedNavigator.rootNavigator.pushNamed(Routes.verifyScreen,
          arguments: VerifyScreenArguments(isForgetPass: true, phone: '+966${phoneCtrler.text}'));
    });
  }

  Widget sendForgetPWWidget() {
    return Txt(
      'ارسال رمز التفعيل',
      gesture: Gestures()..onTap(sendForgetPassword),
      style: StylesD.mazadBtnStyle.clone()
        ..width(size.width * 0.4)
        ..height(size.height / 16)
        ..fontSize(18),
    );
  }

  Widget sendForgetPWRebuilder() {
    return WhenRebuilder(
        onIdle: sendForgetPWWidget,
        onWaiting: () => WaitingWidget(),
        onError: (e) => sendForgetPWWidget(),
        onData: (d) => sendForgetPWWidget(),
        models: [authRM]);
  }
}
