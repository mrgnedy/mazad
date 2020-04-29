import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/router.gr.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/error_widget.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:toast/toast.dart';

class BidderHomePage extends StatelessWidget {
  Size size;
  @override
  Widget build(BuildContext context) {
    getAllAuctions();
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: Center(
          child: auctionsWidgetRebuilder(),
        ),
      ),
    );
  }

  Widget buildLiveAuctions(List<AuctionData> liveAuctions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Txt(
          'مباشرة',
          style: TxtStyle()
            ..textAlign.right()
            ..textColor(ColorsD.main)
            ..fontSize(20)
            ..width(size.width * 0.85)
            ..margin(top: 10, bottom: 10)
            ..alignment.center(),
        ),
        Container(
          height: size.height / 8,
          child: ListView.builder(
            itemCount: liveAuctions.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final image = liveAuctions[index].images.isEmpty
                  ? 'null'
                  : liveAuctions[index].images.first.image;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: StylesD.imageBuilder(
                    // height: size.height / 9,
                    width: size.height / 9.57,
                    image: '$image',
                    callback: () => ExtendedNavigator.rootNavigator.pushNamed(
                        Routes.auctionPage,
                        arguments: AuctionPageArguments(
                            auctionData: liveAuctions[index])),
                    shape: BoxShape.circle),
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildDailyAuctions(List<AuctionData> dailyAuctions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Txt(
          'عروض لمدة 24 ساعة',
          style: TxtStyle()
            ..textAlign.right()
            ..textColor(ColorsD.main)
            ..margin(top: 10, bottom: 10)
            ..fontSize(20)
            ..width(size.width * 0.85)
            ..alignment.center(),
        ),
        Container(
          height: size.width / 2.5,
          margin: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: dailyAuctions.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final image = dailyAuctions[index].images.isEmpty
                  ? 'null'
                  : dailyAuctions[index].images.first.image;
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: StylesD.imageBuilder(
                    callback: () => ExtendedNavigator.rootNavigator.pushNamed(
                        Routes.auctionPage,
                        arguments: AuctionPageArguments(
                            auctionData: dailyAuctions[index])),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    height: size.width / 2,
                    width: size.width / 2.2,
                    image: image),
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildWeeklyAuctions(List<AuctionData> weeklyAuctions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Txt(
          'عروض أسبوعية',
          style: TxtStyle()
            ..textAlign.right()
            ..textColor(ColorsD.main)
            ..margin(top: 10, bottom: 10)
            ..fontSize(20)
            ..width(size.width * 0.85)
            ..alignment.center(),
        ),
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: List.generate(weeklyAuctions.length, (index) {
            final image = weeklyAuctions[index].images.isEmpty
                ? 'null'
                : weeklyAuctions[index].images.first.image;
            return StylesD.imageBuilder(
                callback: () => ExtendedNavigator.rootNavigator.pushNamed(
                    Routes.auctionPage,
                    arguments: AuctionPageArguments(
                        auctionData: weeklyAuctions[index])),
                image: image,
                height: size.width / 4,
                width: size.width / 4,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12));
          }),
        )
      ],
    );
  }

  List<String> categoryList = [
    'الكل',
    'سيارات',
    'عقارات',
    'أجهزة كهربية',
  ];
  String selectedCategory = 'الكل';
  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height / 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: size.width * 0.85,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildCategoryDropDownBtn(),
                Txt(
                  'المزادات',
                  style: TxtStyle()
                    ..textColor(ColorsD.main)
                    ..fontSize(24),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategoryDropDownBtn() {
    return StatefulBuilder(builder: (context, setState) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButton(
            underline: Container(),
            value: selectedCategory,
            style: TextStyle(fontFamily: 'bein', color: Colors.grey[700]),
            items: List.generate(
              categoryList.length,
              (index) => DropdownMenuItem(
                child: Txt(
                  categoryList[index],
                  style: TxtStyle()..alignment.center(),
                ),
                value: categoryList[index],
              ),
            ),
            onChanged: (s) => setState(() => selectedCategory = s)),
      );
    });
  }

  final bidderRM = Injector.getAsReactive<BidderStore>();
  getAllAuctions() {
    bidderRM.setState((state) => state.getAllAuctions(),
        onData: (context, data) {
      // Injector.getAsReactive<SellerStore>().setState((state)=>state.)
    }, onError: (context, error) {
      print(error);
      Toast.show('${error.toString()}', context, duration: Toast.LENGTH_LONG);
    });
  }

  Widget auctionsWidget(AllAuctions allAuctions) {
    return SingleChildScrollView(
      // width: size.width * 0.85,
      child: Column(
        children: <Widget>[
          buildLiveAuctions(allAuctions.mobasherdata),
          buildDailyAuctions(allAuctions.daysdata),
          buildWeeklyAuctions(allAuctions.weeksdata)
        ],
      ),
    );
  }

  Widget auctionsWidgetRebuilder() {
    return WhenRebuilder<BidderStore>(
        onIdle: () => bidderRM.state.allAuctions != null
            ? auctionsWidget(bidderRM.state.allAuctions.data)
            : WaitingWidget(),
        onWaiting: () => bidderRM.state.allAuctions != null
            ? auctionsWidget(bidderRM.state.allAuctions.data)
            : WaitingWidget(),
        onError: (e) => bidderRM.state.allAuctions != null
            ? auctionsWidget(bidderRM.state.allAuctions.data)
            : OnErrorWidget(e.toString(), getAllAuctions),
        onData: (d) => auctionsWidget(d.allAuctions.data),
        models: [bidderRM]);
  }
}
