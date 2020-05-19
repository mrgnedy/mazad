import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/ui/mainPage.dart';
import 'package:mazad/presentation/widgets/FCM.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../router.gr.dart';

class RoleSelectionPage extends StatefulWidget {
  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage>
    with SingleTickerProviderStateMixin {
  FirebaseNotifications firebaseNotifications;
  onMessage(String msg) {
    Future.delayed(Duration(seconds: 1), () {
      AlertDialogs.success(context: context, content: 'لديك إشعار جديد')
          .then((b) {
        if (b == true) {
          // ExtendedNavigator.rootNavigator.pushNamed(Routes.not);
        }
      });
    });
    print('onMessage: $msg');
  }

  onLaunch(String msg) {
    print('onLaunch: $msg');
  }

  onResume(String msg) {
    print('onResume: $msg');
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1), () => setState(() {}));
    FirebaseNotifications firebaseNotificationsHandler =
        FirebaseNotifications.handler(onMessage, onLaunch, onResume);
    FirebaseNotifications firebaseNotifications =
        FirebaseNotifications.getToken((s) {
      print(s);
    });

    Injector.getAsReactive<BidderStore>().state.getCities();
    // TODO: implement initState
    super.initState();
  }

  final authRM = Injector.getAsReactive<AuthStore>();
  @override
  Widget build(BuildContext context) {
    final userType = authRM.state.userType;
    print(userType);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child:
      //  userType == '1'
      //     ? MainPage(isSeller: true)
      //     : userType == '2'
      //         ? MainPage(isSeller: false)
      //         :
       Scaffold(
                  body: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset('assets/icons/first.png', height: size.height*0.6,),
                          Txt('بائع',
                              gesture: Gestures()
                                ..onTap(() {
                                  authRM.state.selectedRole = 1;
                                  authRM.state.credentialsModel == null?
                                  ExtendedNavigator.rootNavigator.pushNamed(
                                      Routes.authPage,
                                      arguments:
                                          AuthPageArguments(userType: 1)) : ExtendedNavigator.rootNavigator.pushNamed(
                                    Routes.mainPage,
                                    arguments:
                                        MainPageArguments(isSeller: true));
                                }),
                              style: StylesD.mazadBtnStyle
                                ..width(size.width * 0.7)
                                ..fontSize(22)
                                ..height(size.height / 16)
                                ..margin(vertical: 30)),
                          Txt(
                            'مزايد',
                            gesture: Gestures()
                              ..onTap(() {
                                authRM.state.selectedRole = 2;
                                ExtendedNavigator.rootNavigator.pushNamed(
                                    Routes.mainPage,
                                    arguments:
                                        MainPageArguments(isSeller: false));
                              }),
                            style: StylesD.mazadBorderdBtnStyle
                              ..width(size.width * 0.7)
                              ..fontSize(22)
                              ..height(size.height / 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
