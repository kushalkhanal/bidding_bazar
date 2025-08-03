import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/product/data/datasources/product_remote_data_source.dart';
import 'package:bidding_bazar/features/product/data/models/bidding_room_model.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});
  

  @override
  Future<Either<Failure, PaginatedBiddingRooms>> getAllBiddingRooms({required int page, String? searchQuery}) async {
    try {
      final responseMap = await remoteDataSource.getAllBiddingRooms(page: page, searchQuery: searchQuery);
      final products = (responseMap['products'] as List)
          .map((productJson) => BiddingRoomModel.fromJson(productJson))
          .toList();
      final totalPages = responseMap['totalPages'] as int;
      
      return Right(PaginatedBiddingRooms(products: products, totalPages: totalPages));
    } on ServerException {
      return const Left(ServerFailure('Failed to fetch products.'));
    }
  }

  @override
  Future<Either<Failure, BiddingRoomEntity>> getBiddingRoomById({required String id}) async {
    try {
      final product = await remoteDataSource.getBiddingRoomById(id: id);
      return Right(product);
    } on ServerException {
      return const Left(ServerFailure('Failed to fetch product details.'));
    }
  }

   @override
  Future<Either<Failure, BiddingRoomEntity>> placeBid({required String productId, required double amount}) async {
    try {
      final updatedProduct = await remoteDataSource.placeBid(productId: productId, amount: amount);
      return Right(updatedProduct);
    } on DioException catch (e) {
      // Your backend returns a specific error message, e.g., "Bid must be higher..."
      final errorMessage = e.response?.data['message'] ?? 'Failed to place bid.';
      return Left(ServerFailure(errorMessage));
    } on ServerException {
      return const Left(ServerFailure('Failed to place bid.'));
    }
  }
}