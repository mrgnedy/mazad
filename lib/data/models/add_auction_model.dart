import 'package:mazad/data/models/user_home_model.dart';

class AddAuctionModel {
  String msg;
  AuctionData data;

  AddAuctionModel({this.msg, this.data});

  AddAuctionModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new AuctionData.fromJson(json['data']) : null;
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
