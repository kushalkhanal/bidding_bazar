import 'package:bidding_bazar/features/auction/data/model/paginated_bid_history_model.dart';

abstract class IBidHistoryDataSource {
  Future<PaginatedBidHistoryModel> getUserBidHistory({
    int page = 1,
    int limit = 10,
  });

  Future<PaginatedBidHistoryModel> getAuctionBidHistory({
    required String auctionId,
    int page = 1,
    int limit = 10,
  });
} 