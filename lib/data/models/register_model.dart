class CredentialsModel {
  String msg;
  String apiToken;
  String verifyNumber;
  Credentials data;

  CredentialsModel({this.msg, this.apiToken, this.data});

  CredentialsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    verifyNumber = json['verifynumber'].toString();
    apiToken = json['api_token'];
    data = json['data'] != null ? new Credentials.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['verifynumber'] = this.verifyNumber;
    data['api_token'] = this.apiToken;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Credentials {
  String name;
  String email;
  String phone;
  String lat;
  String lng;
  String address;
  String image;
  String type;
  String accountNumber;
  String userType;
  int confirmed;
  String apiToken;
  String googleToken;
  String updatedAt;
  String createdAt;
  String password;
  String confirmPassword;
  int id;

  Credentials(
      {this.password,
      this.confirmPassword,
      this.name,
      this.email,
      this.phone,
      this.lat,
      this.lng,
      this.address,
      this.image,
      this.type,
      this.accountNumber,
      this.userType,
      this.confirmed,
      this.apiToken,
      this.googleToken,
      this.updatedAt,
      this.createdAt,
      this.id});

  Credentials.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    address = json['address'];
    image = json['image'];
    type = json['type'];
    accountNumber = json['account_number'];
    userType = json['user_type'].toString();
    confirmed = json['confirmed'];
    apiToken = json['api_token'];
    googleToken = json['google_token'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['image'] = this.image;
    data['type'] = this.type;
    data['account_number'] = this.accountNumber;
    data['user_type'] = this.userType;
    data['confirmed'] = this.confirmed;
    data['api_token'] = this.apiToken;
    data['google_token'] = this.googleToken;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }

  Map<String, dynamic> register() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['account_number'] = this.accountNumber;
    data['google_token'] = this.googleToken;
    data['password'] = this.password;
    // data['image'] = this.image;
    // data['type'] = this.type;
    data['user_type'] = this.userType;
    // data['confirmed'] = this.confirmed;
    // data['api_token'] = this.apiToken;
    // data['updated_at'] = this.updatedAt;
    // data['created_at'] = this.createdAt;
    // data['id'] = this.id;
    return data;
  }

  Map<String, dynamic> edit() {
    final Map<String, String> data = new Map<String, String>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['account_number'] = this.accountNumber;
    // data['google_token'] = this.googleTo ken;
    // data['password'] = this.password;
    // data['image'] = this.image;
    // data['type'] = this.type;
    // data['user_type'] = this.userType;
    // data['confirmed'] = this.confirmed;
    // data['api_token'] = this.apiToken;
    // data['updated_at'] = this.updatedAt;
    // data['created_at'] = this.createdAt;
    // data['id'] = this.id;
    return data;
  }

  Map<String, dynamic> login() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['google_token'] = this.googleToken;
    // data['name'] = this.name;
    // data['email'] = this.email;
    // data['lat'] = this.lat;
    // data['lng'] = this.lng;
    // data['address'] = this.address;
    // data['account_number'] = this.accountNumber;
    // data['image'] = this.image;
    // data['type'] = this.type;
    // data['user_type'] = this.userType;
    // data['confirmed'] = this.confirmed;
    // data['api_token'] = this.apiToken;
    // data['updated_at'] = this.updatedAt;
    // data['created_at'] = this.createdAt;
    // data['id'] = this.id;
    return data;
  }
}
