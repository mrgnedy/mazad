import 'package:mazad/data/models/add_auction_model.dart';
import 'package:mazad/data/models/auction_model.dart';
import 'package:mazad/data/models/general_model.dart';
import 'package:mazad/data/models/my_auctions.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/data/repos/seller_repo.dart';

class SellerStore {
  SellerRepo sellerRepo = SellerRepo();
  MyAuctionsModel auctionsModel;
  AuctionModel currentAuction;

  Future<MyAuctionsModel> getMyAuctions()async{
    auctionsModel =  MyAuctionsModel.fromJson(await sellerRepo.getMyAuctions());
    return auctionsModel;
  }

  Future<AddAuctionModel> addAuction(AuctionData auctionData, List<List<int>> imageList, List<String> imageNames)async {
    return AddAuctionModel.fromJson(await sellerRepo.addMazad(auctionData.toJson(), imageList, imageNames));
  }
   
  Future<GeneralModel> finishAuction(String auctionID)async{
    return GeneralModel.fromJson(await sellerRepo.finishAuction(auctionID));
  } 

  Future<GeneralModel> addCommission(String price, String image)async{
    return GeneralModel.fromJson(await sellerRepo.addCommission(price, image));
  }

  Future<AuctionModel> getAuctionDetails(int id)async{
    currentAuction = 
    AuctionModel.fromJson(await sellerRepo.getAuctionDetails(id.toString()));
    return currentAuction; 
  }
  Future<GeneralModel> deleteAuction(int auctionID)async{
    return GeneralModel.fromJson(await sellerRepo.deleteAuction(auctionID));
  }
  Future<GeneralModel> returnAuction(int auctionID)async{
    return GeneralModel.fromJson(await sellerRepo.returnAuction(auctionID));
  }

  Future<GeneralModel> editDetails(int auctionID, String desc)async{
    return GeneralModel.fromJson(await sellerRepo.editDetails(auctionID, desc));
  }
  Future<GeneralModel> editPrice(int opID, String price)async{
    return GeneralModel.fromJson(await sellerRepo.editPrice(opID, price));
  }
}