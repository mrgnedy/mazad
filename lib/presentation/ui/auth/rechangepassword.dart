import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/router.gr.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RechangePasswordScreen extends StatelessWidget {
  TextEditingController phoneCtrler = TextEditingController();
  TextEditingController newPasswordCtrler = TextEditingController();
  TextEditingController confirmPasswordCtrler = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            child: Txt(
              'تغيير كلمة المرور',
              style: TxtStyle()
                ..textColor(ColorsD.main)
                ..fontSize(24)
                ..textAlign.right()
                ..alignment.coordinate(0.8, 0.5),
            ),
            preferredSize: Size.fromHeight(size.height / 16)),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TetFieldWithTitle(
                title: 'رقم الجوال',
                countryCode: '+966',
                textEditingController: phoneCtrler,
                isPassword: false,
              ),
              TetFieldWithTitle(
                title: 'كلمة المرور',
                textEditingController: newPasswordCtrler,
                isPassword: true,
                validator: passwordValidator,
              ),
              TetFieldWithTitle(
                title: "تأكيد كلمة المرور",
                textEditingController: confirmPasswordCtrler,
                isPassword: true,
                validator: confirmPasswordValidator,
              ),
              SizedBox(height: 25),
              confrimRechangeRebuilder()
            ],
          ),
        ),
      ),
    ));
  }

  String passwordValidator(String s) {
    if (s == null || s.isEmpty || s.length < 6) return 'كلمة المرور قصيرة';
  }

  String confirmPasswordValidator(String s) {
    if (newPasswordCtrler.text != confirmPasswordCtrler.text)
      return 'كلمة المرور غير مطابقة';
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  rechangePassword() {
    if (!_formKey.currentState.validate()) return;
    authRM.setState(
      (state) => state.rechangePassowrd('+966${phoneCtrler.text}',
          newPasswordCtrler.text, confirmPasswordCtrler.text),
      onError: (context, error) {
        print(error);
        AlertDialogs.failed(content: '$error', context: context);
      },
      onData: (context, data) {
        ExtendedNavigator.rootNavigator.pushNamedAndRemoveUntil(
            Routes.mainPage, (Route<dynamic> route) => false,
            arguments:
                MainPageArguments(isSeller: authRM.state.selectedRole == 1));
      },
    );
  }

  Widget confirmRechangeWidget() {
    return Txt(
      'تأكيد',
      gesture: Gestures()..onTap(rechangePassword),
      style: StylesD.mazadBtnStyle.clone()
        ..width(size.width * 0.4)
        ..height(size.height / 16)
        ..fontSize(18),
    );
  }

  Widget confrimRechangeRebuilder() {
    return WhenRebuilder(
        onIdle: confirmRechangeWidget,
        onWaiting: () => WaitingWidget(),
        onError: (e) => confirmRechangeWidget(),
        onData: (d) => confirmRechangeWidget(),
        models: [authRM]);
  }
}
