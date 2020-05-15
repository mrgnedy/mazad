import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';

class VerifyScreen extends StatelessWidget {
  final bool isForgetPass;
  final String phone;
  Size size;
  String code;
  VerifyScreen({Key key, this.phone, this.isForgetPass}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/icons/logo.png',
                height: size.height / 5,
                width: size.height / 5,
              ),
              Txt('أدخل كود التفعيل'),
              Container(
                width: size.width * 0.7,
                child: PinCodeTextField(
                  length: 4,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  inactiveColor: Colors.grey[800],
                  activeColor: ColorsD.main,
                  autoFocus: true,
                  dialogContent: 'هل تريد لصق الكود؟',
                  affirmativeText: 'لصق',
                  negativeText: 'رجوع',
                  dialogTitle: 'لصق الكود',
                  fieldHeight: size.height / 12,
                  fieldWidth: size.height / 12,
                  onChanged: (s) => code = s,
                  onCompleted: verify,
                ),
              ),
              verifyActionsRebuilder()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSendBtn() {
    return Txt(
      'تأكيد',
      gesture: Gestures()..onTap(() => verify(code)),
      style: StylesD.mazadBtnStyle.clone()
        ..height(size.height / 16)
        ..width(size.width * 0.4)
        ..fontSize(22),
    );
  }

  Widget buildResendBtn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: resendVerify,
        child: RichText(
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            text: TextSpan(children: [
              TextSpan(
                  text: "لم يصلك الكود؟  ",
                  style: TextStyle(color: Colors.black, fontFamily: 'bein')),
              TextSpan(
                  text: 'إاعادة الإرسال',
                  style: TextStyle(color: ColorsD.main, fontFamily: 'bein')),
            ])),
      ),
    );
  }

  Widget verifyActionsWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildSendBtn(),
        buildResendBtn(),
      ],
    );
  }

  Widget verifyActionsRebuilder() {
    return WhenRebuilder(
        onIdle: verifyActionsWidget,
        onWaiting: () => WaitingWidget(),
        onError: (e) => verifyActionsWidget(),
        onData: (d) => verifyActionsWidget(),
        models: [authRM]);
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  verify(String code) {
    if (isForgetPass == false)
      authRM.setState((state) => state.verify(code, phone),
          onData: onData, onError: onError);
    else
      authRM.setState((state) => state.verifyForgetPasowrd(code, phone),
          onData: onData, onError: onError);
  }

  resendVerify() {
    print(phone);
    authRM.setState(
        (state) => state.resendVerify(phone).then((cred) {
              print('THIS IS CODE ${cred}');
              Clipboard.setData(ClipboardData(text: cred));
              HapticFeedback.vibrate();
            }), onError: (context, error) {
      print('$error');
      AlertDialogs.failed(context: context, content: 'تعذر ارسال كود التفعيل');
    });
  }

  onData(context, AuthStore data) {
    if (isForgetPass)
      ExtendedNavigator.rootNavigator.pushNamed(Routes.rechangePasswordScreen);
    else
      ExtendedNavigator.rootNavigator.pushNamedAndRemoveUntil(
          Routes.aboutUsPage, (Route<dynamic> route) => false,
          arguments: AboutUsPageArguments(
              info: 'policy', title: 'الشروط والأحكام', isFromRegister: true));
  }

  onError(context, error) {
    print('$error');
    AlertDialogs.failed(
        context: context,
        content: 'الكود الذى أدخلته غير صحيح\nمن فضلك أعد المحاولة');
  }
}
