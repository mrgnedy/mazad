import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazad/core/api_utils.dart';
import 'package:mazad/presentation/widgets/waiting_widget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ColorsD {
  static Color main = Color.fromARGB(255, 36, 87, 142);
  static Color eventDetailsColor = Colors.lightBlue;
  static Color backGroundColor = Colors.grey[300];
  static Color elevationColor = Colors.grey;
}

class StylesD {
  static Size size;
  static Widget richText(String mainText, String subText, double width) {
    return Parent(
      // alignment: Alignment.,
      style: ParentStyle()
        ..alignment.centerRight()
        ..margin(left: 12)
        ..width(width)
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
                    color: ColorsD.main, fontFamily: 'bein', )),
            TextSpan(
                text: '$subText',
                style: TextStyle(
                    height: 1.5,
                    color: Colors.grey[800],
                    fontFamily: 'bein',
                    )),
          ],
        ),
      ),
    );
  }

  static TxtStyle mazadBtnStyle = TxtStyle()
    ..borderRadius(all: 12)
    ..textColor(Colors.white)
    ..background.color(ColorsD.main)
    ..fontFamily('bein')
    ..alignmentContent.center()
    ..textAlign.center();
  static TxtStyle mazadBorderdBtnStyle = TxtStyle()
    ..borderRadius(all: 12)
    ..textColor(ColorsD.main)
    ..border(all: 3, color: ColorsD.main)
    ..background.color(Colors.white)
    ..fontFamily('bein')
    ..alignmentContent.center()
    ..textAlign.center();
  // ..width(size.width * 0.7)
  // ..height(size.height / 16)

  static getMultiPictures(List<Asset> images) {
    return MultiImagePicker.pickImages(
        enableCamera: true,
        materialOptions: MaterialOptions(
          startInAllView: true,
        ),
        // selectedAssets: images,
        maxImages: 10);
  }

  static Widget imageBuilder(
      {String image,
      double height,
      double width,
      BoxShape shape,
      BorderRadius borderRadius,
      Function callback}) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: height,
        width: width,
        // padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorsD.main,
          shape: shape,
          borderRadius: borderRadius,
          border: Border.all(color: ColorsD.main, width: 1),
        ),
        child: CachedNetworkImage(
          height: height,
          width: width,
          imageUrl: '${APIs.imageBaseUrl}$image',
          imageBuilder: (context, imageB) => Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              shape: shape,
              borderRadius: borderRadius,
              image: DecorationImage(image: imageB, fit: BoxFit.cover),
            ),
          ),
          fit: BoxFit.cover,
          placeholder: (context, imageL) => imageL.contains('null')
              ? StylesD.noImageWidget()
              : WaitingWidget(),
        ),
      ),
    );
  }

  static Widget noImageWidget() {
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

  static Future<List<dynamic>> getImageListFromAssets(
      List<Asset> _images) async {
    List<Future<ByteData>> futures = [];
    _images.forEach((img) {
      futures.add(img.getByteData());
    });

    return Future.wait(futures).then((list) {
      // final list = await Future.wait(futures);
      final imgList = List.generate(list.length, (i) {
        print(list[i].buffer.asUint8List().cast<int>());
        return list[i].buffer.asUint8List().cast<int>();
      });
      final imageNames = List.generate(_images.length, (i) => _images[i].name);
      return [imgList, imageNames];
    });
  }

  static getProfilePicture(BuildContext context) async {
    print('kjhgcfvhjklv');
    return await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        context: context,
        builder: (context) => ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Txt('اختر مصدر الصورة',
                      style: TxtStyle()
                        ..textColor(Colors.white)
                        ..background.color(ColorsD.main)
                        ..height(40)
                        ..alignment.center()
                        ..alignmentContent.center()
                        ..fontSize(16)),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(
                          context,
                          await ImagePicker.pickImage(
                              source: ImageSource.camera));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Txt('الكاميرا'),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.camera_enhance,
                            color: ColorsD.main,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(
                          context,
                          await ImagePicker.pickImage(
                              source: ImageSource.gallery));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Txt('الاستوديو'),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.photo_library,
                            color: ColorsD.main,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
    // setState(() {});
  }

  static showErrorDialog(context, error, [Function callback]) {
    print('$error');
    return AlertDialogs.failed(context: context, content: error.toString());
  }

  static InputDecoration inputDecoration = InputDecoration(
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsD.main, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsD.main, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
  static TxtStyle txtOnCardStyle = TxtStyle()
    ..fontFamily('Cairo')
    ..textColor(Colors.white)
    ..alignment.center()
    ..alignmentContent.center()
    ..borderRadius(all: 8)
    // ..height(size.height / 18)
    ..background.color(ColorsD.main)
    ..elevation(10, color: ColorsD.elevationColor)
    ..margin(horizontal: 20, bottom: 10);
  static ParentStyle btnOnCardStyle = ParentStyle()
    ..alignment.center()
    ..alignmentContent.center()
    ..borderRadius(all: 8)
    ..height(size.height / 18)
    ..background.color(ColorsD.main)
    ..elevation(10, color: ColorsD.elevationColor)
    ..margin(horizontal: 20, vertical: 20);
  static ParentStyle cartStyle = ParentStyle()
    ..borderRadius(all: 30)
    ..elevation(8, color: Colors.grey)
    ..alignment.center()
    ..alignmentContent.center()
    ..padding(all: 20.0)
    ..background.color(Colors.white)
    ..margin(all: 20);

  static TxtStyle txtStyle = TxtStyle()..fontFamily('Cairo');
  static InputDecoration inputDecoration2 = InputDecoration(
    // labelText: hint,
    // labelStyle:
    //     TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
    // alignLabelWithHint: true,

    contentPadding: EdgeInsets.only(
      right: 10,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsD.main),
      borderRadius: BorderRadius.circular(20),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(20),
    ),

    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

class Assets {
  static String productBackground =
      'assets/icons/shttefan-viNPa2F7fnw-unsplash.png';
  static String logo =
      'assets/icons/84273958_467844620576269_2633456491713003520_n.png';
}

class Urls {
  static String phoneNumber = '+966548252956';
}

class AlertDialogs {
  static Future failed({BuildContext context, String content}) async {
    // context = globalContext;
    return await defaultDialog(context, 'فشلت العملية', Icons.warning,
        content: content);
  }

  static Future success({BuildContext context, String content}) async {
    // context = globalContext;
    return await defaultDialog(context, 'تمت العملية', Icons.check,
        content: content);
  }

  static Future defaultDialog(BuildContext context, String title, IconData icon,
      {String content}) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: ColorsD.main)),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  icon,
                  color: ColorsD.main,
                  size: 30,
                ),
                Txt(
                  title,
                  style: StylesD.txtStyle,
                ),
              ],
            ),
            Divider(
              color: ColorsD.main,
              height: 10,
            )
          ],
        ),
        content: Container(
          // color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 8,
          child: Align(
            child: Txt(content,
                style: StylesD.txtStyle.clone()
                  ..textDirection(TextDirection.rtl)
                  ..fontFamily('bein')
                  ..textAlign.center()),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // ClippedButton(
              //   width: MediaQuery.of(context).size.width / 4,
              //   child: TextD(title: 'لا',textColor: ColorsD.redDefault, fontSize: 18,),
              //   color: Colors.grey[100],
              //   onTapCallback: (){},
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 37.0),
                child: ClippedButton(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Txt(
                    'موافق',
                    style: TxtStyle()
                      ..fontFamily('bein')
                      ..textColor(Colors.white),
                  ),
                  color: ColorsD.main,
                  onTapCallback: () => Navigator.of(context).pop(true),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomBorderedWidget extends StatelessWidget {
  final double width;
  final String title;
  final Widget dropDownBtn;

  const CustomBorderedWidget(
      {Key key, this.width, this.dropDownBtn, this.title = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return dropDownWithStyle(dropDownBtn);
  }

  Widget dropDownWithStyle(Widget dropDownBtn) {
    // scrollController.jumpTo(scrollController.position.)
    // final size = MediaQuery.of(context).size;
    return Container(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Txt('$title',
              style: TxtStyle()
                ..fontWeight(FontWeight.bold)
                ..alignment.centerRight()),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: ColorsD.main),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: dropDownBtn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClippedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final Function onTapCallback;

  ClippedButton({
    this.child,
    this.color = Colors.grey,
    this.onTapCallback,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        margin: EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: width ?? MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 18, left: 18),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class BackAppBar extends PreferredSize {
  final double preferredHeight;
  final Widget title;
  // Size size;

  BackAppBar(this.preferredHeight, [this.title]);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(builder: (context) {
      // size = MediaQuery.of(context).size;
      return Parent(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Image.asset('assets/icons/back.png'),
            title ?? Container()
          ],
        ),
        style: ParentStyle()
          ..alignment.coordinate(0.6, 1)
          ..width(200)
          ..background.color(Colors.transparent),
        gesture: Gestures()..onTap(Navigator.of(context).pop),
      );
    });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
