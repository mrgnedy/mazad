// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mazad/presentation/ui/role_selection.dart';
import 'package:mazad/presentation/ui/auth/register.dart';
import 'package:mazad/presentation/ui/auction_details.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/presentation/ui/sellerPages/navigationPages/add_auction.dart';
import 'package:mazad/presentation/ui/mainPage.dart';
import 'package:mazad/presentation/ui/auth/verify.dart';
import 'package:mazad/presentation/ui/auth/changePass.dart';
import 'package:mazad/presentation/ui/drawer/commision_page.dart';
import 'package:mazad/presentation/ui/drawer/commision_finished_page.dart';
import 'package:mazad/presentation/widgets/map.dart';
import 'package:mazad/presentation/ui/drawer/contact_us.dart';
import 'package:mazad/presentation/ui/drawer/about_us.dart';

abstract class Routes {
  static const roleSelectionPage = '/';
  static const authPage = '/auth-page';
  static const auctionPage = '/auction-page';
  static const newAuction = '/new-auction';
  static const mainPage = '/main-page';
  static const verifyScreen = '/verify-screen';
  static const changePasswordScreen = '/change-password-screen';
  static const commisionPage = '/commision-page';
  static const commisionSuccess = '/commision-success';
  static const mapScreen = '/map-screen';
  static const contactUsPage = '/contact-us-page';
  static const aboutUsPage = '/about-us-page';
}

class Router extends RouterBase {
  //This will probably be removed in future versions
  //you should call ExtendedNavigator.ofRouter<Router>() directly
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.roleSelectionPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => RoleSelectionPage(),
          settings: settings,
        );
      case Routes.authPage:
        if (hasInvalidArgs<AuthPageArguments>(args)) {
          return misTypedArgsRoute<AuthPageArguments>(args);
        }
        final typedArgs = args as AuthPageArguments ?? AuthPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              AuthPage(key: typedArgs.key, userType: typedArgs.userType),
          settings: settings,
        );
      case Routes.auctionPage:
        if (hasInvalidArgs<AuctionPageArguments>(args)) {
          return misTypedArgsRoute<AuctionPageArguments>(args);
        }
        final typedArgs =
            args as AuctionPageArguments ?? AuctionPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => AuctionPage(
              key: typedArgs.key, auctionData: typedArgs.auctionData),
          settings: settings,
        );
      case Routes.newAuction:
        return MaterialPageRoute<dynamic>(
          builder: (_) => NewAuction(),
          settings: settings,
        );
      case Routes.mainPage:
        if (hasInvalidArgs<MainPageArguments>(args)) {
          return misTypedArgsRoute<MainPageArguments>(args);
        }
        final typedArgs = args as MainPageArguments ?? MainPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              MainPage(key: typedArgs.key, isSeller: typedArgs.isSeller),
          settings: settings,
        );
      case Routes.verifyScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => VerifyScreen(),
          settings: settings,
        );
      case Routes.changePasswordScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ChangePasswordScreen(),
          settings: settings,
        );
      case Routes.commisionPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => CommisionPage(),
          settings: settings,
        );
      case Routes.commisionSuccess:
        return MaterialPageRoute<dynamic>(
          builder: (_) => CommisionSuccess(),
          settings: settings,
        );
      case Routes.mapScreen:
        if (hasInvalidArgs<MapScreenArguments>(args)) {
          return misTypedArgsRoute<MapScreenArguments>(args);
        }
        final typedArgs = args as MapScreenArguments ?? MapScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => MapScreen(typedArgs.setLocation),
          settings: settings,
        );
      case Routes.contactUsPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ContactUsPage(),
          settings: settings,
        );
      case Routes.aboutUsPage:
        if (hasInvalidArgs<AboutUsPageArguments>(args)) {
          return misTypedArgsRoute<AboutUsPageArguments>(args);
        }
        final typedArgs =
            args as AboutUsPageArguments ?? AboutUsPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => AboutUsPage(
              key: typedArgs.key, info: typedArgs.info, title: typedArgs.title),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//AuthPage arguments holder class
class AuthPageArguments {
  final Key key;
  final int userType;
  AuthPageArguments({this.key, this.userType});
}

//AuctionPage arguments holder class
class AuctionPageArguments {
  final Key key;
  final AuctionData auctionData;
  AuctionPageArguments({this.key, this.auctionData});
}

//MainPage arguments holder class
class MainPageArguments {
  final Key key;
  final bool isSeller;
  MainPageArguments({this.key, this.isSeller});
}

//MapScreen arguments holder class
class MapScreenArguments {
  final Function setLocation;
  MapScreenArguments({this.setLocation});
}

//AboutUsPage arguments holder class
class AboutUsPageArguments {
  final Key key;
  final String info;
  final String title;
  AboutUsPageArguments({this.key, this.info, this.title});
}
