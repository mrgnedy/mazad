import 'package:mazad/core/api_utils.dart';

class AuthRepo {
  Future login(Map<String, dynamic> body) async {
    String url = APIs.loginEP;
    return await APIs.postRequest(url, body);
  }

  Future register(Map<String, dynamic> body) async {
    String url = APIs.registerEP;
    return await APIs.postRequest(url, body);
  }

  Future verify(String code) async {
    String url = APIs.phoneVerifyEP;
    Map<String, dynamic> body = {'code': '$code'};
    return await APIs.postRequest(url, body);
  }

  Future forgetPassword(String phone) async {
    String url = APIs.sendForgetPasswordEP;
    Map<String, dynamic> body = {'phone': '$phone'};
    return await APIs.postRequest(url, body);
  }

  Future verifyForgetPassword(String phone, String code) async {
    String url = APIs.sendForgetPasswordEP;
    Map<String, dynamic> body = {'phone': '$phone', 'code': '$code'};
    return await APIs.postRequest(url, body);
  }

  Future profile(int id) async {
    String url = APIs.profileEP;
    Map<String,dynamic> body= {
      'user_id' : '$id'
    };
    return await APIs.postRequest(url, body);
  }

  Future editProfile(Map<String, String> body, String image) async {
    print('Editing profile');
    String url = APIs.editprofileEP;
    return await APIs.postWithFile(url, body,
        filePath: image, fileName: 'image');
  }

  Future editPassword(String oldPassword, String newPassword) async {
    String url = APIs.editpassEP;
    Map<String, dynamic> body = {
      'old_password': '$oldPassword',
      'password': '$newPassword',
    };
    return await APIs.postRequest(url, body);
  }

  Future rechangePassword(String phone, String password) async {
    String url = APIs.editpassEP;
    Map<String, dynamic> body = {
      'phone': '$phone',
      'new_pass': '$password',
      'confirm_pass': '$password',
    };
    return await APIs.postRequest(url, body);
  }

  Future getNotifications() async {
    String url = APIs.notificationsEP;
    return await APIs.getRequest(url);
  }
  Future sendMsg(String name, String msg, String phone) async {
    String url = APIs.addcontactEP;
    Map<String, dynamic> body = {
      'message' : '$msg',
      'name' : '$name',
      'phone' : '$phone',
    } ;
    return await APIs.postRequest(url, body);
  }

  Future getSettings()async{
    String url = APIs.settinginfoEP;
    return await APIs.getRequest(url);
  }
}
