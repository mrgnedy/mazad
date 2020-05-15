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
import 'package:mazad/presentation/ui/drawer/drawer.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:mazad/presentation/router.gr.dart';

import 'bidders.dart';
import 'initPrice_N_city.dart';

GlobalKey _finishAuctionKey = GlobalKey();

class AuctionPage extends StatelessWidget {
  final AuctionData auctionData;
  bool isNegative;
  String remainingTime;
  AuctionPage({Key key, this.auctionData}) : super(key: key) {
    detailsCtrler = TextEditingController(text: auctionData.desc);
  }
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    remainingTime = getTime();
    return SafeArea(
      child: Scaffold(
        bottomSheet: operationBottomSheet(),
        appBar: BackAppBar(
            size.height / 9,
            Txt(
              'تفاصيل المزاد',
              style: TxtStyle()
                ..textColor(ColorsD.main)
                ..fontSize(22),
            )),
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Opacity(
                opacity: .1,
                child: Align(
                  child: Image.asset('assets/icons/logo.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(children: [
                    PhotoGallery(images: auctionData.images),
                    Divider(),
                    auctionDetails(),
                    // AuctionDetails(
                    //   details: auctionData.desc,
                    //   auctionID: auctionData.id,
                    //   isMyAuction: authRM.state.credentialsModel?.data?.id ==
                    //       auctionData.userId,
                    // ),
                    Divider(),
                    InitPriceAndCity(price: auctionData.intialPrice, cityID: auctionData.cityID,),
                    TimeRemaining(timeRemaining: remainingTime),
                    Divider(),
                    Bidders(
                        id: auctionData.id, finishAuctionKey: _finishAuctionKey)
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTime() {
    final timeRemaining = DateTime.tryParse(
      auctionData.deletetime,
    ).toLocal().difference(DateTime.now().add(Duration(hours: -3)));
    isNegative = timeRemaining.isNegative;
    String time = timeRemaining.isNegative
        ? 'هذا المزاد منتهي'
        : '${timeRemaining.inDays}:${timeRemaining.inHours.remainder(24)}:${timeRemaining.inMinutes.remainder(60)}:${timeRemaining.inSeconds.remainder(60)}';
    return time;
  }

  bool isEdit = false;
  final authRM = Injector.getAsReactive<AuthStore>();
  Widget auctionDetails() {
    bool isMyAuction =
        authRM.state.credentialsModel?.data?.id == auctionData.userId;
    print(detailsCtrler.text);
    return StatefulBuilder(
        key: detailsKey,
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Visibility(
                    visible: isMyAuction,
                    child: IconButton(
                        onPressed: () => setState(() => isEdit = !isEdit),
                        icon: Icon(Icons.edit, color: ColorsD.main)),
                  ),
                  Txt(':التفاصيل',
                      style: TxtStyle()
                        ..fontSize(20)
                        ..textColor(ColorsD.main)
                        ..textAlign.right()
                        ..alignment.centerRight()),
                ],
              ),
              Container(
                width: size.width * 0.82,
                child: TextField(
                  enabled: isEdit,
                  maxLines: null,
                  controller: detailsCtrler,
                  textAlign: TextAlign.right,
                  style:
                      TextStyle(fontSize: 18, fontFamily: 'bein', height: 1.7),
                  decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(right: 30),
                      disabledBorder: InputBorder.none,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              Visibility(
                visible: isEdit,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Txt(
                      'رجوع',
                      gesture: Gestures()
                        ..onTap(() => setState(() {
                              detailsCtrler.text = auctionData.desc;
                              isEdit = false;
                            })),
                      style: StylesD.mazadBorderdBtnStyle.clone()
                        ..fontSize(14)
                        ..height(size.height / 18)
                        ..width(size.width * 0.3),
                    ),
                    SizedBox(width: 10),
                    Txt(
                      'تأكيد',
                      gesture: Gestures()..onTap(editDetails),
                      style: StylesD.mazadBtnStyle.clone()
                        ..fontSize(14)
                        ..height(size.height / 18)
                        ..width(size.width * 0.3),
                    ),
                  ],
                ),
              ),
              // Txt(
              //   '${widget.detailsCtrler.text}',
              //   style: TxtStyle()
              //     ..fontSize(18)
              //     ..textAlign.right()
              //     ..alignment.centerRight()
              //     ..margin(right: 30),
              // ),
            ],
          );
        });
  }

  final sellerRM = Injector.getAsReactive<SellerStore>();
  GlobalKey detailsKey = GlobalKey();
  TextEditingController detailsCtrler;
  editDetails() {
    detailsKey.currentState.setState(() => isEdit = false);
    sellerRM.setState(
        (state) => state.editDetails(auctionData.id, detailsCtrler.text),
        onData: (context, data) {
      // tempDetails = detailsCtrler.text;
    }, onError: (context, error) {
      detailsCtrler.text = auctionData.desc;
      print(error);
      AlertDialogs.failed(
          context: context,
          content: 'قد تم المزايدة على هذا المزاد\nلا يمكنك تعديله');
    });
  }

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
    int myID =
        Injector.getAsReactive<AuthStore>().state.credentialsModel?.data?.id;
    bool isMyAuction = myID == auctionData.userId;
    return auctionData.type == '1' || isNegative
        ? null
        : BottomSheet(
            elevation: 10,
            onClosing: () {},
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            builder: (context) {
              return isMyAuction
                  ? finishAuctionRebuilder()
                  : addOperationRebuilder();
            });
  }

  TextEditingController priceCtrler = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  Widget addOperationWidget(Widget icon) {
    return Container(
      height: size.height / 13,
      child: Align(
        alignment: Alignment.topCenter,
        child: Builder(builder: (context) {
          return Container(
            color: Colors.transparent,
            width: size.width * 0.72,
            child: Align(
              alignment: FractionalOffset(-1, 0.5),
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
      height: size.height / 13,
      child: OverflowBox(
        // maxHeight: size.height/14.3,

        minHeight: size.height / 13,
        child: StatefulBuilder(
            key: _operationKey,
            builder: (context, snapshot) {
              return WhenRebuilder<BidderStore>(
                  onIdle: () => addOperationWidget(addIconWidget()),
                  onData: (d) => addOperationWidget(addIconWidget()),
                  onError: (e) => addOperationWidget(addIconWidget()),
                  onWaiting: () => addOperationWidget(
                      Container(width: 50, child: WaitingWidget())),
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
          onTap: () {
            if (Injector.getAsReactive<AuthStore>().state.credentialsModel ==
                null)
              AlertDialogs.failed(
                      context: context, content: 'من فضلك سجل الدخول أولاً')
                  .then((action) {
                if (action == true)
                  ExtendedNavigator.rootNavigator.pushNamed(Routes.authPage);
              });
            else
              addOperation(context);
          },
          child: Icon(
            Icons.add_circle,
            color: ColorsD.main,
          ));
    });
  }

  String priceValidator(String s) {
    num initPrice = auctionData.intialPrice.contains('null')
        ? 0
        : num.parse(auctionData.intialPrice);
    num price = num.parse(priceCtrler.text.toString());
    final operations = Injector.getAsReactive<SellerStore>()
        .state
        .currentAuction
        .data
        .first
        .operations;
    List<int> operationPrices = List.generate(operations.length,
        (index) => int.parse(operations[index].price.toString()));
    num largest = operationPrices.isEmpty ? 0 : operationPrices.reduce(max);
    if (price <= largest || price < initPrice) return '';
  }
}

class TimeRemaining extends StatefulWidget {
  final String timeRemaining;

  const TimeRemaining({
    Key key,
    this.timeRemaining,
  }) : super(key: key);
  @override
  _TimeRemainingState createState() => _TimeRemainingState();
}

class _TimeRemainingState extends State<TimeRemaining> {
  @override
  Widget build(BuildContext context) {
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
          widget.timeRemaining,
          style: TxtStyle()
            ..textColor(ColorsD.main)
            ..fontSize(20),
        )
      ],
    );
  }
}

Size size;

// String tempDetails;

// class AuctionDetails extends StatefulWidget {
//   TextEditingController detailsCtrler;
//   String details;
//   final int auctionID;
//   final bool isMyAuction;

//   AuctionDetails({Key key, this.details, this.auctionID, this.isMyAuction})
//       : super(key: key) {
//     tempDetails = tempDetails ?? details;
//     detailsCtrler = TextEditingController(text: tempDetails);
//   }

//   @override
//   _AuctionDetailsState createState() => _AuctionDetailsState();
// }

// class _AuctionDetailsState extends State<AuctionDetails> {
//   bool isEdit = false;

//   @override
//   Widget build(BuildContext context) {
//     print(detailsCtrler.text);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Visibility(
//               visible: widget.isMyAuction,
//               child: IconButton(
//                   onPressed: () => setState(() => isEdit = true),
//                   icon: Icon(Icons.edit, color: ColorsD.main)),
//             ),
//             Txt(':التفاصيل',
//                 style: TxtStyle()
//                   ..fontSize(20)
//                   ..textColor(ColorsD.main)
//                   ..textAlign.right()
//                   ..alignment.centerRight()),
//           ],
//         ),
//         Container(
//           width: size.width * 0.82,
//           child: TextField(
//             enabled: isEdit,
//             maxLines: null,
//             controller: detailsCtrler,
//             textAlign: TextAlign.right,
//             style: TextStyle(fontSize: 18, fontFamily: 'bein'),
//             decoration: InputDecoration(
//                 // contentPadding: EdgeInsets.only(right: 30),
//                 ),
//           ),
//         ),
//         Visibility(
//           visible: isEdit,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Txt(
//                 'رجوع',
//                 gesture: Gestures()
//                   ..onTap(() => setState(() {
//                         detailsCtrler.text = tempDetails;
//                         isEdit = false;
//                       })),
//                 style: StylesD.mazadBorderdBtnStyle.clone()
//                   ..fontSize(14)
//                   ..height(size.height / 18)
//                   ..width(size.width * 0.3),
//               ),
//               Txt(
//                 'تأكيد',
//                 gesture: Gestures()..onTap(editDetails),
//                 style: StylesD.mazadBtnStyle.clone()
//                   ..fontSize(14)
//                   ..height(size.height / 18)
//                   ..width(size.width * 0.3),
//               ),
//             ],
//           ),
//         ),
//         // Txt(
//         //   '${widget.detailsCtrler.text}',
//         //   style: TxtStyle()
//         //     ..fontSize(18)
//         //     ..textAlign.right()
//         //     ..alignment.centerRight()
//         //     ..margin(right: 30),
//         // ),
//       ],
//     );
//   }

//   final sellerRM = Injector.getAsReactive<SellerStore>();

//   editDetails() {
//     setState(() => isEdit = false);
//     sellerRM.setState(
//         (state) => state.editDetails(widget.auctionID, detailsCtrler.text),
//         onData: (context, data) {
//       tempDetails = detailsCtrler.text;
//     }, onError: (context, error) {
//       detailsCtrler.text = tempDetails;
//       print(error);
//       AlertDialogs.failed(
//           context: context,
//           content: 'قد تم المزايدة على هذا المزاد\nلا يمكنك تعديله');
//     });
//   }
// }


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
    _imageUrls = widget.images == null
        ? []
        : List.generate(
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
          width: isTitleImage ? size.width : size.width / 3.7,
          color: isSelected ? Colors.amber : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: ColorsD.main,
                height: size.height / 4,
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
