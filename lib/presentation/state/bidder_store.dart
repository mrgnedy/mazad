import 'package:mazad/data/models/general_model.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/data/repos/bidder_repo.dart';

class BidderStore{
  UserHomeModel allAuctions;
  BidderRepo bidderRepo = BidderRepo();

  Future<UserHomeModel> getAllAuctions()async{
    allAuctions = UserHomeModel.fromJson(await bidderRepo. getAllAuctions());
    return allAuctions;
  }
  Future<GeneralModel> addOperation(int price, int auctionID)async{
    return GeneralModel.fromJson(await bidderRepo.addOperation(auctionID, price));
  }
}