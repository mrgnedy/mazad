class UserHomeModel {
  String msg;
  AllAuctions data;

  UserHomeModel({this.msg, this.data});

  UserHomeModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new AllAuctions.fromJson(json['data']) : null;
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

class AllAuctions {
  List<AuctionData> mobasherdata;
  List<AuctionData> daysdata;
  List<AuctionData> weeksdata;
  List<AuctionData> allAuctions;
  List<AuctionData> tempAuctions;
  int userID;

  AllAuctions({this.mobasherdata, this.daysdata, this.weeksdata});

  AllAuctions.fromJson(Map<String, dynamic> json) {
    if (json['mobasherdata'] != null) {
      mobasherdata = new List<AuctionData>();
      json['mobasherdata'].forEach((v) {
        mobasherdata.add(new AuctionData.fromJson(v));
      });
    }
    if (json['daysdata'] != null) {
      daysdata = new List<AuctionData>();
      json['daysdata'].forEach((v) {
        daysdata.add(new AuctionData.fromJson(v));
      });
    }
    if (json['weeksdata'] != null) {
      weeksdata = new List<AuctionData>();
      json['weeksdata'].forEach((v) {
        weeksdata.add(new AuctionData.fromJson(v));
      });
    }
    tempAuctions = [...mobasherdata, ...daysdata, ...weeksdata];
    mobasherdata = mobasherdata.reversed.toList()
      ..removeWhere((auction) => auction.isFinished);
    daysdata = daysdata.reversed.toList()
      ..removeWhere((auction) => auction.isFinished);
    weeksdata = weeksdata.reversed.toList()
      ..removeWhere((auction) => auction.isFinished);

      allAuctions = [...mobasherdata, ...daysdata, ...weeksdata];
  }
  
      List<AuctionData> userAuctions(i) => allAuctions.where((auction)=> auction.userId == i).toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mobasherdata != null) {
      data['mobasherdata'] = this.mobasherdata.map((v) => v.toJson()).toList();
    }
    if (this.daysdata != null) {
      data['daysdata'] = this.daysdata.map((v) => v.toJson()).toList();
    }
    if (this.weeksdata != null) {
      data['weeksdata'] = this.weeksdata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuctionData {
  int id;
  int userId;
  String catId;
  String desc;
  String duration;
  String intialPrice;
  String lat;
  String lng;
  String address;
  String type;
  bool isFinished;
  String deletetime;
  String createdAt;
  String cityName;
  String maxvalue;
  String minvalue;
  int cityID;
  String updatedAt;
  List<Images> images;

  AuctionData(
      {this.id,
      this.userId,
      this.catId,
      this.desc,
      this.duration,
      this.intialPrice,
      this.lat,
      this.lng,
      this.cityID,
      this.cityName,
      this.address,
      this.type,
      this.isFinished,
      this.deletetime,
      this.createdAt,
      this.updatedAt,
      this.images,
      this.maxvalue,
      this.minvalue
      });

  AuctionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minvalue = json['minvalue'].toString();
    maxvalue = json['maxvalue'].toString();

    userId = json['user_id'];
    catId = json['cat_id'].toString();
    desc = json['desc'].toString();
    duration = json['duration'].toString();
    intialPrice = json['intial_price'].toString();
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    address = json['address'].toString();
    type = json['type'].toString();
    cityName = json['city'];
    cityID = json['city_id'];
    deletetime = json['deletetime'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    if (deletetime != null && !deletetime.contains('null')) {
      // print(createdAt);
      // Duration dur;
      // switch (duration) {
      //   case '1':
      //     dur = Duration(hours: 12);
      //     break;
      //   case '2':
      //     dur = Duration(hours: 24);
      //     break;
      //   case '3':
      //     dur = Duration(days: 14);
      //     break;
      //   default:
      // }
      DateTime deleteTime = DateTime.tryParse(deletetime).add(Duration(hours: 3));
      isFinished = deleteTime.isBefore(DateTime.now());
      // print('IS FINISHED?     $isFinished');
    }
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['cat_id'] = this.catId;
    data['desc'] = this.desc;
    data['duration'] = this.duration;
    data['intial_price'] = this.intialPrice;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['city_id'] = this.cityID.toString();
    // data['deletetime'] = this.deletetime;
    // data['id'] = this.id;
    // data['user_id'] = this.userId;
    // data['type'] = this.type;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    // if (this.images != null) {
    //   data['images'] = this.images.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Images {
  int id;
  int auctionId;
  String image;
  String createdAt;
  String updatedAt;

  Images({this.id, this.auctionId, this.image, this.createdAt, this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    auctionId = json['auction_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['auction_id'] = this.auctionId;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
