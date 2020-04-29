import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class ChangePasswordScreen extends StatelessWidget {
  Size size;
  TextEditingController currentPasswordCtrler = TextEditingController();
  TextEditingController newPasswordCtrler = TextEditingController();
  TextEditingController confirmPasswordCtrler = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TetFieldWithTitle(
                    title: 'كلمة المرور الحالية',
                    isPassword: true,
                    textEditingController: currentPasswordCtrler,
                  ),
                  TetFieldWithTitle(
                    title: 'كلمة المرور الجديدة',
                    isPassword: true,
                    textEditingController: newPasswordCtrler,
                    validator: passwordValidator,
                  ),
                  TetFieldWithTitle(
                    title: 'تأكيد كلمة المرور',
                    isPassword: true,
                    textEditingController: confirmPasswordCtrler,
                    validator: confirmPasswordValidator,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  changePasswordRebuilder()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  changePass() {
    if (_formKey.currentState.validate())
      authRM.setState(
          (state) => state.changePass(
              currentPasswordCtrler.text, newPasswordCtrler.text),
          onData: (context, store) => ExtendedNavigator.rootNavigator.pop(),
          onError: (context, error) =>
              AlertDialogs.failed(context: context, content: error.toString()));
  }

  Widget changePasswordWidget() {
    return Txt(
      'تغيير',
      gesture: Gestures()..onTap(changePass),
      style: StylesD.mazadBtnStyle.clone()
        ..width(size.width * 0.4)
        ..height(size.height / 16)
        ..fontSize(20)
        ..alignment.center(),
    );
  }

  Widget changePasswordRebuilder() {
    return WhenRebuilder<AuthStore>(
        onIdle: changePasswordWidget,
        onWaiting: () => WaitingWidget(),
        onError: (e) => changePasswordWidget(),
        onData: (d) => changePasswordWidget(),
        models: [authRM]);
  }

  String confirmPasswordValidator(String s) {
    if (newPasswordCtrler.text != confirmPasswordCtrler.text)
      return "كلمة المرور الجديدة غير مطابقة";
  }

  String passwordValidator(String s) {
    if (confirmPasswordCtrler.text.length < 6) return "كلمة المرور قصيرة";
  }

  Widget buildAppBar() {
    return PreferredSize(
      child: Column(
        children: <Widget>[
          Parent(
            child: Image.asset('assets/icons/back.png'),
            gesture: Gestures()
              ..onTap(() => ExtendedNavigator.rootNavigator.pop()),
            style: ParentStyle()
              ..alignment.coordinate(0.89, 1)
              ..margin(top: 15, bottom: 5),
          ),
          Txt('تغيير كلمة المرور',
              style: TxtStyle()
                ..textColor(ColorsD.main)
                ..fontSize(24)
                ..alignment.coordinate(0.9, 0.5))
        ],
      ),
      preferredSize: Size.fromHeight(size.height / 8),
    );
  }
}
