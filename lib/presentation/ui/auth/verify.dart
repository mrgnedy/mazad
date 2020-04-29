import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyScreen extends StatelessWidget {
  Size size;
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
                  onChanged: (s) {},
                ),
              ),
              buildResendBtn(),
              buildSendBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSendBtn() {
    return Txt(
      'تأكيد',
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
        onTap: () => null,
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
}
