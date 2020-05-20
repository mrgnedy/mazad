import 'user_home_model.dart';

class MyAuctionsModel {
  String msg;
  MyAuctions data;

  MyAuctionsModel({this.msg, this.data});

  MyAuctionsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new MyAuctions.fromJson(json['data']) : null;
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

class MyAuctions {
  List<AuctionData> intialactions;
  List<AuctionData> finishactions;
  MyAuctions({this.intialactions, this.finishactions});

  MyAuctions.fromJson(Map<String, dynamic> json) {
    if (json['intialactions'] != null) {
      intialactions = new List<AuctionData>();
      json['intialactions'].forEach((v) {
        intialactions.add(new AuctionData.fromJson(v));
      });
      intialactions = intialactions.reversed.toList();
    }
    if (json['finishactions'] != null) {
      finishactions = new List<AuctionData>();
      json['finishactions'].forEach((v) {
        finishactions.add(new AuctionData.fromJson(v));
      });
      finishactions = finishactions.reversed.toList();
    }
    
    finishactions.addAll(intialactions.where((auction)=>auction.isFinished));
    intialactions.removeWhere((auction)=>auction.isFinished);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.intialactions != null) {
      data['intialactions'] =
          this.intialactions.map((v) => v.toJson()).toList();
    }
    if (this.finishactions != null) {
      data['finishactions'] =
          this.finishactions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
