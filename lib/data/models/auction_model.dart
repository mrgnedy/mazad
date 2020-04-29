import 'package:mazad/data/models/user_home_model.dart';

class AuctionModel {
  String msg;
  List<AuctionD> data;

  AuctionModel({this.msg, this.data});

  AuctionModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<AuctionD>();
      json['data'].forEach((v) {
        data.add(new AuctionD.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuctionD {
  AuctionData auction;
  List<Operations> operations;

  AuctionD({this.auction, this.operations});

  AuctionD.fromJson(Map<String, dynamic> json) {
    auction =
        json['auction'] != null ? new AuctionData.fromJson(json['auction']) : null;
    if (json['operations'] != null) {
      operations = new List<Operations>();
      json['operations'].forEach((v) {
        operations.add(new Operations.fromJson(v));
      });
       operations.sort((a,b)=>num.tryParse(b.price).compareTo(num.tryParse(a.price)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.auction != null) {
      data['auction'] = this.auction.toJson();
    }
    if (this.operations != null) {
      data['operations'] = this.operations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Operations {
  int id;
  int userId;
  String userName;
  String userImage;
  String price;

  Operations({this.id, this.userName, this.userImage, this.price, this.userId});

  Operations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    userId = json['user_id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['price'] = this.price;
    data['user_id'] = this.userId;
    return data;
  }
}
