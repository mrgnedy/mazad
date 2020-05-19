import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/categories_model.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/router.gr.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/error_widget.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:toast/toast.dart';

class BidderHomePage extends StatefulWidget {
  @override
  _BidderHomePageState createState() => _BidderHomePageState();
}

class _BidderHomePageState extends State<BidderHomePage>
    with SingleTickerProviderStateMixin {
  Size size;
  AnimationController animationController;
  Animation<Size> searchBarAnim;
  Animation<double> searchAnim;
  @override
  void initState() {
    // TODO: implement initState
    getAllAuctions();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    searchAnim = Tween(begin: 0.0, end: 2 * pi).animate(CurvedAnimation(
      curve: Curves.easeInCubic,
      parent: animationController,
    ));
    super.initState();
  }

  Size searchBarSize = Size(100, 100);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    searchBarSize = Size(size.width * 0.5, size.height / 12);
    searchBarAnim = SizeTween(begin: Size(50, 50), end: searchBarSize)
        .animate(CurvedAnimation(
      curve: Curves.ease,
      parent: animationController,
    ));
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
          alignment: WrapAlignment.center,
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

  // List<String> categoryList = [
  //   'الكل',
  //   'سيارات',
  //   'عقارات',
  //   'أجهزة كهربية',
  // ];

  String selectedCategory;

  String selectedCatID = '0';

  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height /10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.only(top:10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                categoriesRebuilder(),
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

  Widget buildCategoryDropDownBtn(List<Category> categoryList) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButton(
          hint: Txt('الكل'),
          underline: Container(),
          value: selectedCategory,
          style: TextStyle(fontFamily: 'bein', color: Colors.grey[700]),
          items: List.generate(
            categoryList.length,
            (index) => DropdownMenuItem(
              child: Txt(
                categoryList[index].name,
                style: TxtStyle()..alignment.center(),
              ),
              value: categoryList[index].name,
            ),
          ),
          onChanged: (s) => setState(() {
                selectedCategory = s;
                selectedCatID = categoryList
                    .firstWhere((cat) => cat.name == s, orElse: () => null)
                    ?.id
                    .toString();
              })),
    );
  }

  getCategories() {
    if(bidderRM.state.categoriesModel == null)
    bidderRM.setState((state) => state.getCategories());
  }

  TextEditingController searchCatCtrler = TextEditingController(text: '');
  FocusNode searchCatNode = FocusNode();
  bool isExpanded = false;
  Widget searchCategory() {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            
            width: searchBarAnim.value.width,
            height: searchBarAnim.value.height,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Opacity(
                    opacity: (searchBarAnim.value.height - 50) /
                        (searchBarSize.height - 50),
                    child: searchCatWidget()),
                Align(
                  alignment: FractionalOffset(0, 0.15),
                  child: IconButton(
                    onPressed: () => setState(() {
                      print('s');
                      if (animationController.isCompleted)
                        animationController.reverse();
                      else {
                        animationController.forward();
                        FocusScope.of(context).requestFocus(searchCatNode);
                      }
                    }),
                    icon: Transform.rotate(
                        // alignment: FractionalOffset(-1, 0),

                        angle: searchAnim.value,
                        child: Icon(Icons.search)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget categoriesRebuilder() {
    getCategories();
    return WhenRebuilder(
        onIdle: () => searchCategory(),
        onWaiting: () => bidderRM.state.categoriesModel == null
            ? Container()
            : searchCategory(),
        onError: (e) => bidderRM.state.categoriesModel == null
            ? Container()
            : searchCategory(),
        onData: (d) => searchCategory(),
        models: [bidderRM]);
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
    bool isAllCats = selectedCatID == '0';
    print(isAllCats);
    bool getAuctions(AuctionData auction) =>
        auction.catId == selectedCatID || isAllCats;
    List<AuctionData> getListAuctions(List<AuctionData> auctions) =>
        auctions.where((auction) => getAuctions(auction)).toList();
    final liveAuctions = getListAuctions(allAuctions.mobasherdata);
    final dailyAuctions = getListAuctions(allAuctions.daysdata);
    final weeklyAuctions = getListAuctions(allAuctions.weeksdata);
    return SingleChildScrollView(
      // width: size.width * 0.85,
      child: Column(
        children: <Widget>[
          buildLiveAuctions(liveAuctions),
          buildDailyAuctions(dailyAuctions),
          buildWeeklyAuctions(weeklyAuctions)
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

  Widget searchCatWidget() {
    return TypeAheadFormField<Category>(
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        constraints: BoxConstraints.tightFor(width: size.width*0.5),
        hasScrollbar: true,
        borderRadius: BorderRadius.circular(12)
      ),
      textFieldConfiguration: TextFieldConfiguration(
        focusNode: searchCatNode,
        controller: searchCatCtrler,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'bein', height: 1),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onSuggestionSelected: (cat) => setState(() {
        selectedCatID = cat.id.toString();
        selectedCategory = cat.name;
        searchCatCtrler.text = selectedCategory;
        isExpanded = false;
        animationController.reverse();
      }),
      itemBuilder: (_, cat) => Txt(
        '${cat.name}',
        style: TxtStyle()
          ..textAlign.center()
          ..width(size.width*0.5)
          ..padding(bottom: 5),
      ),
      suggestionsCallback: (suggestion) => Future.sync(
        () => bidderRM.state.categoriesModel.data.where(
          (cat) => cat.name.toLowerCase().contains(
                suggestion.toLowerCase(),
              ),
        ),
      ),
    );
  }
}
