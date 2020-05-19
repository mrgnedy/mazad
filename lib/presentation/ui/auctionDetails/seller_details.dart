import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/register_model.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:shimmer/shimmer.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';

class SellerDetails extends StatelessWidget {
  Size size;
  final profile =
      Injector.getAsReactive<AuthStore>().state.currentSellerProfile.data;
  @override
  Widget build(BuildContext context) {
    final userAuctions = Injector.getAsReactive<BidderStore>()
        .state
        .allAuctions
        .data
        .userAuctions(profile.id);
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: BackAppBar(
            size.height / 8,
            Txt(
              'تفاصيل البائع',
              style: TxtStyle()
                ..fontSize(24)
                ..textColor(ColorsD.main),
            )),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            child: Column(
              children: <Widget>[
                Container(
                  height: size.height / 8,
                  width: size.height / 8,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            '${APIs.imageProfileUrl}${profile.image}')),
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorsD.main),
                  ),
                ),
                StylesD.richText('الإسم', '${profile.name}', size.width * 0.7,
                    TextStyle(fontSize: 16, fontFamily: 'bein')),
                StylesD.richText(
                    'رقم التليفون',
                    '${profile.phone}',
                    size.width * 0.7,
                    TextStyle(fontSize: 16, fontFamily: 'bein')),
                StylesD.richText(
                    'العنوان',
                    '${profile.address}',
                    size.width * 0.7,
                    TextStyle(fontSize: 16, fontFamily: 'bein')),
                // StylesD.richText('رقم التليفون', '${profile.}', size.width*0.7),
                Divider(thickness: 2,),
                Container(
                  width: size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Txt(
                        ':مزادات ${profile.name.split(' ').first}',
                        style: TxtStyle()
                          ..textColor(ColorsD.main)
                          ..fontSize(20)
                          ..alignment.coordinate(0.65, 0),
                      ),
                      ...List.generate(
                        userAuctions.length,
                        (index) => Container(
                          alignment: FractionalOffset(0.9, 0),
                          child: singleAuction(userAuctions[index]),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget singleAuction(AuctionData userAuction) {
    return InkWell(
      onTap: () => ExtendedNavigator.rootNavigator.pushNamed(Routes.auctionPage,
          arguments: AuctionPageArguments(auctionData: userAuction)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: size.width * 0.5,
            child: Text(
              userAuction.desc,
              maxLines: 1,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: size.height / 12,
              width: size.height / 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorsD.main),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${APIs.imageBaseUrl}${userAuction.images.first.image}',
                  ),
                ),
              ),
            ),
          )
          // Txt(userAuctions[index].desc, style: TxtStyle()..maxLines(1),),
          // Isez
        ],
      ),
    );
  }
}

class BiiderStore {}

class SellerInfo extends StatelessWidget {
  final bool isInDetals;
  SellerInfo({Key key, this.isInDetals = false}) : super(key: key);
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return sellerInfoRebuilder();
  }

  Widget sellerInfo() {
    final profile = authRM.state.currentSellerProfile.data;
    return Container(
      width: size.width * 0.8,
      child: InkWell(
        onTap: () =>
            ExtendedNavigator.rootNavigator.pushNamed(Routes.sellerDetails),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Visibility(
              visible: !isInDetals,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 4,
                ),
                Txt(
                  'المزيد',
                  style: TxtStyle()..textColor(ColorsD.main),
                ),
                SizedBox(width: 8),
                Txt(
                  '...',
                  style: TxtStyle()
                    ..textColor(ColorsD.main)
                    ..padding(bottom: 5)
                    ..fontWeight(FontWeight.bold),
                ),
                SizedBox(width: 8),
              ]),
            ),
            Txt('${profile.name}'),
            SizedBox(
              width: 16,
            ),
            Container(
              height: size.height / 12,
              width: size.height / 12,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        '${APIs.imageProfileUrl}${profile.image}')),
                shape: BoxShape.circle,
                border: Border.all(color: ColorsD.main),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  Widget sellerInfoRebuilder() {
    return WhenRebuilder(
        onIdle: shimmeringWidget,
        onWaiting: shimmeringWidget,
        onError: (data) => sellerInfo(),
        onData: (data) => sellerInfo(),
        models: [authRM]);
  }

  Widget shimmeringWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: ColorsD.main,
      direction: ShimmerDirection.rtl,
      child: Row(
        children: <Widget>[
          Container(
            height: size.height / 12,
            width: size.height / 12,
            child: Txt('sdasdsadasd'),
            decoration: BoxDecoration(shape: BoxShape.circle),
          ),
          Container(
            height: size.height / 40,
            width: size.width * 0.6,
          ),
        ],
      ),
    );
  }
}
