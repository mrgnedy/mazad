import 'package:mazad/core/api_utils.dart';

class BidderRepo {
  Future getAllAuctions() async {
    String url = APIs.homeEP;
    return await APIs.getRequest(url);
  }

  Future addOperation(int auctionID, int price) async {
    String url = APIs.addoperationEP;
    Map<String, dynamic> body = {'auction_id': '$auctionID', 'price': '$price'};
    return await APIs.postRequest(url, body); 
  }
}
