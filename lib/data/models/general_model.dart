class GeneralModel {
  String msg;
  bool status;
  GeneralModel({this.msg});

  GeneralModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = msg.contains('true') || msg.contains('success') ? true : false;
  }
}
