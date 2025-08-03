import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:dartz/dartz.dart';

class PaginatedBiddingRooms {
  final List<BiddingRoomEntity> products;
  final int totalPages;

  PaginatedBiddingRooms({required this.products, required this.totalPages});
}

abstract class ProductRepository {
  Future<Either<Failure, PaginatedBiddingRooms>> getAllBiddingRooms({required int page, String? searchQuery});
  Future<Either<Failure, BiddingRoomEntity>> getBiddingRoomById({required String id});
  Future<Either<Failure, BiddingRoomEntity>> placeBid({required String productId, required double amount});
}