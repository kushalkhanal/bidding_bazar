import 'dart:io';
import 'package:bidding_bazar/features/auction/data/model/auction_model.dart';
import 'package:bidding_bazar/features/auction/data/model/paginated_auction_model.dart';

abstract class IAuctionDataSource {
  Future<PaginatedAuctionsModel> getAllAuctions({
    int page = 1,
    int limit = 8,
    String? searchQuery,
  });

  Future<AuctionModel> getAuctionById(String id);

  Future<AuctionModel> createAuction({
    required String name,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required List<File> images,
  });

  Future<AuctionModel> placeBid({
    required String auctionId,
    required double amount,
  });
}