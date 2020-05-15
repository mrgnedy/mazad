import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/data/models/categories_model.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/router.gr.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/widgets/tet_field_with_title.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:toast/toast.dart';

class NewAuction extends StatelessWidget {
  Size size;
  bool canAdd = true;
  TextEditingController initialPriceCtrler = TextEditingController();
  TextEditingController searchCatCtrler = TextEditingController();
  TextEditingController searchCityCtrler = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BackAppBar(size.height / 18),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildGetPhotos(context),
                SizedBox(height: 25),
                categoriesRebuilder(),
                SizedBox(height: 25),
                citiesRebuilder(),
                SizedBox(height: 25),
                buildProps(),
                SizedBox(height: 25),
                periodDropDownBtn(),
                SizedBox(height: 25),
                startAuctionRebuilder(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  File _image;
  List<Asset> _images;

  Widget buildGetPhotos(BuildContext context) {
    print(_image);
    GlobalKey key = GlobalKey();
    final size = MediaQuery.of(context).size;
    return StatefulBuilder(
        key: key,
        builder: (context, setState) {
          return Container(
            height: size.height / 5,
            width: size.height / 5,
            child: Stack(
              // fit: StackFit.passthrough,
              children: <Widget>[
                Parent(
                  style: ParentStyle()
                    ..alignmentContent.center()
                    ..alignment.center(),
                  child: DottedBorder(
                    child: Container(
                        height: size.height / 3,
                        width: size.height / 3,
                        child: _images == null
                            ? Icon(Icons.add)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: AssetThumb(
                                  asset: _images.first,
                                  height: size.height ~/ 5,
                                  width: size.height ~/ 5,

                                  // fit: BoxFit.cover,
                                ),
                              )),
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                  ),
                ),
                Parent(
                  child: Icon(
                    Icons.camera_enhance,
                    color: ColorsD.main,
                  ),
                  gesture: Gestures()
                    ..onTap(() async {
                      print('pressed $_image');
                      final temp = await StylesD.getMultiPictures(_images);
                      if (temp != null) _images = temp;
                      setState(() {});
                    }),
                  style: ParentStyle()
                    ..circle()
                    ..elevation(5, color: ColorsD.elevationColor)
                    ..background.color(Colors.white)
                    ..width(40)
                    ..height(40)
                    ..alignment.coordinate(0.8, 1.35)
                    ..alignmentContent.center(),
                )
              ],
            ),
          );
        });
  }

  Widget buildSelectCategory(BuildContext context, Widget dropDownBtn) {
    final size = MediaQuery.of(context).size;
    return CustomBorderedWidget(
        width: size.width * 0.7, title: "الفئة", dropDownBtn: dropDownBtn);
  }

  // List<String> categories = ['سيارات', 'عقارات', 'أجهزة كهربية'];
  String selectedCat;
  int selectedCatID;
  String selectedCity;
  int selectedCityID;
  // Widget catDropDownBtn(List<Category> categories) {
  //   if (categories.isNotEmpty) categories.removeAt(0);
  //   return CustomBorderedWidget(
  //     width: size.width * 0.7,
  //     title: "الفئة",
  //     dropDownBtn: categories.isEmpty
  //         ? Container(
  //             height: size.height / 16,
  //           )
  //         : StatefulBuilder(
  //             builder: (context, setState) {
  //               return DropdownButton(
  //                 style: TextStyle(fontFamily: 'bein'),
  //                 isExpanded: true,
  //                 underline: Container(),
  //                 value: selectedCat,
  //                 hint: Txt(
  //                   'إختر الفئة',
  //                   style: TxtStyle()..textAlign.right(),
  //                 ),
  //                 items: List.generate(
  //                   categories.length,
  //                   (index) => DropdownMenuItem(
  //                     child: Txt(
  //                       categories[index].name,
  //                       style: TxtStyle()
  //                         ..textAlign.right()
  //                         ..alignment.center(),
  //                     ),
  //                     value: categories[index].name,
  //                   ),
  //                 ),
  //                 onChanged: (s) => setState(() {
  //                   selectedCat = s;
  //                   selectedCatID = categories
  //                       .firstWhere((category) => category.name == s)
  //                       ?.id;
  //                   print(selectedCatID);
  //                 }),
  //               );
  //             },
  //           ),
  //   );
  // }

  final bidderRM = Injector.getAsReactive<BidderStore>();
  getCategories() {
    bidderRM.setState((state) => state.getCategories());
  }

  getCities() {
    bidderRM.setState((state) => state.getCities());
  }

  Widget categoriesRebuilder() {
    getCategories();
    return WhenRebuilder(
        onIdle: () => searchCatWidget(),
        onWaiting: () => bidderRM.state.categoriesModel == null
            ? searchCatWidget()
            : searchCatWidget(),
        onError: (e) => bidderRM.state.categoriesModel == null
            ? searchCatWidget()
            : searchCatWidget(),
        onData: (d) => searchCatWidget(),
        models: [bidderRM]);
  }

  Widget citiesRebuilder() {
    getCities();
    return WhenRebuilder(
        onIdle: () => searchCityWidget(),
        onWaiting: () => bidderRM.state.cititesModel == null
            ? searchCityWidget()
            : searchCityWidget(),
        onError: (e) => bidderRM.state.cititesModel == null
            ? searchCityWidget()
            : searchCityWidget(),
        onData: (d) => searchCityWidget(),
        models: [bidderRM]);
  }

  String initPriceValidator(String s) {
    if (s.isEmpty && selectedPeriodID != 1) return 'من فضلك أدخل سعر ابتدائي';
  }

  String emptyFieldValidator(String s) {
    if (s.isEmpty) return 'هذا الحقل مطلوب';
  }

  List<String> periods = [
    '12 ساعة',
    '24 ساعة',
    'أسبوعين',
  ];
  String selectedPeriod;
  int selectedPeriodID;
  Widget periodDropDownBtn() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomBorderedWidget(
            width: size.width * 0.7,
            title: "المدة",
            dropDownBtn: DropdownButton(
              style: TextStyle(fontFamily: 'bein'),
              isExpanded: true,
              underline: Container(),
              value: selectedPeriod,
              hint: Txt(
                'إختر المدة',
                style: TxtStyle()..textAlign.right(),
              ),
              items: List.generate(
                periods.length,
                (index) => DropdownMenuItem(
                  child: Txt(
                    periods[index],
                    style: TxtStyle()
                      ..textAlign.right()
                      ..alignment.center()
                      ..textDirection(TextDirection.rtl)
                      ..alignmentContent.center(),
                  ),
                  value: periods[index],
                ),
              ),
              onChanged: (s) => setState(
                () {
                  selectedPeriod = s;
                  selectedPeriodID = periods.indexOf(s) + 1;
                  // print
                },
              ),
            ),
          ),
          Visibility(
              visible: selectedPeriodID != null && selectedPeriodID != 1,
              child: TetFieldWithTitle(
                textEditingController: initialPriceCtrler,
                inputType: TextInputType.number,
                validator: initPriceValidator,
                title: 'سعر ابتدائي',
              ))
        ],
      );
    });
  }

  TextEditingController descCtrler = TextEditingController();
  Widget buildProps() {
    return TetFieldWithTitle(
      minLines: 3,
      textEditingController: descCtrler,
      validator: emptyFieldValidator,
      title: 'المواصفات',
    );
  }

  Widget buildStartAuction(context) {
    final size = MediaQuery.of(context).size;
    return Txt(
      "بدء",
      gesture: Gestures()..onTap(() => startAuction()),
      style: StylesD.mazadBtnStyle.clone()
        ..height(size.height / 20)
        ..width(size.width * 0.4)
        ..fontSize(20),
    );
  }

  final sellerRM = Injector.getAsReactive<SellerStore>();
  startAuction() async {
    print('STARTING AUCTION...');
    if (!_formKey.currentState.validate()) return;
    if (!canAdd) return;
    canAdd = false;
    // List<Future<ByteData>> futures = [];
    // _images.forEach((img) {
    //   futures.add(img.getByteData());
    // });
    // final list = await Future.wait(futures);
    // final imgList = List.generate(list.length, (i) {
    // print(list[i].buffer.asUint8List().cast<int>());
    //   return list[i].buffer.asUint8List().cast<int>();
    // });
    // final imageNames = List.generate(_images.length, (i)=>_images[i].name);
    final map = await StylesD.getImageListFromAssets(_images);
    sellerRM.setState(
        (state) => state.addAuction(
            AuctionData(
              catId: '$selectedCatID',
              desc: '${descCtrler.text}',
              duration: '$selectedPeriodID',
              intialPrice: '${initialPriceCtrler.text}',
              cityID: selectedCityID,
              address: 'Mansoura',
              lat: '2.2',
              lng: '2.2',
            ),
            map.first,
            map.last), onData: (context, data) {
      Toast.show('تم اضافة مزادك بنجاح', context, duration: Toast.LENGTH_LONG);
      ExtendedNavigator.rootNavigator.pop();
    }, onError: (context, error) {
      canAdd = true;
      print('$error');
      AlertDialogs.failed(
          context: context, content: 'تعذر إضافة المزاد من فضلك حاول مرة أخرى');
    });
  }

  Widget startAuctionRebuilder(context) {
    
    return WhenRebuilder(
        onWaiting: () => WaitingWidget(),
        onIdle: () => buildStartAuction(context),
        onError: (d) {
          print(d);
          return buildStartAuction(context);
        },
        onData: (d) => buildStartAuction(context),
        models: [sellerRM]);
  }

  String catValidator(String s) {
    if (s.isEmpty)
      return 'من فضلك أدخل الفئة التى ينتمى لها المزاد';
    else if (selectedCatID == null) return 'من فضلك اختر من الفئات المتاحة';
  }

  String cityValidator(String s) {
    if (s.isEmpty)
      return 'من فضلك أدخل المدينة المعروض فيها المزاد';
    else if (selectedCityID == null) return 'من فضلك اختر من المدن المتاحة';
  }

  Widget searchCatWidget() {
    return Container(
      width: size.width * 0.7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Txt(
            'الفئة',
            style: TxtStyle()
              ..fontSize(14)
              ..fontWeight(FontWeight.bold),
          ),
          TypeAheadFormField<Category>(
            validator: catValidator,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                // constraints: BoxConstraints.tightFor(width: size.width * 0.5),
                hasScrollbar: true,
                borderRadius: BorderRadius.circular(12)),
            textFieldConfiguration: TextFieldConfiguration(
              // focusNode: searchCatNode,
              controller: searchCatCtrler,

              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'bein', height: 1),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            onSuggestionSelected: (cat) {
              selectedCatID = cat?.id;
              searchCatCtrler.text = cat.name;
            },
            itemBuilder: (_, cat) => Txt(
              '${cat.name}',
              style: TxtStyle()
                ..textAlign.center()
                ..width(size.width * 0.5)
                ..padding(bottom: 5),
            ),
            suggestionsCallback: (suggestion) => Future.sync(
              () => bidderRM.state.categoriesModel.data.where(
                (cat) => cat.name.toLowerCase().contains(
                      suggestion.toLowerCase(),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchCityWidget() {
    return Container(
      width: size.width * 0.7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Txt(
            'المدينة',
            style: TxtStyle()
              ..fontSize(14)
              ..fontWeight(FontWeight.bold),
          ),
          TypeAheadFormField<Category>(
            validator: cityValidator,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                // constraints: BoxConstraints.tightFor(width: size.width * 0.5),
                hasScrollbar: true,
                borderRadius: BorderRadius.circular(12)),
            textFieldConfiguration: TextFieldConfiguration(
              // focusNode: searchCatNode,
              controller: searchCityCtrler,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'bein', height: 1),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            onSuggestionSelected: (cat) {
              selectedCityID = cat?.id;
              searchCityCtrler.text = cat.city;
            },
            itemBuilder: (_, cat) => Txt(
              '${cat.city}',
              style: TxtStyle()
                ..textAlign.center()
                ..width(size.width * 0.5)
                ..padding(bottom: 5),
            ),
            suggestionsCallback: (suggestion) => Future.sync(
              () => bidderRM.state.cititesModel.data.where(
                (cat) => cat.city.toLowerCase().contains(
                      suggestion.toLowerCase(),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
