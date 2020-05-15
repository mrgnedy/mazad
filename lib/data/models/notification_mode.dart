import 'package:mazad/data/models/user_home_model.dart';

class NotificationModel {
  String msg;
  AllNotifications data;

  NotificationModel({this.msg, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null
        ? new AllNotifications.fromJson(json['data'])
        : null;
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

class AllNotifications {
  List<Finished> finished;
  List<Operations> operations;
  List<Commissions> commissions;
  List<Finishedforuser> finishedforuser;
  List<dynamic> allNotifications;

  AllNotifications({
    this.finished,
    this.operations,
    this.finishedforuser,
    this.commissions,
  });

  AllNotifications.fromJson(Map<String, dynamic> json) {
    if (json['finished'] != null) {
      finished = new List<Finished>();
      json['finished'].forEach((v) {
        finished.add(new Finished.fromJson(v));
      });
    }
    if (json['operations'] != null) {
      operations = new List<Operations>();
      json['operations'].forEach((v) {
        operations.add(new Operations.fromJson(v));
      });
    }
    if (json['commissions'] != null) {
      commissions = new List<Commissions>();
      json['commissions'].forEach((v) {
        commissions.add(new Commissions.fromJson(v));
      });
    }
    if (json['finishedforuser'] != null) {
      finishedforuser = new List<Finishedforuser>();
      json['finishedforuser'].forEach((v) {
        finishedforuser.add(new Finishedforuser.fromJson(v));
      });
    }
    // if (json['times'] != null) {
    //   times = new List<Null>();
    //   json['times'].forEach((v) {
    //     times.add(new Null.fromJson(v));
    //   });
    // }
    allNotifications = [...finished, ...operations,...finishedforuser];
    allNotifications.sort((a, b) => DateTime.tryParse(b.createdAt.toString())
        ?.compareTo(DateTime.tryParse(a.createdAt.toString())));
    allNotifications.insertAll(0, commissions);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.finished != null) {
      data['finished'] = this.finished.map((v) => v.toJson()).toList();
    }
    if (this.operations != null) {
      data['operations'] = this.operations.map((v) => v.toJson()).toList();
    }
    if (this.commissions != null) {
      data['commissions'] = this.commissions.map((v) => v.toJson()).toList();
    }
    // if (this.times != null) {
    //   data['times'] = this.times.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Finished {
  int id;
  String title;
  String body;
  String createdAt;
  String updatedAt;
  User user;
  AuctionData auction;

  Finished(
      {this.id,
      this.title,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.auction});

  Finished.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    auction = json['auction'] != null
        ? new AuctionData.fromJson(json['auction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.auction != null) {
      data['auction'] = this.auction.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String phone;
  String accountNumber;
  String type;
  int userType;
  String address;
  String image;
  String lat;
  String lng;
  int confirmed;
  String email;
  String emailVerifiedAt;
  String apiToken;
  String googleToken;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
      this.name,
      this.phone,
      this.accountNumber,
      this.type,
      this.userType,
      this.address,
      this.image,
      this.lat,
      this.lng,
      this.confirmed,
      this.email,
      this.emailVerifiedAt,
      this.apiToken,
      this.googleToken,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    accountNumber = json['account_number'];
    type = json['type'];
    userType = json['user_type'];
    address = json['address'];
    image = json['image'];
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    confirmed = json['confirmed'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    apiToken = json['api_token'];
    googleToken = json['google_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['account_number'] = this.accountNumber;
    data['type'] = this.type;
    data['user_type'] = this.userType;
    data['address'] = this.address;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['confirmed'] = this.confirmed;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['api_token'] = this.apiToken;
    data['google_token'] = this.googleToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Operations {
  int id;
  String title;
  String body;
  String createdAt;
  String updatedAt;
  AuctionData auction;

  Operations(
      {this.id,
      this.title,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.auction});

  Operations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    auction = json['auction'] != null
        ? new AuctionData.fromJson(json['auction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.auction != null) {
      data['auction'] = this.auction.toJson();
    }
    return data;
  }
}

class Commissions {
  int id;
  String title;
  String body;
  String createdAt;
  String updatedAt;

  Commissions({this.id, this.title, this.body, this.createdAt, this.updatedAt});

  Commissions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Finishedforuser {
  int id;
  String title;
  String body;
  String createdAt;
  String updatedAt;
  User user;
  AuctionData auction;

  Finishedforuser(
      {this.id,
      this.title,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.auction});

  Finishedforuser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    auction = json['auction'] != null
        ? new AuctionData.fromJson(json['auction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.auction != null) {
      data['auction'] = this.auction.toJson();
    }
  return data;
  }
}
