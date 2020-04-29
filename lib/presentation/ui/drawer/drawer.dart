import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:share/share.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';

class DrawerPage extends StatelessWidget {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Drawer(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/icons/logo.png',
                height: size.height / 6,
              ),
              SizedBox(height: 50),
              Visibility(
                visible:
                    Injector.getAsReactive<AuthStore>().state.userType != '1',
                child: drawerItem(
                  'عمولة التطبيق',
                  'money',
                  () => ExtendedNavigator.rootNavigator
                      .pushNamed(Routes.commisionPage),
                ),
              ),
              drawerItem(
                'من نحن',
                'aboutus',
                () => ExtendedNavigator.rootNavigator.pushNamed(
                    Routes.aboutUsPage,
                    arguments:
                        AboutUsPageArguments(info: 'about', title: 'من نحن')),
              ),
              drawerItem(
                'اتصل بنا',
                'call',
                () => ExtendedNavigator.rootNavigator
                    .pushNamed(Routes.contactUsPage),
              ),
              drawerItem(
                'الشروط والأحكام',
                'shoroot',
                () => ExtendedNavigator.rootNavigator.pushNamed(
                    Routes.aboutUsPage,
                    arguments: AboutUsPageArguments(
                        info: 'policy', title: 'الشروط والأحكام')),
              ),
              drawerItem('مشاركة التطبيق', 'share', () => Share.share('TEXT')),
              drawerItem(
                  'تسجيل الخروج',
                  'exit',
                  () => ExtendedNavigator.rootNavigator.pushNamedAndRemoveUntil(
                      Routes.roleSelectionPage,
                      (Route<dynamic> route) => false),
                  true),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(String title, String iconName, Function callback,
      [bool isExit = false]) {
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 12,
            ),
            Image.asset('assets/icons/$iconName.png'),
            Txt(
              '$title',
              style: TxtStyle()
                ..padding(horizontal: 12)
                ..fontSize(18)
                ..textColor(isExit ? Colors.red : ColorsD.main),
            ),
          ],
        ),
      ),
    );
  }
}
