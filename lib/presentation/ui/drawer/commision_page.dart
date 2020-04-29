import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';

class CommisionPage extends StatelessWidget {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BackAppBar(size.height / 18),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Txt(
              "عمولة التطبيق",
              style: TxtStyle()
                ..fontSize(24)
                ..textColor(ColorsD.main)
                ..alignment.coordinate(0.7, 1),
            ),
            SizedBox(height: size.height / 10),
            Txt(
              'العمولة: 200 ريال',
              style: TxtStyle()..fontSize(20),
            ),
            buildGetPhoto(),
            sendCommissionRebuilder()
          ],
        ),
      ),
    );
  }

  File _image;
  bool noImageError = false;
  Color get color => noImageError ? ColorsD.main : Colors.black;
  GlobalKey<State> _getImageKey = GlobalKey<State>();
  Widget buildGetPhoto() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: StatefulBuilder(
          key: _getImageKey,
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: _image != null ? size.height / 2 : size.height / 8,
                  width: _image != null ? size.width * 0.7 : size.height / 8,
                  child: InkWell(
                    onTap: () async {
                      _image = await StylesD.getProfilePicture(context);
                      noImageError = false;

                      setState(() {});
                    },
                    child: _image != null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover)),
                          )
                        : DottedBorder(
                            color: noImageError ? Colors.red : Colors.black,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12),
                            strokeCap: StrokeCap.butt,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image,
                                    size: 35,
                                    color: noImageError
                                        ? Colors.red
                                        : ColorsD.main,
                                  ),
                                ),
                                Align(
                                    alignment: FractionalOffset(0.9, 1.25),
                                    child: Image.asset('assets/icons/cam.png')),
                              ],
                            ),
                          ),
                  ),
                ),
                Visibility(
                    visible: noImageError,
                    child: Txt(
                      'من فضلك أرفق صورة الايصال',
                      style: TxtStyle()
                        ..textColor(Colors.red)
                        ..padding(top: 16),
                    ))
              ],
            );
          }),
    );
  }

  sendCommission() {
    if (_image == null) {
      noImageError = true;
      _getImageKey.currentState.setState(() {});
      return null;
      // AlertDialogs.failed(content: 'من فضلك أرفق صورة الايصال', context: context);
    }
    sellerRM.setState((state) => state.addCommission('1555', _image.path),
        onError: (context, e) {
      print(e);
      return AlertDialogs.failed(content: e.toString(), context: context);
    }, onData: (_, __) {
      ExtendedNavigator.rootNavigator.pushReplacementNamed(Routes.commisionSuccess);
    });
  }

  Widget commissionWidget() {
    return Txt(
      'سداد المبلغ',
      gesture: Gestures()..onTap(() => sendCommission()),
      style: StylesD.mazadBtnStyle
        ..fontSize(24)
        ..height(size.height / 16)
        ..width(size.width * 0.5),
    );
  }

  final sellerRM = Injector.getAsReactive<SellerStore>();
  Widget sendCommissionRebuilder() {
    return WhenRebuilder(
        onIdle: commissionWidget,
        onWaiting: () => WaitingWidget(),
        onError: (e) => commissionWidget(),
        onData: (d) => commissionWidget(),
        models: [sellerRM]);
  }
}
