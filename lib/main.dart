import 'package:auto_route/auto_route.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mazad/presentation/router.gr.dart';
import 'package:mazad/presentation/state/auth_store.dart';
import 'package:mazad/presentation/state/bidder_store.dart';
import 'package:mazad/presentation/state/seller_store.dart';
import 'package:mazad/presentation/ui/auction_details.dart';
import 'package:mazad/presentation/ui/auth/changePass.dart';
import 'package:mazad/presentation/ui/auth/register.dart';
import 'package:mazad/presentation/ui/bidderPages/bidder_home_page.dart';
import 'package:mazad/presentation/ui/navigationPages/notification_page.dart';
// import 'package:mazad/presentation/ui/profile_page.dart';
import 'package:mazad/presentation/ui/role_selection.dart';
import 'package:mazad/presentation/ui/mainPage.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<AuthStore>(() => AuthStore(), isLazy: false),
        Inject<SellerStore>(() => SellerStore()),
        Inject<BidderStore>(() => BidderStore()),
      ],
      builder: (context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          textTheme: TextTheme(
            body1: TextStyle(fontFamily: 'bein', height: 1.7),
          ),
          primarySwatch: Colors.blue,
        ),
        builder: ExtendedNavigator<Router>(router: Router()),
        home: AuthPage(),
      ),
      reinject: [],
    );
  }

  setNotificationChannel() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}
