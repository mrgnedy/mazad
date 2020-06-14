import 'package:mazad/presentation/state/auth_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class APIs {
  static String baseUrl = 'http://mazaad.live/api/';
  static String imageBaseUrl = 'http://mazaad.live/autions/images/';
  static String imageProfileUrl = 'http://mazaad.live/public/dash/assets/img/';
//AIzaSyDyZS1lXwrSQfLucsqjh2_XrTlm-ZkHjNU
  static String myauctionsEP = '${baseUrl}myauctions';
  static String addmazadEP = '${baseUrl}addmazad';
  static String finishauctionEP = '${baseUrl}finishauction';
  static String showauctionEP = '${baseUrl}showauction';
  static String addcommissionEP = '${baseUrl}addcommission';
  static String notificationsEP = '${baseUrl}notifications';
  static String homeEP = '${baseUrl}home';
  static String addoperationEP = '${baseUrl}addoperation';
  static String categoriesEP = '${baseUrl}categories';
  static String citiesEP = '${baseUrl}cities';
  static String returnauctionEP = '${baseUrl}returnauction';
  static String delauctionEP = '${baseUrl}delauction';
  static String editmazadEP = '${baseUrl}editmazad';
  static String editpriceEP = '${baseUrl}editoperation';
  static String addbalanceEP = '${baseUrl}addbalance';
  static String delnotEP = '${baseUrl}delnot';

  static String loginEP = '${baseUrl}login';
  static String registerEP = '${baseUrl}register';
  static String phoneVerifyEP = '${baseUrl}phone-verify';
  static String rechangepassEP = '${baseUrl}rechangepass';
  static String editpassEP = '${baseUrl}editpass';
  static String sendForgetPasswordEP = '${baseUrl}send-forget-password';
  static String verifyForgetPasswordEP = '${baseUrl}verify-forget-password';
  static String resendVerifyEP = '${baseUrl}resend-phone-verify';

  static String profileEP = '${baseUrl}profile';
  static String editprofileEP = '${baseUrl}editprofile';
  static String addcontactEP = '${baseUrl}addcontact';
  static String settinginfoEP = '${baseUrl}settinginfo';
  static String paymentsEP = '${baseUrl}payments';

  static Future getRequest(url,
      {String token = '', BuildContext context}) async {
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    String _token = reactiveModel.state.credentialsModel?.data?.apiToken;
    _token = _token?? reactiveModel.state.unConfirmedcredentialsModel?.data?.apiToken;
    // _token=
    //     'OTHHGYD6PFOiPu8EIkiSQc4yCBZ0VCk1PwGfxhOqUXl35wbbXQcxkqP3MysjalV2BY9XlIDhCT6IKGyr6kTQtsnPVcFOVhjE9cbh';
//لا توجد مزادات مباشرة
//لا توجد مزادات يومية
//لا توجد مزادات أسبوعية
//dailyAuction.isEmpty? Center(child:Text('لا توجد مزادات يومية')):
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $_token'});
      return checkResponse(response);
    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future postRequest(String url, Map<String, dynamic> body,
      {BuildContext context}) async {
    final reactiveModel = Injector.getAsReactive<AuthStore>();
     String _token = reactiveModel.state.credentialsModel?.data?.apiToken;
    _token = _token?? reactiveModel.state.unConfirmedcredentialsModel?.data?.apiToken;
    // _token= _token??
    //     'dGA9CYRHlfGhvjryhD0STklwm3fOqIh7XAYimPheEiKI265b1pjSZJUIHZteeC4hkqSFMlQ4M4XDaSOPSOPmSdbko8UAY2HXCNFG';

    print('Posting request');
    print(body);

    try {
      final response = await http
          .post(url, body: body, headers: {'Authorization': 'Bearer $_token'});
      return checkResponse(response);
    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } catch (e) {
      print('post request eror $e');
      rethrow;
    }
  }

  static postWithFile(
    String urlString,
    Map<String, String> body, {
    String filePath,
    String fileName,
    List additionalData,
    String additionalDataField,
    List additionalFiles,
    List additionalFilesNames,
    String additionalFilesField,
  }) async {
    print('Posting with files');
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    String _token = reactiveModel.state.credentialsModel?.data?.apiToken;
    // _token = _token??
    //     'c8GoLrSvefAfqfb2BJ5VXUOUJrSybNAcAd2LeQsNFPGHN60ejuDEV64sSQNblAx75eDpEvz8zFJwe2p6DUkrYjk3LNsimclr6b2v';

    Uri url = Uri.parse(urlString);
    // String image = savedOccasion['image'];
    // Map<String, String> body = (savedOccasion); //.toJson();
    Map<String, String> header = {'Authorization': 'Bearer $_token'};
    http.MultipartRequest request = http.MultipartRequest('post', url);
    request.fields.addAll(body);
    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
      print('Had File');
    }
    if (additionalFiles != null && additionalFiles.isNotEmpty)
      for (int i = 0; i < additionalFiles.length; i++) {
        print('additionalFiles[i]');
        request.files.add(http.MultipartFile.fromBytes(
            '$additionalFilesField[$i]', additionalFiles[i],
            filename: '${additionalFilesNames[i]}'));
      }
    if (additionalData != null && additionalData.isNotEmpty)
      for (int i = 0; i < additionalData.length; i++) {
        request.fields['$additionalDataField[$i]'] =
            additionalData[i].toString();
      }
    request.headers.addAll(header);
    print(body);
    try {
      final response = await request.send();
      final responseData =
          json.decode(utf8.decode(await response.stream.first));

      print('Response from post with image $responseData}');
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        // final responseData = (json.decode(utf8.decode(onData)));

        print(responseData);
        if (responseData['msg'].toString().toLowerCase() == 'success') {
          print(responseData);
          return (responseData);
        } else {
          if (responseData['msg'].toString().contains('unauth'))
            throw 'من فضلك تأكد من تسجيل الدخول';
          else
            throw responseData['data'];
        }
      } else
        throw 'تعذر الإتصال';

      // return SaveOccasionModel.fromJson(
      //     APIs.checkResponse(json.decode(utf8.decode(onData))));

    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } catch (e) {
      print(e);
      throw '$e';
    }
  }

  static checkResponse(http.Response response) {
    print('checking response');
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final responseData = json.decode(response.body);

      print(responseData);
      if (responseData['msg'].toString().toLowerCase() == 'success')
        return responseData;
      else {
        if (responseData['msg'].toString().contains('unauth'))
          throw 'من فضلك تأكد من تسجيل الدخول';
        else
          throw responseData['data'];
      }
    } else
      throw 'تعذر الإتصال';
  }
}
