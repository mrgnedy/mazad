import 'dart:convert';

import 'package:mazad/data/models/general_model.dart';
import 'package:mazad/data/models/notification_mode.dart';
import 'package:mazad/data/models/payments_model.dart';
import 'package:mazad/data/models/register_model.dart';
import 'package:mazad/data/models/settings_model.dart';
import 'package:mazad/data/repos/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStore {
  AuthRepo authRepo = AuthRepo();
  SharedPreferences pref;
  Map<String, dynamic> settingsModel;
  CredentialsModel currentBidderProfile;
  CredentialsModel credentialsModel;
  NotificationModel notificationModel;
  //userType ==1? Seller : userType ==2? Bidder : null
  String get userType => credentialsModel?.data?.userType;
  int selectedRole;
  PaymentsModel paymentsModel;
  CredentialsModel unConfirmedcredentialsModel;
  bool get isAuth => credentialsModel != null;
  AuthStore() {
    SharedPreferences.getInstance().then((shPref) {
      pref = shPref;
      if (shPref.getString('creds') != null) {
        final tempCreds =
            CredentialsModel.fromJson(json.decode(shPref.getString('creds')));
        if (tempCreds.data.confirmed == 1)
          credentialsModel = tempCreds;
        else
          unConfirmedcredentialsModel = tempCreds;
      }
      if (credentialsModel == null)
        print('Is Not Authenticated!');
      else
        print('Is Authenticated with data: ${credentialsModel.data.toJson()}');
    });
  }

  Future<CredentialsModel> register(Credentials registerData) async {
    unConfirmedcredentialsModel = CredentialsModel.fromJson(
        await authRepo.register(registerData.register()));
    return unConfirmedcredentialsModel;
  }

  Future<CredentialsModel> login(Credentials loginData) async {
    final tempCreds =
        CredentialsModel.fromJson(await authRepo.login(loginData.login()));
    if (tempCreds?.data?.confirmed == 1) {
      credentialsModel = tempCreds;
      pref.setString('creds', json.encode(credentialsModel.toJson()));
    }
    return tempCreds;
  }

  Future<CredentialsModel> verify(String code, String phone) async {
    credentialsModel =
        CredentialsModel.fromJson(await authRepo.verify(code, phone));
    pref.setString('creds', json.encode(credentialsModel.toJson()));

    return credentialsModel;
  }

  Future<CredentialsModel> editProfile(
      Credentials profileData, String imgPath) async {
    print(imgPath);
    final creds = CredentialsModel.fromJson(
        await authRepo.editProfile(profileData.edit(), imgPath));
    if (creds != null) {
      credentialsModel = creds;
      pref.setString('creds', json.encode(credentialsModel.toJson()));
    }
    return creds;
  }

  Future<CredentialsModel> getProfile(int id) async {
    currentBidderProfile =
        CredentialsModel.fromJson(await authRepo.profile(id));
    return currentBidderProfile;
  }

  Future<GeneralModel> changePass(String oldPass, String newPass) async {
    return GeneralModel.fromJson(await authRepo.editPassword(oldPass, newPass));
  }

  Future<NotificationModel> getNotifications() async {
    notificationModel =
        NotificationModel.fromJson(await authRepo.getNotifications());
    return notificationModel;
  }

  Future<GeneralModel> sendContact(
      String name, String msg, String phone) async {
    return GeneralModel.fromJson(await authRepo.sendMsg(name, msg, phone));
  }

  Future<Map<String, dynamic>> getSettings() async {
    settingsModel = (await authRepo.getSettings())['data'];
    print('THIS IS SETTINGS MODEL $settingsModel');
    return settingsModel;
  }

  Future<CredentialsModel> verifyForgetPasowrd(
      String code, String phone) async {
    return CredentialsModel.fromJson(
        await authRepo.verifyForgetPassword(phone, code));
  }

  Future<CredentialsModel> rechangePassowrd(
      String phone, String newPassword, String confirmPassword) async {
    final creds = CredentialsModel.fromJson(
        await authRepo.rechangePassword(phone, newPassword));
    credentialsModel = creds;
    pref.setString('creds', json.encode(credentialsModel.toJson()));
    return creds;
  }

  Future<String> resendVerify(String phone) async {
    String temp =
        (await authRepo.resendVerify(phone))['data']['verifynumber'].toString();
    print('THIS IS TEEEEMP: $temp');
    return temp;
  }

  Future<PaymentsModel> getPayment() async {
    paymentsModel = PaymentsModel.fromJson(await authRepo.getPayment());
    return paymentsModel;
  }

  Future<String> sendForgetPassword(String phone) async {
    final String verifyNum =
        (await authRepo.forgetPassword(phone))['data']['verifyNum'].toString();
    return verifyNum;
  }
}
