import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/data/models/categories_model.dart';

class InitPriceAndCity extends StatelessWidget {
  final String price;
  final int cityID;

  InitPriceAndCity({Key key, this.price, this.cityID}) : super(key: key);
  @override
  Size size;
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return detailsTable();
    // price.contains('null')
    // ? Container()
    // : Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       Txt(':السعر الابتدائي',
    //           style: TxtStyle()
    //             ..fontSize(20)
    //             ..textColor(ColorsD.main)
    //             ..textAlign.right()
    //             ..alignment.centerRight()),
    //       Txt(
    //         '$price ريال',
    //         style: TxtStyle()
    //           ..textDirection(TextDirection.rtl)
    //           ..fontSize(18)
    //           ..textAlign.right()
    //           ..alignment.centerRight()
    //           ..margin(right: 30),
    //       ),
    //       Divider()
    //     ],
    //   );
  }

  String city;
  Widget detailsTable() {
    return Container(
      height: size.height / 7,
      width: size.width * 0.8,
      decoration: BoxDecoration(
          border: Border.all(color: ColorsD.main),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Txt('المدينة',
                    style: TxtStyle()
                      ..alignmentContent.center()
                      ..background.color(ColorsD.main)
                      ..width(250)
                      ..height(size.height / 14)
                      ..borderRadius(topLeft: 12)
                      ..textColor(Colors.white)),
                cityRebuilder()
              ],
            ),
          ),
          Container(
              width: 1,
              child: VerticalDivider(
                thickness: 1,
                color: ColorsD.main,
                indent: 0,
                endIndent: 0,
              )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Txt('السعر الإبتدائي',
                    style: TxtStyle()
                      ..background.color(ColorsD.main)
                      ..width(250)
                      ..height(size.height / 14)
                      ..alignmentContent.center()
                      ..borderRadius(topRight: 12)
                      ..textColor(Colors.white)),
                Txt(
                  price.contains('null') ? 'لا يوجد' : '$price  ريال',
                  style: TxtStyle()
                    ..textDirection(TextDirection.rtl)
                    ..alignmentContent.center()
                    ..height(size.height / 15),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  final bidderRM = Injector.getAsReactive<BidderStore>();
  getCityName() {
    if (bidderRM.state.cititesModel == null)
      bidderRM.setState((state) => state.getCities(), onData: (_, store) {
        city = store.cititesModel.data
            .singleWhere((city) => city.id == cityID,
                orElse: () => Category()..city = 'غير محدد')
            .city;
      });
    else
      city = bidderRM.state.cititesModel.data
          .singleWhere((city) => city.id == cityID,
              orElse: () => Category()..city = 'غير محدد')
          .city;
  }

  Widget cityNameWidget() {
    return Txt(
      '$city',
      style: TxtStyle()
        ..alignmentContent.center()
        ..height(size.height / 15),
    );
  }

  Widget cityRebuilder() {
    getCityName();
    return WhenRebuilder(
        onIdle: cityNameWidget,
        onWaiting: cityNameWidget,
        onError: (e) => cityNameWidget(),
        onData: (d) => cityNameWidget(),
        models: [bidderRM]);
  }
}
