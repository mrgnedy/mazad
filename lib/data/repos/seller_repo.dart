import 'package:mazad/core/api_utils.dart';

class SellerRepo {

  Future getMyAuctions() async{
    String url = APIs.myauctionsEP;
    return await APIs.getRequest(url);
  }

  Future addMazad(Map<String, String> body, List imageList, List imageNames)async{
    String url = APIs.addmazadEP;
    return await APIs.postWithFile(url, body, additionalFiles: imageList, additionalFilesField: 'image', additionalFilesNames: imageNames);
  }

  Future finishAuction(String auctionID)async{
    String url = APIs.finishauctionEP;
    Map<String, dynamic> body = {'auction_id': '$auctionID'};
    return await APIs.postRequest(url, body);
  }      
  Future getAuctionDetails(String auctionID)async{
    String url = APIs.showauctionEP;
    Map<String, dynamic> body = {'auction_id': '$auctionID'};
    return await APIs.postRequest(url, body);
  }      

  Future addCommission(String price, String image )async{
    String url = APIs.addcommissionEP;
    Map<String, String> body = {'price': '$price'};
    return await APIs.postWithFile(url, body, filePath: image, fileName: 'image');
  }
}