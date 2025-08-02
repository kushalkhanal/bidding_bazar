import 'package:bidding_bazar/app/constant/api_enpoints.dart';
import 'package:bidding_bazar/core/network/api_service.dart';
import 'package:bidding_bazar/features/auction/data/data_source/bid_history_data_source.dart';
import 'package:bidding_bazar/features/auction/data/model/paginated_bid_history_model.dart';

class BidHistoryRemoteDataSource implements IBidHistoryDataSource {
  final ApiService _apiService;

  BidHistoryRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<PaginatedBidHistoryModel> getUserBidHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.bidHistory}/user',
        queryParameters: {'page': page, 'limit': limit},
      );

      // Use async parsing to offload JSON parsing to isolate
      return await PaginatedBidHistoryModel.fromJsonAsync(response.data);
    } catch (e) {
      print('Error fetching user bid history: $e');
      rethrow;
    }
  }

  @override
  Future<PaginatedBidHistoryModel> getAuctionBidHistory({
    required String auctionId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.bidHistory}/auction/$auctionId',
        queryParameters: {'page': page, 'limit': limit},
      );

      // Use async parsing to offload JSON parsing to isolate
      return await PaginatedBidHistoryModel.fromJsonAsync(response.data);
    } catch (e) {
      print('Error fetching auction bid history: $e');
      rethrow;
    }
  }
}
