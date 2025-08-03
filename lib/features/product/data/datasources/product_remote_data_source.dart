import 'package:bidding_bazar/core/api/api_client.dart';
import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/features/product/data/models/bidding_room_model.dart';
import 'package:dio/dio.dart';

abstract class ProductRemoteDataSource {
  Future<Map<String, dynamic>> getAllBiddingRooms({required int page, String? searchQuery});
  Future<BiddingRoomModel> getBiddingRoomById({required String id});
    Future<BiddingRoomModel> placeBid({required String productId, required double amount});

}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;
  late final Dio _dio;

  ProductRemoteDataSourceImpl({required this.apiClient}) {
    _dio = apiClient.instance;
  }

  @override
  Future<Map<String, dynamic>> getAllBiddingRooms({required int page, String? searchQuery}) async {
    try {
      // --- FIX: Explicitly declare the map type to be Map<String, dynamic> ---
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': 10,
      };
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        // Now it's perfectly valid to add a String value.
        queryParameters['search'] = searchQuery;
      }

      final response = await _dio.get('/bidding-rooms', queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<BiddingRoomModel> getBiddingRoomById({required String id}) async {
     try {
      final response = await _dio.get('/bidding-rooms/$id');
      if (response.statusCode == 200) {
        return BiddingRoomModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<BiddingRoomModel> placeBid({required String productId, required double amount}) async {
    try {
      final response = await _dio.post(
        '/bidding-rooms/$productId/bids',
        data: {'amount': amount},
      );
      if (response.statusCode == 201 && response.data?['room'] != null) {
        // Your backend nests the updated room in a 'room' key
        return BiddingRoomModel.fromJson(response.data['room']);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      // Re-throw the DioException so the repository can parse the error message
      rethrow;
    }
  }
}