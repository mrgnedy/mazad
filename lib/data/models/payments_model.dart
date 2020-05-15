class PaymentsModel {
  String msg;
  List<PaymentInfo> data;

  PaymentsModel({this.msg, this.data});

  PaymentsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<PaymentInfo>();
      json['data'].forEach((v) {
        data.add(new PaymentInfo.fromJson(v));
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

class PaymentInfo {
  int id;
  String accountName;
  int accountNumber;
  String iban;
  String image;
  String ownerName;
  String commission;
  String createdAt;
  String updatedAt;

  PaymentInfo(
      {this.id,
      this.accountName,
      this.accountNumber,
      this.iban,
      this.image,
      this.ownerName,
      this.commission,
      this.createdAt,
      this.updatedAt});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    iban = json['iban'];
    image = json['image'];
    ownerName = json['owner_name'];
    commission = json['commission'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    data['iban'] = this.iban;
    data['image'] = this.image;
    data['owner_name'] = this.ownerName;
    data['commission'] = this.commission;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
