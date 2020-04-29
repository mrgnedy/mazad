import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../router.gr.dart';

class AuctionCard extends StatelessWidget {
  final AuctionData auctionData;
  String service;
  String package;
  String shred;
  BuildContext ctx;

  AuctionCard({Key key, this.auctionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ctx = context;
    Size size = MediaQuery.of(context).size;
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
                    defaultRichTxt('النوع', '${auctionData.desc}'),
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
                      placeholder: (_,chatty)=>chatty.contains('null')? StylesD.noImageWidget() : WaitingWidget(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: FractionalOffset(1, 1.12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                defaultRichTxt(
                    'بداية المزاد', '${auctionData.intialPrice} ر.س'),
                SizedBox(width: 10),
              ],
            ),
          ),
          buildDelete(),
        ],
      ),
    );
  }

  Widget buildDelete() {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () {},
        child: Icon(
          FontAwesomeIcons.trashAlt,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget defaultRichTxt(String key, String value) {
    final size = MediaQuery.of(ctx).size;
    return Container(
      width: size.width / 3,
      child: RichText(
          maxLines: null,
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
