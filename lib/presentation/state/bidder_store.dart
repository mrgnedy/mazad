import 'package:mazad/data/models/categories_model.dart';
import 'package:mazad/data/models/general_model.dart';
import 'package:mazad/data/models/user_home_model.dart';
import 'package:mazad/data/repos/bidder_repo.dart';

class BidderStore{
  UserHomeModel allAuctions;
  CategoriesModel categoriesModel;
  CategoriesModel cititesModel;
  BidderRepo bidderRepo = BidderRepo();

  Future<UserHomeModel> getAllAuctions()async{
    allAuctions = UserHomeModel.fromJson(await bidderRepo. getAllAuctions());
    return allAuctions;
  }
  Future<GeneralModel> addOperation(int price, int auctionID)async{
    return GeneralModel.fromJson(await bidderRepo.addOperation(auctionID, price));
  }
  Future<CategoriesModel> getCategories()async{
    categoriesModel = CategoriesModel.fromJson(await bidderRepo.getCats());
    return categoriesModel;
  }
  Future<CategoriesModel> getCities()async{
    cititesModel = CategoriesModel.fromJson(await bidderRepo.getCities());
    return categoriesModel;
  }

  Future<GeneralModel> addBalance(String price, String imagePath)async{
    return GeneralModel.fromJson(await bidderRepo.addBalance(price, imagePath));
  }
}