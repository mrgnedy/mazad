import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/auction_model.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

GlobalKey _finishAuctionKey = GlobalKey();

class AuctionPage extends StatelessWidget {
  final AuctionData auctionData;
  AuctionPage({Key key, this.auctionData}) : super(key: key);
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: operationBottomSheet(),
        appBar: PreferredSize(
            child: Parent(
              child: Image.asset('assets/icons/back.png'),
              style: ParentStyle()
                ..alignment.coordinate(0.8, 1)
                ..background.color(Colors.transparent),
              gesture: Gestures()
                ..onTap(() => ExtendedNavigator.rootNavigator.pop()),
            ),
            preferredSize: Size.fromHeight(50)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: [
              PhotoGallery(images: auctionData.images),
              Divider(),
              AuctionDetails(details: auctionData.desc),
              Divider(),
              TimeRemaining(
                  createdAt: auctionData.createdAt,
                  durationType: auctionData.duration),
              Divider(),
              Bidders(
                id: auctionData.id,
              )
            ]),
          ),
        ),
      ),
    );
  }

  final sellerRM = Injector.getAsReactive<SellerStore>();
  finishAuctionOnTap() {
    sellerRM.setState((state) => state.finishAuction(auctionData.id.toString()),
        onData: (_, store) {
      store.getMyAuctions().then((_) => ExtendedNavigator.rootNavigator.pop());
    }, onError: (context, e) {
      StylesD.showErrorDialog(context, e);
    });
  }

  Widget finishAuctionRebuilder() {
    return StatefulBuilder(
        key: _finishAuctionKey,
        builder: (context, snapshot) {
          return WhenRebuilder(
            models: [sellerRM],
            onIdle: () => finishAuctionWidget(),
            onWaiting: () => Container(height: 0),
            onData: (d) => finishAuctionWidget(),
            onError: (d) => finishAuctionWidget(),
          );
        });
  }

  Widget finishAuctionWidget() {
    return Container(
      height: size.height / 12,
      child: Txt('إنهاء المزاد',
          gesture: Gestures()..onTap(() => finishAuctionOnTap()),
          style: StylesD.mazadBtnStyle.clone()
            ..alignment.bottomCenter()
            ..margin(all: 8)
            ..height(size.height / 16)
            ..width(size.width)
            ..fontSize(22)),
    );
  }

  addOperation(context) {
    if (!_formKey.currentState.validate()) {
      return showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: size.height / 3,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(FontAwesomeIcons.exclamationCircle,
                      size: 80, color: ColorsD.main),
                  SizedBox(height: 25),
                  Txt(
                    'السعر الذى أدخلته أقل من السعر المتاح\nحاول مرة أخرى',
                    style: TxtStyle()
                      ..textAlign.center()
                      ..textColor(ColorsD.main)
                      ..fontSize(18),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    final bidderRM = Injector.getAsReactive<BidderStore>();
    _operationKey.currentState.setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      bidderRM.setState(
          (state) => state.addOperation(
              num.parse(priceCtrler.text.toString()), auctionData.id),
          onData: (context, data) => sellerRM.setState((state) {
                return state.getAuctionDetails(auctionData.id).then((_) {
                  _operationKey.currentState.setState(() {});
                });
              }, onData: (_, __) {
                Future.delayed(
                    Duration(milliseconds: 2),
                    () => _scrollController.animateTo(
                        _scrollController.position.minScrollExtent,
                        duration: Duration(seconds: 1),
                        curve: Curves.bounceIn));
              }));
      priceCtrler.clear();
    });
  }

  Widget operationBottomSheet() {
    bool isSeller = Injector.getAsReactive<AuthStore>().state.userType == '1';
    return auctionData.type == '1'
        ? null
        : BottomSheet(
            elevation: 10,
            onClosing: () {},
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            builder: (context) {
              return isSeller
                  ? auctionData.duration == '1'
                      ? Container()
                      : finishAuctionRebuilder()
                  : addOperationRebuilder();
            });
  }

  TextEditingController priceCtrler = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  Widget addOperationWidget(Widget icon) {
    return Container(
      height: size.height / 14.3,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Builder(builder: (context) {
          return Container(
            color: Colors.transparent,
            width: size.width * 0.72,
            child: Align(
              alignment: FractionalOffset(-1, 1),
              child: Form(
                key: _formKey,
                child: TetFieldWithTitle(
                  title: null,
                  inputType: TextInputType.number,
                  textEditingController: priceCtrler,
                  hint: 'أضف سعر',
                  icon: icon,
                  validator: priceValidator,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  GlobalKey _operationKey = GlobalKey();
  Widget addOperationRebuilder() {
    return Container(
      height: size.height / 14.3,
      child: OverflowBox(
        // maxHeight: size.height/14.3,

        minHeight: size.height / 14.3,
        child: StatefulBuilder(
            key: _operationKey,
            builder: (context, snapshot) {
              return WhenRebuilder<BidderStore>(
                  onIdle: () => addOperationWidget(addIconWidget()),
                  onData: (d) => addOperationWidget(addIconWidget()),
                  onError: (e) => addOperationWidget(addIconWidget()),
                  onWaiting: () => addOperationWidget(WaitingWidget()),
                  models: [
                    Injector.getAsReactive<BidderStore>(),
                  ]);
            }),
      ),
    );
  }

  Widget addIconWidget() {
    return Builder(builder: (context) {
      return InkWell(
          onTap: () => addOperation(context),
          child: Icon(
            Icons.add_circle,
            color: ColorsD.main,
          ));
    });
  }

  String priceValidator(String s) {
    final operations = Injector.getAsReactive<SellerStore>()
        .state
        .currentAuction
        .data
        .first
        .operations;
    List<int> operationPrices = List.generate(operations.length,
        (index) => int.parse(operations[index].price.toString()));
    num largest = operationPrices.isEmpty ? 0 : operationPrices.reduce(max);
    if (num.parse(priceCtrler.text.toString()) <= largest) return '';
  }
}

class TimeRemaining extends StatefulWidget {
  final String createdAt;
  final String durationType;

  const TimeRemaining({Key key, this.createdAt, this.durationType})
      : super(key: key);
  @override
  _TimeRemainingState createState() => _TimeRemainingState();
}

class _TimeRemainingState extends State<TimeRemaining> {
  @override
  Widget build(BuildContext context) {
    Duration duration;
    switch (widget.durationType) {
      case '1':
        duration = Duration(hours: 12);
        break;
      case '2':
        duration = Duration(days: 1);
        break;
      case '3':
        duration = Duration(days: 14);
        break;
      default:
        duration = Duration(days: 1);
    }

    final timeRemaining = DateTime.tryParse(
      widget.createdAt,
    ).add(duration).difference(DateTime.now());
    String time = timeRemaining.isNegative
        ? 'هذا المزاد منتهي'
        : '${timeRemaining.inDays}:${timeRemaining.inHours.remainder(24)}:${timeRemaining.inMinutes.remainder(60)}:${timeRemaining.inSeconds.remainder(60)}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          'assets/icons/timer.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
        Txt(
          time,
          style: TxtStyle()
            ..textColor(ColorsD.main)
            ..fontSize(20),
        )
      ],
    );
  }
}

Size size;

class Bidders extends StatefulWidget {
  final id;

  Bidders({Key key, this.id}) : super(key: key);

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
  @override
  void initState() {
    sellerRM.setState(
        (state) async => state.getAuctionDetails(widget.id).then((data) {
              if (data != null) sellerRM.resetToHasData();
              setState(() {});
              _finishAuctionKey.currentState.setState(() {});
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return biddersWhenRebuilder();
  }

  Widget onDataOperationWidget(List<Operations> operations) {
    if (operations == null || operations.isEmpty)
      return Center(child: Txt('لا توجد عمليات بعد'));
    else
      return Container(
        padding: EdgeInsets.only(bottom: size.height / 10),
        child: ListView.builder(
          itemCount: operations.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () async =>
                await bidderDetailsDialog(context, operations[index].userId),
            child: bidderCard(operations[index], index),
          ),
        ),
      );
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Parent(
            child: Image.asset('assets/icons/clear.png'),
            style: ParentStyle()
              ..alignmentContent.coordinate(0, 0)
              ..height(50)
              ..width(50)
              ..alignment.topLeft(),
            gesture: Gestures()
              ..onTap(() => ExtendedNavigator.rootNavigator.pop()),
          ),
          Txt(
            'تفاصيل المزايد',
            style: TxtStyle()
              ..textColor(ColorsD.main)
              ..fontSize(22),
          ),
          Container(
            height: size.height / 12,
            width: size.height / 12,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorsD.main),
                image: DecorationImage(
                    image:
                        AssetImage('${APIs.imageBaseUrl}${profile.data.image}'),
                    fit: BoxFit.cover)),
          ),
          Row(
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
          ),
        ],
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
    if(operation.userId == Injector.getAsReactive<AuthStore>()?.state?.credentialsModel?.data?.id)
    userName = 'أنت';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildBidDetails(userName, operation.price),
            buildCircleAvatar(operation.userImage),
            buildStatusDot(index == 0),
            Divider(thickness: 1, color: ColorsD.main)
          ],
        ),
      ],
    );
  }

  Widget buildCircleAvatar(String image) {
    return Container(
      height: size.height / 11,
      width: size.height / 11,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(
          imageUrl: '${APIs.imageBaseUrl}$image',
          placeholder: (_, __) => Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorsD.main),
                image: DecorationImage(
                    image: AssetImage('assets/icons/logo.png'),
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
    MaterialColor color = isCurrent ? Colors.green : Colors.red;
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

  Widget buildBidDetails(String name, String bid) {
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
        Txt(
          '$bid ريال',
          style: TxtStyle()
            ..border(all: 1, color: ColorsD.main)
            ..borderRadius(all: 12)
            ..padding(horizontal: 8, vertical: 5),
        )
      ],
    );
  }
}

class AuctionDetails extends StatelessWidget {
  final String details;

  const AuctionDetails({Key key, this.details}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Txt(':التفاصيل',
            style: TxtStyle()
              ..fontSize(18)
              ..textAlign.right()
              ..alignment.centerRight()),
        Txt(
          '$details',
          style: TxtStyle()
            ..fontSize(18)
            ..textAlign.right()
            ..alignment.centerRight()
            ..margin(right: 30),
        ),
      ],
    );
  }
}

class PhotoGallery extends StatefulWidget {
  final List<Images> images;

  const PhotoGallery({Key key, this.images}) : super(key: key);
  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<String> _imageUrls;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrls = List.generate(
        widget.images.length, (index) => widget.images[index].image);
    _imageUrls = _imageUrls.where((image) => image != null).toList();
    if (_imageUrls.isEmpty) _imageUrls = List.generate(3, (_) => null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: 1000,
      // height: 300,
      child: _imageUrls.isEmpty
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildImage(_imageUrls[currentIndex], false, true),
                Container(
                  // width: 1000,
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: List.generate(
                      _imageUrls.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          child: buildImage(
                              _imageUrls[index], currentIndex == index),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget buildImage(String imageUrl, bool isSelected,
      [bool isTitleImage = false]) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: isTitleImage ? size.width / 2 : size.width / 3.7,
          color: isSelected ? Colors.amber : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: ColorsD.main,
                height: size.height / 6,
                width: size.width * 0.5,
                child: imageUrl == null
                    ? noImageWidget()
                    : Image.network(
                        '${APIs.imageBaseUrl}$imageUrl',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget noImageWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: Colors.white,
          ),
          Txt('لا توجد صورة',
              style: TxtStyle()
                ..textColor(Colors.white)
                ..textAlign.center())
        ],
      ),
    );
  }
}
