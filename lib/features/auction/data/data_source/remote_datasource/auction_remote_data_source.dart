import 'dart:io';
import 'package:bidding_bazar/app/constant/api_enpoints.dart';
import 'package:bidding_bazar/core/network/api_service.dart';
import 'package:bidding_bazar/features/auction/data/data_source/auction_data_source.dart';
import 'package:bidding_bazar/features/auction/data/model/auction_model.dart';
import 'package:bidding_bazar/features/auction/data/model/paginated_auction_model.dart';
import 'package:dio/dio.dart';

class AuctionRemoteDataSource implements IAuctionDataSource {
  final ApiService _apiService;

  AuctionRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<PaginatedAuctionsModel> getAllAuctions({
    int page = 1,
    int limit = 8,
    String? searchQuery,
  }) async {
    try {
      print('Fetching auctions: page=$page, limit=$limit, search=$searchQuery');
      final response = await _apiService.dio.get(
        ApiEndpoints.products,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
        },
      );

      print('Auctions response: ${response.data}');
      // Use async parsing to offload JSON parsing to isolate
      return await PaginatedAuctionsModel.fromJsonAsync(response.data);
    } on DioException catch (e) {
      print('DioException in getAllAuctions: ${e.message}');
      print('Response data: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to load auctions');
    } catch (e) {
      print('Exception in getAllAuctions: $e');
      throw Exception('Failed to load auctions: $e');
    }
  }

  @override
  Future<AuctionModel> getAuctionById(String id) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.products}/$id',
      );
      return AuctionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load auction details',
      );
    }
  }

  @override
  Future<AuctionModel> createAuction({
    required String name,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required List<File> images,
  }) async {
    try {
      print('Creating auction: $name');
      List<MultipartFile> imageFiles = [];
      for (var image in images) {
        imageFiles.add(
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        );
      }

      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        'startingPrice': startingPrice,
        'endTime': endTime.toIso8601String(),
        'files': imageFiles, // Your backend expects 'files'
      });

      print('Sending create auction request');
      final response = await _apiService.dio.post(
        ApiEndpoints.products,
        data: formData,
      );

      print('Create auction response: ${response.data}');
      return AuctionModel.fromJson(response.data);
    } on DioException catch (e) {
      print('DioException in createAuction: ${e.message}');
      print('Response data: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create auction',
      );
    } catch (e) {
      print('Exception in createAuction: $e');
      throw Exception('Failed to create auction: $e');
    }
  }

  @override
  Future<AuctionModel> placeBid({
    required String auctionId,
    required double amount,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '${ApiEndpoints.products}/$auctionId/bid',
        data: {'amount': amount},
      );
      return AuctionModel.fromJson(response.data['room']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to place bid');
    }
  }
}
