import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/auction_model.dart';
import 'package:mazad/data/models/categories_model.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:toast/toast.dart';

class Bidders extends StatefulWidget {
  final id;
  final scrollController;
  final finishAuctionKey;

  Bidders({Key key, this.id, this.finishAuctionKey, this.scrollController})
      : super(key: key);

  @override
  _BiddersState createState() => _BiddersState();
}

class _BiddersState extends State<Bidders> {
  @override
  void dispose() {
    // TODO: implement dispose
    sellerRM.state.currentAuction = null;
    super.dispose();
  }

  final sellerRM = Injector.getAsReactive<SellerStore>();
  AuctionD get currentAuction => sellerRM.state.currentAuction.data.first;
  @override
  void initState() {
    // sellerRM.setState(
    //     (state) async => state.getAuctionDetails(widget.id).then((data) {
    //           if (data != null) sellerRM.resetToHasData();
    //           setState(() {});
    //           widget.finishAuctionKey.currentState.setState(() {});
    //         }));
    super.initState();
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return biddersWhenRebuilder();
  }

  // List editableOpList = [];
  Widget onDataOperationWidget(List<Operations> operations) {
    if (operations == null || operations.isEmpty)
      return Center(child: Txt('لا توجد عمليات بعد'));
    else {
      // editableOpList = List.generate(operations.length, (op)=> op.);
      priceCtrler.text =
          sellerRM.state.currentAuction?.data?.first?.operations?.first?.price;
      canEditOP =
          operations.first.userId == authRM.state.credentialsModel?.data?.id
              ? canEditOP == true ? true : false
              : null;
      return Container(
        padding: EdgeInsets.only(bottom: size.height / 10),
        child: ListView.builder(
          itemCount: operations.length,
          controller: widget.scrollController,
          // physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () async => authRM.state.credentialsModel?.data?.id == currentAuction.auction.userId?
                await bidderDetailsDialog(context, operations[index].userId): {},
            child: bidderCard(operations[index], index),
          ),
        ),
      );
    }
  }

  Widget biddersWhenRebuilder() {
    return WhenRebuilder<SellerStore>(
        onIdle: () => Container(),
        onWaiting: () => sellerRM.state.currentAuction != null
            ? onDataOperationWidget(
                sellerRM.state.currentAuction?.data?.first?.operations)
            : WaitingWidget(),
        dispose: (context, store) => store.state.currentAuction = null,
        onError: (e) => onDataOperationWidget(
            sellerRM.state.currentAuction?.data?.first?.operations),
        onData: (data) =>
            onDataOperationWidget(data.currentAuction.data?.first?.operations),
        models: [sellerRM]);
  }

  Future bidderDetailsDialog(BuildContext context, int id) async {
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: size.height / 2.4,
          child: Center(child: bidderDetailsDialogRebuilder(id)),
        ),
      ),
    );
  }

  getBidderDetails(int id) {
    print(id);
    final authRM = Injector.getAsReactive<AuthStore>();
    authRM.setState(
      (state) => state.getProfile(id),
      onError: (_, e) {
        print('$e');
      },
    );
  }

  Widget bidderDetailsWidget() {
    final profile =
        Injector.getAsReactive<AuthStore>().state.currentBidderProfile;
    return SingleChildScrollView(
      child: Container(
        
        height: size.height/2.6,
        // color: Colors.red,
              child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Parent(
            //   child: Image.asset('assets/icons/clear.png'),
            //   style: ParentStyle()
            //     ..alignmentContent.coordinate(1, 1)
            //     ..height(50)
            //     ..width(50)
            //     ..alignment.topLeft(),
            //   gesture: Gestures()
            //     ..onTap(() => ExtendedNavigator.rootNavigator.pop()),
            // ),
            Txt(
              'تفاصيل المزايد',
              style: TxtStyle()
                ..textColor(ColorsD.main)
                ..fontSize(22),
            ),
            Container(
              height: size.height / 10,
              width: size.height / 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorsD.main),
                  image: DecorationImage(
                      image: NetworkImage(
                          '${APIs.imageProfileUrl}${profile.data.image}'),
                      fit: BoxFit.cover)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children:[Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.person,
                  color: Colors.transparent,
                ),
                richText('إسم المستخدم', '${profile.data.name}'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.phone),
                richText('رقم الجوال', '${profile.data.phone}'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.location_on),
                richText('العنوان', '${profile.data.address}'),
              ],
            ),])
          ],
        ),
      ),
    );
  }

  Widget bidderDetailsDialogRebuilder(int id) {
    getBidderDetails(id);
    return WhenRebuilder(
        onIdle: () => Container(),
        onWaiting: () => WaitingWidget(),
        onError: (e) => Txt('تعذر احضار بيانات المزايد'),
        onData: (data) => bidderDetailsWidget(),
        models: [Injector.getAsReactive<AuthStore>()]);
  }

  Widget richText(String mainText, String subText) {
    return Parent(
      // alignment: Alignment.,
      style: ParentStyle()
        ..alignment.centerRight()
        ..margin(left: 12)
        ..width(size.width * 0.6)
        ..alignment.center(),
      child: RichText(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
                text: '$mainText: ',
                style: TextStyle(
                    color: ColorsD.main, fontFamily: 'bein', fontSize: 16)),
            TextSpan(
                text: '$subText',
                style: TextStyle(
                    height: 1.5,
                    color: Colors.grey[800],
                    fontFamily: 'bein',
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget bidderCard(Operations operation, int index) {
    String userName = operation.userName;
    if (operation.userId ==
        Injector.getAsReactive<AuthStore>()?.state?.credentialsModel?.data?.id)
      userName = 'أنت';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildEditBtn(index),
            buildBidDetails(userName, operation.price, index == 0),
            buildCircleAvatar(operation.userImage),
            buildStatusDot(index == 0),
            Divider(thickness: 1, color: ColorsD.main)
          ],
        ),
      ],
    );
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  bool canEditOP;
  Widget buildEditBtn(int index) {
    return canEditOP != null && index == 0
        ? editPriceRebuilder()
        : hasBalanceWidget(index);
  }

  Widget hasBalanceWidget(int index) {
    bool shouldShow = false;
    return Visibility(
        visible: !(currentAuction.operations[index].balance.contains('null') ||
            currentAuction.operations[index].balance == '0'),
        child: StatefulBuilder(builder: (context, stateSet) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SimpleTooltip(
                child: InkWell(
                    onTap: () => stateSet(() => shouldShow = !shouldShow),
                    child: Image.asset('assets/icons/blackcheck.png',
                        color: Colors.teal, height: 45, width: 45)),
                maxHeight: 40,
                maxWidth: 120,
                arrowTipDistance: 5,
                arrowLength: 0,
                // arrowBaseWidth: ,
                hideOnTooltipTap: true,
                tooltipDirection: TooltipDirection.up,
                backgroundColor: ColorsD.main,
                borderColor: Colors.white,
                minimumOutSidePadding: 10,
                ballonPadding: EdgeInsets.zero,
                content: Material(
                  color: ColorsD.main,
                  child: Txt(
                      'قيمة التأمين: ${currentAuction.operations[index].balance} ريال',
                      style: TxtStyle()
                        ..textDirection(TextDirection.rtl)
                        ..fontSize(12)
                        ..textColor(Colors.white)
                        ..alignment.center()
                        ..background.color(ColorsD.main)),
                ),

                show: shouldShow,
              ),
            ),
          );
        }));
  }

  Widget buildCircleAvatar(String image) {
    return Container(
      height: size.height / 11,
      width: size.height / 11,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(
          imageUrl: '${APIs.imageProfileUrl}$image',
          placeholder: (_, __) => Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorsD.main),
                image: DecorationImage(
                    image: image.contains('null')
                        ? AssetImage('assets/icons/logo.png')
                        : NetworkImage('${APIs.imageProfileUrl}$image'),
                    fit: BoxFit.cover)),
          ),
          imageBuilder: (_, imageB) => Container(
            height: size.height / 15,
            decoration: BoxDecoration(
                image: DecorationImage(image: imageB, fit: BoxFit.cover),
                shape: BoxShape.circle,
                border: Border.all(color: ColorsD.main)),
          ),
        ),
      ),
    );
  }

  Widget buildStatusDot(bool isCurrent) {
    MaterialColor color = isCurrent &&
            sellerRM.state.currentAuction.data.first.auction.type == '1'
        ? Colors.amber
        : isCurrent ? Colors.green : Colors.red;
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
              colors: [
                // stateColorsList[occasion.isAccepted],
                // Colors.white70,
                color.withAlpha(128),
                color[800]
              ],
              tileMode: TileMode.clamp,
              stops: [0.3, 0.9]),
          color: Colors.green),
    );
  }

  TextEditingController priceCtrler = TextEditingController();
  FocusNode editPriceFocusNode = FocusNode();
  Widget buildPriceWidget(String bid, bool isFirst) {
    // priceCtrler.text =
    // bool cantEdit = canEditOP == null;
    return TextFormField(
      controller: !isFirst ? null : priceCtrler,
      focusNode: !isFirst ? null : editPriceFocusNode,
      enabled: canEditOP == true,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.number,
      initialValue: !isFirst ? bid : null,
      decoration: InputDecoration(
        prefix: Text('ريال',
            style: TextStyle(
              height: 2,
              color: Colors.black,
            )),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsD.main,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget buildBidDetails(String name, String bid, bool isFirst) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RichText(
          textDirection: TextDirection.rtl,
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'إسم المستخدم: ',
                  style: TextStyle(color: ColorsD.main, fontFamily: 'bein')),
              TextSpan(
                  text: '$name',
                  style: TextStyle(color: Colors.black, fontFamily: 'bein')),
            ],
          ),
        ),
        Container(
            width: size.width * 0.55,
            height: size.height / 15,
            child: buildPriceWidget(bid, isFirst)),
      ],
    );
  }

  final bidderRM = Injector.getAsReactive<BidderStore>();
  editPrice() {
    final auctionData = sellerRM.state.currentAuction.data.first;
    final initPrice = auctionData.auction.intialPrice == null || auctionData.auction.intialPrice.contains('null') ? 0 : num.parse(auctionData.auction.intialPrice);
    final listPrices = List.generate((auctionData.operations.length),
        (index) => num.parse(auctionData.operations[index].price))
      ..removeAt(0);
    final lastPrice = listPrices.isEmpty? initPrice: listPrices.reduce(max);
    // List<Category> allAqarCats = bidderRM.state.categoriesModel.data
    //     .where((cat) => cat.name.contains('عقار'))
    //     .toList();
    // List<int> aqarCatIDs =
    //     List.generate((allAqarCats.length), (index) => allAqarCats[index].id);
    // bool isAqar = aqarCatIDs.contains(
    //     int.parse(sellerRM.state.currentAuction.data.first.auction.catId));
    num maxValue = auctionData.auction.maxvalue.contains('null')
        ? 1000 ^ 10
        : num.parse(auctionData.auction.maxvalue);
    num minValue = auctionData.auction.minvalue.contains('null')
        ? 0
        : num.parse(auctionData.auction.minvalue);
    num allowedBid = maxValue + lastPrice;
    num price = num.parse(priceCtrler.text);
    if (initPrice > price && listPrices.isEmpty) {
      AlertDialogs.failed(
          context: context,
          content:
              'السعر الذي أدخلته غير مناسب\nالسعر الابتدائي: $initPrice');
      return;
    }
    if (lastPrice + minValue > price || price > allowedBid) {
      AlertDialogs.failed(
          context: context,
          content:
              'السعر الذي أدخلته غير مناسب\nأقل قيمة للزيادة: $minValue\nأكبر قيمة للزيادة: $maxValue');
      return;
    }
    canEditOP = false;
    int opID = auctionData.operations.first.id;
    sellerRM.setState((state) => state.editPrice(opID, priceCtrler.text),
        onData: (context, data) {
      sellerRM.setState((state) => state.getAuctionDetails(widget.id));
      Toast.show('تم تعديل سعرك بنجاح', context);
    });
  }

  editPriceWidget() {
    return Expanded(
      child: canEditOP == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Txt(
                  'رجوع',
                  gesture: Gestures()
                    ..onTap(() {
                      sellerRM.setState((state) => state
                          .getAuctionDetails(widget.id)
                          .then((_) => setState(() {})));
                      canEditOP = false;
                      setState(() {});
                    }),
                  style: StylesD.mazadBorderdBtnStyle.clone()
                    ..fontSize(12)
                    ..height(size.height / 20)
                    ..margin(all: 0)
                    ..width(size.width * 0.15),
                ),
                SizedBox(height: 10),
                Txt(
                  'تأكيد',
                  gesture: Gestures()..onTap(editPrice),
                  style: StylesD.mazadBtnStyle.clone()
                    ..fontSize(12)
                    ..margin(all: 0)
                    ..height(size.height / 20)
                    ..width(size.width * 0.15),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                      onPressed: () {
                        print(canEditOP);
                        // FocusScope.of(context).requestFocus(editPriceFocusNode);
                        canEditOP = true;
                        setState(() {});
                        Future.delayed(Duration(milliseconds: 10),
                            () => editPriceFocusNode.requestFocus());
                        // editPriceFocusNode.requestFocus();
                      },
                      icon: Icon(Icons.edit))),
            ),
    );
  }

  editPriceRebuilder() {
    return WhenRebuilder(
        onIdle: () => editPriceWidget(),
        onWaiting: () => WaitingWidget(),
        onError: (e) => editPriceWidget(),
        onData: (data) => editPriceWidget(),
        models: [sellerRM]);
  }
}
