import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/my_auctions.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/auction_card.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../router.gr.dart';

class SellerHomePage extends StatelessWidget {
  @override
  // bool isEmpty = true;
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 25, right: 18),
              child: FloatingActionButton(
                  backgroundColor: ColorsD.main,
                  child: Icon(
                    Icons.add,
                    size: 35,
                  ),
                  onPressed: () => ExtendedNavigator.rootNavigator
                      .pushNamed(Routes.newAuction))),
          body: Directionality(
              textDirection: TextDirection.ltr, child: whenAuctionRebuilder())),
    );
  }

  final sellerRM = Injector.getAsReactive<SellerStore>();
  Widget whenAuctionRebuilder() {
    sellerRM.setState((state) => state.getMyAuctions());
    return WhenRebuilder<SellerStore>(
        onIdle: () => sellerRM.state.auctionsModel == null
            ? NoAuctions()
            : AuctionsTabs(allAuctions: sellerRM.state.auctionsModel.data),
        onWaiting: () => sellerRM.state.auctionsModel == null
            ? WaitingWidget()
            : AuctionsTabs(
                allAuctions: sellerRM.state.auctionsModel.data,
              ),
        onError: (e) => sellerRM.state.auctionsModel == null
            ? NoAuctions()
            : AuctionsTabs(allAuctions: sellerRM.state.auctionsModel.data),
        onData: (data) => AuctionsTabs(
              allAuctions: data.auctionsModel.data,
            ),
        models: [sellerRM]);
  }
}

class AuctionsTabs extends StatefulWidget {
  final MyAuctions allAuctions;

  const AuctionsTabs({Key key, this.allAuctions}) : super(key: key);
  @override
  _AuctionsTabsState createState() => _AuctionsTabsState();
}

class _AuctionsTabsState extends State<AuctionsTabs>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      current = tabController.index;
      setState(() {});
      print(current);
    });
    // TODO: implement initState
    super.initState();
  }

  int current = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 30),
        Container(
          width: size.width * 0.7,
          child: TabBar(
            labelColor: Colors.white,
            labelStyle: TextStyle(
                fontFamily: 'bein', fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelColor: ColorsD.main,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 0,
            controller: tabController,
            indicatorPadding: EdgeInsets.all(0),
            labelPadding: EdgeInsets.zero,
            indicator: BoxDecoration(
              color: ColorsD.main,
              borderRadius: BorderRadius.horizontal(
                  left: current == 0 ? Radius.circular(12) : Radius.zero,
                  right: current == 1 ? Radius.circular(12) : Radius.zero),
            ),
            tabs: [
              tabItem('مزادات قائمة', true),
              tabItem('مزادات منتهية', false),
            ],
          ),
        ),
        SizedBox(height: 30),
        Expanded(
            child: TabBarView(
          controller: tabController,
          children: <Widget>[
            AvailableAuctions(
              currentAuctions: widget.allAuctions.intialactions,
            ),
            AvailableAuctions(
              currentAuctions: widget.allAuctions.finishactions,
            ),
          ],
        ))
      ],
    );
  }

  Widget tabItem(String title, bool isFirst) {
    return Container(
      // width: 100,
      height: 75,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
              left: isFirst ? Radius.circular(12) : Radius.circular(0),
              right: isFirst ? Radius.circular(0) : Radius.circular(12)),
          border: Border.all(color: ColorsD.main, width: 3)),
      child: Center(child: Txt('$title')),
    );
  }
}

class AvailableAuctions extends StatelessWidget {
  final List<AuctionData> currentAuctions;

  const AvailableAuctions({Key key, this.currentAuctions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          currentAuctions.length,
          (index) => AuctionCard(
            auctionData: currentAuctions[index],
          ),
        ),
      ),
    );
  }
}

class NoAuctions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/icons/auction.png'),
          Txt(
            'لا توجد لديك مزادات حالية',
            style: TxtStyle()
              ..textColor(ColorsD.main)
              ..fontSize(18)
              ..textAlign.center()
              ..margin(all: 12),
          ),
          Txt(
            'إضافة',
            style: StylesD.mazadBtnStyle.clone()
              ..height(size.height / 17)
              ..fontSize(18)
              ..width(size.width * 0.3),
          ),
        ],
      ),
    );
  }
}
