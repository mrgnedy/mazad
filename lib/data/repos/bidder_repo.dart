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
  Future getCats()async{
    String url = APIs.categoriesEP;
    return await APIs.getRequest(url);
  }
  Future getCities()async{
    String url = APIs.citiesEP;
    return await APIs.getRequest(url);
  }
}
