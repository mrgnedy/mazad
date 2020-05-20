import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/payments_model.dart';
import 'package:mazad/data/models/settings_model.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';

class CommisionPage extends StatefulWidget {
  final bool isSeller;
  final String value;
  final int notID;

  CommisionPage({Key key, this.isSeller = true, this.value, this.notID})
      : super(key: key);

  @override
  _CommisionPageState createState() => _CommisionPageState();
}

class _CommisionPageState extends State<CommisionPage> {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: BackAppBar(
            size.height / 10,
            Txt(
              'دفع ${widget.isSeller ? 'العمولة' : 'التأمين'}',
              style: TxtStyle()
                ..fontSize(20)
                ..textColor(ColorsD.main),
            )),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Txt(
                //   "عمولة التطبيق",
                //   style: TxtStyle()
                //     ..fontSize(24)
                //     ..textColor(ColorsD.main)
                //     ..alignment.coordinate(0.7, 1),
                // ),
                // SizedBox(height: size.height / 10),
                // Txt(
                //   'العمولة: 1%',
                //   style: TxtStyle()..fontSize(20)..textDirection(TextDirection.rtl),
                // ),
                getPaymentRebuilder(),
                buildGetPhoto(),
                sendCommissionRebuilder()
              ],
            ),
          ),
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
    if (!widget.isSeller)
      bidderRM.setState((state) => state.addBalance('0', _image.path),
          onError: (context, error) {
            print(error);
            return AlertDialogs.failed(
                content: error.toString(), context: context);
          },
          onData: (context, data) => ExtendedNavigator.rootNavigator
              .pushReplacementNamed(Routes.commisionSuccess));
    else
      sellerRM.setState((state) => state.addCommission('0', _image.path),
          onError: (context, e) {
        print(e);
        return AlertDialogs.failed(content: e.toString(), context: context);
      }, onData: (_, __) {
        if (widget.notID != null) {
          authRM.setState(
              (state) => state.delNotification(widget.notID.toString()));
          ExtendedNavigator.rootNavigator
              .pushReplacementNamed(Routes.commisionSuccess);
        }
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

  final bidderRM = Injector.getAsReactive<BidderStore>();

  Widget sendCommissionRebuilder() {
    return WhenRebuilder(
        onIdle: commissionWidget,
        onWaiting: () => WaitingWidget(),
        onError: (e) => commissionWidget(),
        onData: (d) => commissionWidget(),
        models: [widget.isSeller ? sellerRM : bidderRM]);
  }

  final authRM = Injector.getAsReactive<AuthStore>();

  getPaymentInfo() {
    if (authRM.state.paymentsModel == null)
      authRM.setState((state) => state.getPayment(), onData: (_, state) {});
    if (authRM.state.settingsModel == null)
      authRM.setState((state) => state.getSettings());

      Future.delayed(Duration(seconds: 1), ()=>setState((){}));
  }

  Widget getPaymentWidget() {
    final settings = SettingsInfo.fromJson(authRM.state.settingsModel);
    final bankInfo = authRM.state.paymentsModel.data.first;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[contactItem(bankInfo), commisionsWidget(settings)],
    );
  }

  Widget getPaymentRebuilder() {
    getPaymentInfo();
    return WhenRebuilder(
      onWaiting: () => WaitingWidget(),
      onError: (e) => Container(),
      onData: (d) => getPaymentWidget(),
      onIdle: () => getPaymentWidget(),
      models: [authRM],
    );
  }

  Widget commisionsWidget(SettingsInfo commisions) {
    return !widget.isSeller
        ? Container()
        : Parent(
            style: StylesD.cartStyle.clone()
              ..margin(top: 0, horizontal: 16)
              ..alignmentContent.center(),
            child: Column(
              children: <Widget>[
                Txt(
                  'تفاصيل العمولة',
                  style: TxtStyle()
                    ..fontSize(16)
                    ..textColor(ColorsD.main)
                    ..padding(bottom: 10),
                ),
                widget.value == null || widget.value.contains('null')
                    ? Column(children: [
                        StylesD.richText('عمولة المزادات المباشرة',
                            '${commisions.livecommission}', size.width * 0.5),
                        StylesD.richText('عمولة المزادات اليومية',
                            '${commisions.dailycommission}', size.width * 0.5),
                        StylesD.richText('عمولة المزادات الأسبوعية',
                            '${commisions.weekcommission}', size.width * 0.5),
                      ])
                    : StylesD.richText('العمولة المطلوب سدادها',
                        '${widget.value} ريال', size.width * 0.7)
              ],
            ),
          );
  }

  Widget contactItem(PaymentInfo bank) {
    return Parent(
      style: StylesD.cartStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Txt(
              "تفاصيل الحساب",
              style: TxtStyle()
                ..fontSize(16)
                ..textColor(ColorsD.main)
                ..padding(bottom: 10),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  // mainAxisSize: MainAxisSize.max,

                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Txt('اسم البنك: ${bank.accountName}',
                        style: TxtStyle()
                          ..textColor(ColorsD.main)
                          ..fontFamily('bein')),
                    StylesD.richText(
                        'صاحب الحساب', '${bank.accountName}', size.width * 0.4),
                    StylesD.richText(
                        'رقم الإبان', '${bank.iban}', size.width * 0.45),
                    StylesD.richText('رقم الحساب', '${bank.accountNumber}',
                        size.width * 0.45),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '${APIs.imageProfileUrl}${bank.image}',
                      height: size.height / 8.8,
                      // width: size.width / 4.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
