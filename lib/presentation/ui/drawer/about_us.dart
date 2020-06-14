import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';

import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/error_widget.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';

class AboutUsPage extends StatelessWidget {
  final bool isFromRegister;
  final String info;
  final String title;
  final authRM = Injector.getAsReactive<AuthStore>();
  Size size;
  AboutUsPage({Key key, this.info, this.title, this.isFromRegister = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      bottomSheet: isFromRegister ? acceptTerms() : null,
      appBar: BackAppBar(
        size.height / 8,
        Txt(
          '$title',
          style: TxtStyle()
            ..textColor(ColorsD.main)
            ..fontSize(24)
            ..alignmentContent.coordinate(0.95, 1),
        ),
      ),
      body: infoRebuilder(),
    );
  }

  getInfo() {
    if (authRM.state.settingsModel == null)
      authRM.setState((state) => state.getSettings());
  }

  Widget infoWidget() {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
       (authRM.state.settingsModel['image'].toString().contains('null')) ? Container(): Card(
         color: Colors.grey[200],
         child: Directionality(
           textDirection: TextDirection.rtl,
           child: ExpansionTile(
             
              initiallyExpanded: false,
              trailingColor: ColorsD.main.withOpacity(0.2),
              title: Txt("السجل التجارى", style: TxtStyle()..fontFamily('bein')..textColor(ColorsD.main),),
              children: <Widget>[
                Image.asset(
                  '${APIs.imageBaseUrl}${authRM.state.settingsModel[info]}',
                  height: size.height * 0.6,
                ),
                SizedBox(height: 20,)
              ],
            ),
         ),
       ),
        Txt(
          '${authRM.state.settingsModel[info]}',
          style: TxtStyle()
            ..textAlign.center()
            ..fontSize(18)
            ..alignment.center(),
        ),
      ],
    ));
  }

  Widget infoRebuilder() {
    return WhenRebuilder(
        onIdle: () => infoWidget(),
        onWaiting: () => WaitingWidget(),
        onError: (e) => OnErrorWidget('لا توجد بيانات', getInfo),
        onData: (data) => infoWidget(),
        models: [authRM]);
  }

  Widget acceptTerms() {
    bool isAccept = false;
    return Container(
      height: size.height / 6.5,
      child: BottomSheet(
          onClosing: () {},
          builder: (context) => StatefulBuilder(builder: (context, ss) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CheckboxListTile(
                        value: isAccept,
                        title: Txt(
                          'أوافق على الشروط والأحكام',
                          style: TxtStyle()
                            ..textAlign.right()
                            ..fontFamily('bein'),
                        ),
                        onChanged: (s) {
                          ss(() => isAccept = s);
                        }),
                    Txt(
                      'الدخول',
                      gesture: Gestures()
                        ..onTap(
                          () => isAccept == false
                              ? null
                              : ExtendedNavigator.rootNavigator
                                  .pushNamedAndRemoveUntil(Routes.mainPage,
                                      (Route<dynamic> route) => false,
                                      arguments: MainPageArguments(
                                          isSeller:
                                              authRM.state.selectedRole == 1)),
                        ),
                      style: StylesD.mazadBtnStyle.clone()
                        ..margin(all: 0)
                        ..background
                            .color(isAccept ? ColorsD.main : Colors.grey)
                        ..width(size.width * 0.5)
                        ..height(size.height / 16),
                    )
                  ],
                );
              })),
    );
  }
}
