import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:toast/toast.dart';

import '../router.gr.dart';

class AuctionCard extends StatelessWidget {
  final AuctionData auctionData;
  String service;
  String package;
  String shred;
  BuildContext ctx;
  Size size;
  AuctionCard({Key key, this.auctionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ctx = context;
    size = MediaQuery.of(context).size;
    return Parent(
      gesture: Gestures()
        ..onTap(() => ExtendedNavigator.rootNavigator.pushNamed(
            Routes.auctionPage,
            arguments: AuctionPageArguments(auctionData: auctionData))),
      style: StylesD.cartStyle.clone()..height(size.height / 4),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    defaultRichTxt('الوصف', '${auctionData.desc}'),
                    // SizedBox(height: 10),
                    // defaultRichTxt('التقطيع', '$shred'),
                    // // SizedBox(height: 10),
                    // defaultRichTxt('التجهيز', '$package'),
                  ],
                ),
                SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: ColorsD.main,
                    height: size.height / 6,
                    width: size.width / 3,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${APIs.imageBaseUrl}${auctionData.images.isNotEmpty ? auctionData.images[0].image : null}',
                      imageBuilder: (context, imageB) => Container(
                        height: size.height / 6,
                        width: size.width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                image: imageB, fit: BoxFit.cover)),
                      ),
                      fit: BoxFit.cover,
                      placeholder: (_, chatty) => chatty.contains('null')
                          ? StylesD.noImageWidget()
                          : WaitingWidget(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: FractionalOffset(0.5, 1.12),
            child: auctionData.intialPrice.contains('null')
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      defaultRichTxt(
                          'بداية المزاد', '${auctionData.intialPrice} ر.س'),
                      SizedBox(width: 10),
                    ],
                  ),
          ),
          Visibility(
              visible: auctionData.isFinished || auctionData.type == '1',
              child: buildDelete()),
          Visibility(
              visible: auctionData.isFinished || auctionData.type == '1',
              child: buildRestore())
        ],
      ),
    );
  }

  final sellerRM = Injector.getAsReactive<SellerStore>();
  deleteAuction() {
    sellerRM.setState((state) => state.deleteAuction(auctionData.id),
        onData: (context, data) {
      sellerRM.setState((state) => state.getMyAuctions());
      Toast.show('تم مسح المزاد', context, duration: Toast.LENGTH_LONG);
    }, onError: (context, error) {
      Toast.show('نعذر مسح المزاد, من فضلك أعد المحاولة', context,
          duration: Toast.LENGTH_LONG);
    });
  }

  restoreAuction() {
    sellerRM.setState((state) => state.returnAuction(auctionData.id),
        onData: (context, data) {
      sellerRM.setState((state) => state.getMyAuctions());
      Toast.show('تم نقل المزاد الى المزادات القائمة', context,
          duration: Toast.LENGTH_LONG);
    }, onError: (context, error) {
      Toast.show('نعذر تغيير حالة المزاد, من فضلك أعد المحاولة', context,
          duration: Toast.LENGTH_LONG);
    });
  }

  deleteAuctionDialoge(context, String title, Function callback) async {
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Parent(
          style: ParentStyle()..height(size.height / 2.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Icons.info,
                  size: 80,
                  color: ColorsD.main,
                ),
              ),
              // SizedBox(height: 25),
              Txt(
                title,
                style: TxtStyle()
                  ..textAlign.center()
                  ..textColor(ColorsD.main)
                  ..fontSize(18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Txt(
                    'رجوع',
                    style: StylesD.mazadBorderdBtnStyle.clone()
                      ..fontSize(18)
                      ..width(size.width * 0.25),
                    gesture: Gestures()
                      ..onTap(() => ExtendedNavigator.rootNavigator.pop(false)),
                  ),
                  SizedBox(width: 25),
                  Txt(
                    'نعم',
                    style: StylesD.mazadBtnStyle.clone()
                      ..fontSize(18)
                      ..width(size.width * 0.25),
                    gesture: Gestures()
                      ..onTap(() {
                        callback();
                        ExtendedNavigator.rootNavigator.pop(true);
                      }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDelete() {
    return Align(
      alignment: FractionalOffset(0.0, 1.0),
      child: GestureDetector(
        onTap: () =>
            deleteAuctionDialoge(ctx, 'هل تريد مسح هذا المزاد؟', deleteAuction),
        child: Icon(
          FontAwesomeIcons.trashAlt,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget buildRestore() {
    return Align(
      alignment: FractionalOffset(0, 0),
      child: GestureDetector(
        onTap: () => deleteAuctionDialoge(
            ctx, 'هل تريد تغيير حالة المزاد الى حالية؟', restoreAuction),
        child: Icon(
          Icons.settings_backup_restore,
          color: ColorsD.main,
        ),
      ),
    );
  }

  Widget defaultRichTxt(String key, String value) {
    final size = MediaQuery.of(ctx).size;
    return Container(
      width: size.width / 3,
      child: RichText(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          text: TextSpan(children: [
            TextSpan(
              text: '$key: ',
              style: TextStyle(
                color: ColorsD.main,
                fontFamily: 'bein',
              ),
            ),
            TextSpan(
              text: '$value',
              style:
                  TextStyle(height: 1, color: Colors.black, fontFamily: 'bein'),
            ),
          ])),
    );
  }
}
