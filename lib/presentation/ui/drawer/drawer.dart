import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:share/share.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../router.gr.dart';


class DrawerPage extends StatelessWidget {
final authRM = Injector.getAsReactive<AuthStore>();
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print('ROLE IS ${authRM.state.selectedRole}');
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
                visible: Injector.getAsReactive<AuthStore>()
                        .state
                        .credentialsModel ==
                    null,
                child: drawerItem(
                    'تسجيل الدخول',
                    'profile',
                    () => ExtendedNavigator.rootNavigator
                        .pushNamedAndRemoveUntil(
                            Routes.authPage, (Route<dynamic> route) => false)),
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
                'الشروط والأحكام',
                'shoroot',
                () => ExtendedNavigator.rootNavigator.pushNamed(
                    Routes.aboutUsPage,
                    arguments: AboutUsPageArguments(
                        info: 'policy', title: 'الشروط والأحكام')),
              ),
              drawerItem(
                'اتصل بنا',
                'call',
                () => ExtendedNavigator.rootNavigator
                    .pushNamed(Routes.contactUsPage),
              ),
              Visibility(
                visible:
                    Injector.getAsReactive<AuthStore>().state.selectedRole == 1,
                child: drawerItem(
                  'عمولة التطبيق',
                  'money',
                  () => ExtendedNavigator.rootNavigator
                      .pushNamed(Routes.commisionPage),
                ),
              ),
              drawerItem('مشاركة التطبيق', 'share', () => Share.share('https://play.google.com/store/apps/details?id=com.skinnyg.mazad')),
              drawerItem(
                  '${authRM.state.selectedRole == 1 ? "الدخول كمزايد" : "الدخول كبائع"}',
                  null, () {
                authRM.state.selectedRole = 3 - authRM.state.selectedRole;
                if (authRM.state.selectedRole == 1 &&
                    authRM.state.credentialsModel == null) {
                  ExtendedNavigator.rootNavigator.pushReplacementNamed(
                      Routes.authPage,
                      arguments: AuthPageArguments(
                          userType: authRM.state.selectedRole));
                } else
                  ExtendedNavigator.rootNavigator.pushReplacementNamed(
                    Routes.mainPage,
                    arguments: MainPageArguments(
                        isSeller: 3 - authRM.state.selectedRole == 2),
                  );
              }),
              Visibility(
                visible: Injector.getAsReactive<AuthStore>()
                        .state
                        .credentialsModel !=
                    null,
                child: drawerItem('تسجيل الخروج', 'exit', () {
                  final authRM = Injector.getAsReactive<AuthStore>().state;
                  authRM.credentialsModel = null;
                  authRM.unConfirmedcredentialsModel = null;
                  authRM.pref.clear();
                  ExtendedNavigator.rootNavigator.pushNamedAndRemoveUntil(
                      Routes.roleSelectionPage,
                      (Route<dynamic> route) => false);
                }, true),
              ),
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
            iconName == null
                ? Icon(
                    Icons.sync,
                    color: ColorsD.main,
                  )
                : Image.asset('assets/icons/$iconName.png'),
            Txt(
              '$title',
              style: TxtStyle()
                ..padding(horizontal: 12)
                ..fontSize(18)
                ..textColor(isExit == true ? Colors.red : ColorsD.main),
            ),
          ],
        ),
      ),
    );
  }
}
