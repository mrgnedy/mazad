class SettingsModel {
  String msg;
  SettingsInfo data;

  SettingsModel({this.msg, this.data});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new SettingsInfo.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class SettingsInfo {
  int id;
  String siteName;
  String siteLogo;
  String usage;
  String policy;
  String about;
  String firstPhone;
  String secondPhone;
  String instgram;
  String twitter;
  String facebook;
  String google;
  String livecommission;
  String dailycommission;
  String weekcommission;
  String image;
  String createdAt;
  String updatedAt;

  SettingsInfo(
      {this.id,
      this.siteName,
      this.siteLogo,
      this.usage,
      this.policy,
      this.about,
      this.firstPhone,
      this.secondPhone,
      this.instgram,
      this.twitter,
      this.image,
      this.facebook,
      this.google,
      this.livecommission,
      this.dailycommission,
      this.weekcommission,
      this.createdAt,
      this.updatedAt});

  SettingsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['site_name'];
    siteLogo = json['site_logo'];
    usage = json['usage'];
    policy = json['policy'];
    about = json['about'];
    firstPhone = json['first_phone'];
    secondPhone = json['second_phone'];
    instgram = json['instgram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    google = json['google'];
    image = json['image'].toString();
    livecommission = json['livecommission'];
    dailycommission = json['dailycommission'];
    weekcommission = json['weekcommission'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_name'] = this.siteName;
    data['site_logo'] = this.siteLogo;
    data['usage'] = this.usage;
    data['policy'] = this.policy;
    data['about'] = this.about;
    data['first_phone'] = this.firstPhone;
    data['second_phone'] = this.secondPhone;
    data['instgram'] = this.instgram;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    data['google'] = this.google;
    data['livecommission'] = this.livecommission;
    data['dailycommission'] = this.dailycommission;
    data['weekcommission'] = this.weekcommission;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
