import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/widgets/error_widget.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AboutUsPage extends StatelessWidget {
  final String info;
  final String title;
  final authRM = Injector.getAsReactive<AuthStore>();
  AboutUsPage({Key key, this.info, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        child: Txt('${authRM.state.settingsModel[info]}',style: TxtStyle()..textAlign.center()..fontSize(18)..alignment.center(),));
  }

  Widget infoRebuilder() {
    return WhenRebuilder(
        onIdle: ()=>infoWidget(),
        onWaiting: ()=>WaitingWidget(),
        onError: (e)=>OnErrorWidget('لا توجد بيانات', getInfo),
        onData: (data)=>infoWidget(),
        models: [authRM]);
  }
}
