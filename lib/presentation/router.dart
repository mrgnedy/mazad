
import 'package:auto_route/auto_route_annotations.dart';
import 'package:mazad/presentation/ui/auctionDetails/auction_details.dart';
import 'package:mazad/presentation/ui/auth/changePass.dart';
import 'package:mazad/presentation/ui/auth/forgot_passowrd.dart';
import 'package:mazad/presentation/ui/auth/rechangepassword.dart';
import 'package:mazad/presentation/ui/auth/register.dart';
import 'package:mazad/presentation/ui/auth/verify.dart';
import 'package:mazad/presentation/ui/drawer/about_us.dart';
import 'package:mazad/presentation/ui/drawer/commision_finished_page.dart';
import 'package:mazad/presentation/ui/drawer/commision_page.dart';
import 'package:mazad/presentation/ui/drawer/contact_us.dart';
import 'package:mazad/presentation/ui/mainPage.dart';
import 'package:mazad/presentation/ui/role_selection.dart';
import 'package:mazad/presentation/ui/navigationPages/notification_page.dart';
import 'package:mazad/presentation/ui/sellerPages/navigationPages/add_auction.dart';
import 'package:mazad/presentation/widgets/map.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  RoleSelectionPage roleSelectionPage;
  AuthPage authPage;
  AuctionPage auctionPage;
  NewAuction newAuction;
  MainPage mainPage;
  VerifyScreen verifyScreen;
  ChangePasswordScreen changePasswordScreen;
  CommisionPage commisionPage;
  CommisionSuccess commisionSuccess;
  MapScreen mapScreen;
  ContactUsPage contactUsPage;
  AboutUsPage aboutUsPage;
  ForgetPassword forgetPassword;
  NotificationScreen notificationScreen;
  RechangePasswordScreen rechangePasswordScreen;
}