import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:division/division.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/my_flutter_app_icons.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/ui/bidderPages/bidder_home_page.dart';
import 'package:mazad/presentation/ui/drawer/drawer.dart';
import 'package:mazad/presentation/ui/navigationPages/notification_page.dart';
import 'package:mazad/presentation/ui/navigationPages/profile_page.dart';
import 'package:mazad/presentation/ui/sellerPages/navigationPages/sellerHomePage.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../router.gr.dart';

class MainPage extends StatefulWidget {
  final bool isSeller;

  MainPage({Key key, this.isSeller}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController(initialPage: 2);

  Size size;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentPage = 2;
  @override
  void initState() {
    Injector.getAsReactive<AuthStore>()
        .setState((state) => state.getSettings());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      left: false,
      right: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: DrawerPage(),
          appBar: buildAppBar(context),
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: <Widget>[
                ProfilePage(),
                NotificationScreen(),
                widget.isSeller ? SellerHomePage() : BidderHomePage(),
              ],
            ),
          ),
          bottomNavigationBar: Injector.getAsReactive<AuthStore>()
                      .state
                      .credentialsModel ==
                  null
              ? null
              : Directionality(
                  textDirection: TextDirection.ltr,
                  child: FancyBottomNavigation(
                    tabs: <TabData>[
                      TabData(iconData: MyFlutterApp.profile, title: 'حسابى'),
                      TabData(
                          iconData: MyFlutterApp.notification,
                          title: 'اشعاراتى'),
                      TabData(iconData: MyFlutterApp.home, title: 'الرئيسية'),
                    ],
                    initialSelection: 2,
                    circleColor: Colors.white,
                    activeIconColor: ColorsD.main,
                    inactiveIconColor: ColorsD.main,
                    onTabChangedListener: (p) {
                      pageController.jumpToPage(p);
                      currentPage = p;
                    },
                  ),
                ),
        ),
      ),
    );
  }

  // ٠١٢٣٤٥٦٧٨٩
  changeToArabic(String s) => s
      .replaceAll('0', '٠')
      .replaceAll('1', '١')
      .replaceAll('2', '٢')
      .replaceAll('3', '٣')
      .replaceAll('4', '٤')
      .replaceAll('5', '٥')
      .replaceAll('6', '٦')
      .replaceAll('7', '٧')
      .replaceAll('8', '٨')
      .replaceAll('9', '٩')
      .replaceAll('PM', 'مساءً')
      .replaceAll('AM', 'صباحاً');
  String getTime() {
    DateTime time = DateTime.now().toUtc().add(Duration(hours: 3));
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(time);
    String timeOfDayStr = timeOfDay.format(context);
    return changeToArabic(timeOfDayStr);
  }

  Widget timeWidget() {
    return StatefulBuilder(builder: (context, ss) {
      Timer.periodic(Duration(milliseconds: 999), (s) => ss(() {}));
      return Txt(
        '${getTime()}',
        style: TxtStyle()
          ..fontFamily('null')
          ..fontWeight(FontWeight.bold)
          ..fontSize(18),
      );
    });
  }

  Widget buildAppBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height / 8.2),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(alignment: FractionalOffset(0.08, 0.4), child: timeWidget()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset('assets/icons/rightcurve.png',
                    width: size.width * 0.4, fit: BoxFit.fill),
                Image.asset('assets/icons/logo.png'),
                Image.asset('assets/icons/leftcurve.png',
                    width: size.width * 0.4, fit: BoxFit.fill),
              ],
            ),
            Align(
                alignment: FractionalOffset(0.94, 0.5),
                child: InkWell(
                    onTap: () => _scaffoldKey.currentState.openDrawer(),
                    child: Image.asset('assets/icons/menu.png')))
          ],
        ),
      ),
    );
  }
}
