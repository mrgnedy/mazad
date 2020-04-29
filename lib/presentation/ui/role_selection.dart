import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:mazad/core/utils.dart';
import 'package:mazad/presentation/widgets/FCM.dart';

import '../router.gr.dart';

class RoleSelectionPage extends StatefulWidget {
  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage>
    with SingleTickerProviderStateMixin {

      FirebaseNotifications firebaseNotifications;
      onMessage(String msg){
        print('onMessage: $msg');
      }
      onLaunch(String msg){
        print('onLaunch: $msg');

      }
      onResume(String msg){
        print('onResume: $msg');

      }
      

      @override
  void initState() {
      FirebaseNotifications firebaseNotificationsHandler= FirebaseNotifications.handler(onMessage, onLaunch, onResume);
      FirebaseNotifications firebaseNotifications = FirebaseNotifications.getToken((s){
      print(s);
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/icons/logo.png'),
                Txt('بائع',
                    gesture: Gestures()
                      ..onTap(() => ExtendedNavigator.rootNavigator.pushNamed(
                          Routes.mainPage,
                          arguments: AuthPageArguments(userType: 1))),
                    style: StylesD.mazadBtnStyle
                      ..width(size.width * 0.7)
                      ..height(size.height / 16)
                      ..margin(vertical: 30)),
                Txt(
                  'مزايد',
                  gesture: Gestures()
                      ..onTap(() => ExtendedNavigator.rootNavigator.pushNamed(
                          Routes.mainPage,
                          arguments: MainPageArguments(isSeller: true))),
                  style: StylesD.mazadBorderdBtnStyle
                    ..width(size.width * 0.7)
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
