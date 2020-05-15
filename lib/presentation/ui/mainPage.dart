import 'package:auto_route/auto_route.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
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
          bottomNavigationBar: Injector.getAsReactive<AuthStore>().state.credentialsModel ==null? null: Directionality(
            textDirection: TextDirection.ltr,
            child: FancyBottomNavigation(
              tabs: <TabData>[
                TabData(iconData: MyFlutterApp.profile, title: 'حسابى'),
                TabData(iconData: MyFlutterApp.notification, title: 'اشعاراتى'),
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

  Widget buildAppBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height / 12),
      child: Align(
          alignment: FractionalOffset(0.94, 0.5),
          child: InkWell(
              onTap: () => _scaffoldKey.currentState.openDrawer(),
              child: Image.asset('assets/icons/menu.png'))),
    );
  }
}
