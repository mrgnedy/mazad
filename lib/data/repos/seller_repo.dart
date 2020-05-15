import 'package:mazad/core/api_utils.dart';

class SellerRepo {
  Future getMyAuctions() async {
    String url = APIs.myauctionsEP;
    return await APIs.getRequest(url);
  }

  Future addMazad(
      Map<String, String> body, List imageList, List imageNames) async {
    String url = APIs.addmazadEP;
    return await APIs.postWithFile(url, body,
        additionalFiles: imageList,
        additionalFilesField: 'image',
        additionalFilesNames: imageNames);
  }

  Future finishAuction(String auctionID) async {
    String url = APIs.finishauctionEP;
    Map<String, dynamic> body = {'auction_id': '$auctionID'};
    return await APIs.postRequest(url, body);
  }

  Future getAuctionDetails(String auctionID) async {
    String url = APIs.showauctionEP;
    Map<String, dynamic> body = {'auction_id': '$auctionID'};
    return await APIs.postRequest(url, body);
  }

  Future returnAuction(int auctionID) async {
    String url = APIs.returnauctionEP;
    Map<String, dynamic> body = {'auction_id': '$auctionID'};
    return await APIs.postRequest(url, body);
  }

  Future deleteAuction(int auctionID) async {
    String url = APIs.delauctionEP;
    Map<String, dynamic> body = {'auction_id': '$auctionID'};
    return await APIs.postRequest(url, body);
  }

  Future addCommission(String price, String image) async {
    String url = APIs.addcommissionEP;
    Map<String, String> body = {'price': '$price'};
    return await APIs.postWithFile(url, body,
        filePath: image, fileName: 'image');
  }

  Future editDetails(int auctionID, String desc) async {
    String url = APIs.editmazadEP;
    Map<String, dynamic> body = {'auction_id': '$auctionID', 'desc': '$desc'};
    return await APIs.postRequest(url, body);
  }
  Future editPrice(int opID, String price) async {
    String url = APIs.editpriceEP;
    Map<String, dynamic> body = {'operation_id': '$opID', 'price': '$price'};
    return await APIs.postRequest(url, body);
  }
}
