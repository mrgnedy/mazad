import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/auction_model.dart';
import 'package:mazad/data/models/categories_model.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/ui/auctionDetails/seller_details.dart';
import 'package:mazad/presentation/ui/drawer/drawer.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:mazad/rate_app.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:mazad/presentation/router.gr.dart';

import 'bidders.dart';
import 'initPrice_N_city.dart';

GlobalKey _finishAuctionKey = GlobalKey();

class AuctionPage extends StatefulWidget {
  AuctionData auctionData;

  AuctionPage({Key key, this.auctionData}) : super(key: key) {
    detailsCtrler = TextEditingController(text: auctionData.desc);
  }
  @override
  _AuctionPageState createState() => _AuctionPageState();

  TextEditingController detailsCtrler;
}

class _AuctionPageState extends State<AuctionPage> {
  bool isNegative;

  String remainingTime;

  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    authRM.setState((state) => state
        .getProfile(widget.auctionData.userId)
        .then((profile) => authRM.state.currentSellerProfile = profile));
    sellerRM.setState(
        (state) => state.getAuctionDetails(widget.auctionData.id).then((data) {
              print('THIS IS AUCTION DETAILS $data');
              if (data != null) sellerRM.resetToHasData();
              setState(() {
                widget.auctionData = data.data.first.auction;
              });
              _finishAuctionKey.currentState.setState(() {});
            }));
    content =
        'السعر الذي أدخلته غير مناسب\nأقل قيمة للزيادة: ${widget.auctionData.minvalue}\nأكبر قيمة للزيادة: ${widget.auctionData.maxvalue}';
    super.initState();
  }

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
                  // controller: _scrollController,
                  child: Column(children: [
                    PhotoGallery(images: widget.auctionData.images),
                    Divider(),
                    Hero(tag: 'sellerHero', child: SellerInfo()),
                    // AuctionDetails(
                    //   details: auctionData.desc,
                    //   auctionID: auctionData.id,
                    //   isMyAuction: authRM.state.credentialsModel?.data?.id ==
                    //       auctionData.userId,
                    // ),
                    Divider(),
                    InitPriceAndCity(
                      price: widget.auctionData.intialPrice,
                      cityID: widget.auctionData.cityID,
                    ),
                    Divider(),
                    auctionDetails(),
                    Divider(),
                    TimeRemaining(timeRemaining: remainingTime),
                    Divider(),
                    Bidders(
                        scrollController: _scrollController,
                        id: widget.auctionData.id,
                        finishAuctionKey: _finishAuctionKey)
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
      widget.auctionData.deletetime,
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
        authRM.state.credentialsModel?.data?.id == widget.auctionData.userId;
    print(widget.detailsCtrler.text);
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
                  controller: widget.detailsCtrler,
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
                              widget.detailsCtrler.text =
                                  widget.auctionData.desc;
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

  editDetails() {
    detailsKey.currentState.setState(() => isEdit = false);
    sellerRM.setState(
        (state) =>
            state.editDetails(widget.auctionData.id, widget.detailsCtrler.text),
        onData: (context, data) {
      // tempDetails = detailsCtrler.text;
    }, onError: (context, error) {
      widget.detailsCtrler.text = widget.auctionData.desc;
      print(error);
      AlertDialogs.failed(
          context: context,
          content: 'قد تم المزايدة على هذا المزاد\nلا يمكنك تعديله');
    });
  }

  finishAuctionOnTap() {
    sellerRM.setState(
        (state) => state.finishAuction(widget.auctionData.id.toString()),
        onData: (_, store) {
      Future.delayed(
          Duration(seconds: 1), () => AppRate.rateIfAvailable(context));

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
                    content,
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
            num.parse(priceCtrler.text.toString()), widget.auctionData.id),
        onError: (context, error) {
          print(error.toString());
          AlertDialogs.failed(context: context, content: error.toString());
        },
        onData: (context, data) => sellerRM.setState(
          (state) {
            return state.getAuctionDetails(widget.auctionData.id).then(
              (_) {
                _operationKey.currentState.setState(() {});
              },
            );
          },
          onData: (_, __) {
            setState(() {});
            Future.delayed(
                Duration(seconds: 1), () => AppRate.rateIfAvailable(context));
            Future.delayed(
                Duration(milliseconds: 2),
                () => _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: Duration(seconds: 1),
                    curve: Curves.bounceIn));
          },
        ),
      );
      priceCtrler.clear();
    });
  }

  Widget operationBottomSheet() {
    int myID =
        Injector.getAsReactive<AuthStore>().state.credentialsModel?.data?.id;
    bool isMyAuction = myID == widget.auctionData.userId;
    return widget.auctionData.type == '1' || isNegative
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

  String content;
  AuctionD get currentAuction => sellerRM.state.currentAuction.data.first;
  String priceValidator(String s) {
    num initPrice = widget.auctionData.intialPrice.contains('null')
        ? 1
        : num.parse(currentAuction.auction.intialPrice);
    initPrice = initPrice == 0 ? 1 : initPrice;
    num price = num.parse(priceCtrler.text.toString());
    final operations = currentAuction.operations;
    List<int> operationPrices = List.generate(operations.length,
        (index) => int.parse(operations[index].price.toString()));
    num largest =
        operationPrices.isEmpty ? initPrice - 1 : operationPrices.reduce(max);
    // final bidderRM=Injector.getAsReactive<BidderStore>();
    // List<Category> allAqarCats = bidderRM.state.categoriesModel.data.where((cat)=>cat.name.contains('عقار')).toList();
    // List<int> aqarCatIDs = List.generate((allAqarCats.length), (index)=>allAqarCats[index].id);
    // bool isAqar = aqarCatIDs.contains(int.parse(widget.auctionData.catId));
    // print('ALL AQAR IDS $aqarCatIDs');
    // print('THIS AQAR ID ${widget.auctionData.catId}');
    // print('IS AQAR: $isAqar');
    num maxValue = currentAuction.auction.maxvalue.contains('null')
        ? 1000 ^ 10
        : num.parse(currentAuction.auction.maxvalue);
    num minValue = currentAuction.auction.minvalue.contains('null')
        ? 0
        : num.parse(currentAuction.auction.minvalue);
    num allowedBid = maxValue + largest;
    // num allowedBid = (isAqar? 100000:10000) + largest;
    print('THIS IS CURRENT AUCTION: ${allowedBid}');
    if (price < initPrice) {
      content = 'السعر الذى أدخلته أقل من السعر الإبتدائي';
      return '';
    } else if ((price < largest + minValue || price > allowedBid) &&
        operations.isNotEmpty) {
      content =
          'السعر الذي أدخلته غير مناسب\nأقل قيمة للزيادة: ${currentAuction.auction.minvalue}\nأكبر قيمة للزيادة: ${currentAuction.auction.maxvalue}';

      return '';
    }
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
  List<PhotoViewGalleryPageOptions> imageViewList;
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
    imageViewList = List.generate(_imageUrls.length, (index) {
      return PhotoViewGalleryPageOptions(
          imageProvider:
              NetworkImage('${APIs.imageBaseUrl}${_imageUrls[index]}'),
          controller: photoViewCtrler);
    });

    super.initState();
  }

  PageController imageCtrler;
  PhotoViewController photoViewCtrler = PhotoViewController();

  @override
  Widget build(BuildContext context) {
    imageCtrler = PageController(initialPage: currentIndex);
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
                InkWell(
                    onTap: () =>
                        // showDialog(
                        //       context: context,
                        //       builder: (context) => Dialog(
                        //         backgroundColor: Colors.black.withOpacity(0.2),
                        //         child: ,
                        //       ),
                        //     ),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoViewGallery(
                              pageOptions: imageViewList,
                              pageController: imageCtrler,
                            ),
                          ),
                        ),
                    child: buildImage(_imageUrls[currentIndex], false, true)),
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
                              // imageCtrler.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
                              // photoViewCtrler.initial = PhotoViewControllerValue(position: null, scale: null, rotation: null, rotationFocusPoint: null)
                              // photoViewCtrler.``
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
