import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  Size size;
  TextEditingController nameCtrler;
  TextEditingController phoneCtrler;
  TextEditingController descCtrler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameCtrler = TextEditingController(
        text: '${authRM.state.credentialsModel?.data?.name}');
    phoneCtrler = TextEditingController(
        text: '${authRM.state.credentialsModel?.data?.phone}');
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BackAppBar(
          size.height / 8,
          Txt(
            'إتصل بنا',
            style: TxtStyle()
              ..textColor(ColorsD.main)
              ..fontSize(24)
              ..alignmentContent.coordinate(0.95, 1),
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TetFieldWithTitle(
                title: 'الإسم',
                textEditingController: nameCtrler,
              ),
              TetFieldWithTitle(
                title: 'الجوال',
                textEditingController: phoneCtrler,
              ),
              TetFieldWithTitle(
                title: 'شكوتك أو اقتراحك',
                textEditingController: descCtrler,
                minLines: 3,
              ),
              sendContactRebuilder(),
              Txt(
                'أو تواصل معنا عن طريق',
                style: TxtStyle()
                  ..textAlign.center()
                  ..textColor(ColorsD.main),
              ),
              SizedBox(height: 15),
              contactActions()
            ],
          ),
        ),
      ),
    );
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  sendContact(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    authRM.setState(
        (state) => state.sendContact(
            nameCtrler.text, '${descCtrler.text}', phoneCtrler.text),
        onError: (context, error) {
      print(error);
      AlertDialogs.failed(
          content: 'تعذر الإرسال, من فضلك حاول مرة أخرى', context: context);
    }, onData: (context, data) {
      Toast.show('نشكركم على تواصلكم معنا', context,
          duration: Toast.LENGTH_LONG);
    });
  }

  sendContactWidget() {
    return Builder(builder: (context) {
      return Txt(
        'إرسال',
        gesture: Gestures()..onTap(() => sendContact(context)),
        style: StylesD.mazadBtnStyle.clone()
          ..height(size.height / 16)
          ..width(size.width * 0.4)
          ..fontSize(22),
      );
    });
  }

  sendContactRebuilder() {
    return WhenRebuilder(
        onIdle: () => sendContactWidget(),
        onWaiting: () => WaitingWidget(),
        onError: (e) => sendContactWidget(),
        onData: (d) => sendContactWidget(),
        models: [authRM]);
  }

  contactActions() {
    return Container(
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.twitter), onPressed: launchTwitter),
          IconButton(
              icon: Icon(FontAwesomeIcons.facebook), onPressed: launchFacebook),
          IconButton(
              icon: Icon(FontAwesomeIcons.google), onPressed: launchGmail),
          IconButton(
              icon: Icon(FontAwesomeIcons.instagram), onPressed: launchinsta),
          IconButton(
              icon: Icon(FontAwesomeIcons.whatsapp), onPressed: launchWhatsapp),
          IconButton(
              icon: Icon(FontAwesomeIcons.phone), onPressed: launchPhone),
        ],
      ),
    );
  }

  launchFacebook() async {
    final facebookName = authRM.state.settingsModel['facebook'];
    final facebookURL = 'fb.me/$facebookName';
    if (await canLaunch(facebookURL)) await launch(facebookURL);
  }

  launchWhatsapp() async {
    final whatsappPhone = authRM.state.settingsModel['whatsapp'];
    final url = 'whatsapp://send?phone=/$whatsappPhone';
    if (await canLaunch(url)) await launch(url);
  }

  launchPhone() async {
    final whatsappPhone = authRM.state.settingsModel['first_phone'];
    final url = 'tel:$whatsappPhone';
    if (await canLaunch(url)) await launch(url);
  }

  launchGmail() async {
    final whatsappPhone = authRM.state.settingsModel['google'];
    final url = 'mailto:$whatsappPhone';
    if (await canLaunch(url)) await launch(url);
  }

  launchTwitter() async {
    final whatsappPhone = authRM.state.settingsModel['twitter'];
    final url = 'twitter://user?screen_name=$whatsappPhone';
    if (await canLaunch(url)) await launch(url);
  }

  launchinsta() async {
    final whatsappPhone = authRM.state.settingsModel['instagram'];
    final url = 'http://instagram.com/_u/$whatsappPhone';
    if (await canLaunch(url)) await launch(url);
  }
}
