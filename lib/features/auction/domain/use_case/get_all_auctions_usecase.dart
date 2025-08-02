import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auction/domain/entity/paginated_auctions_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/auction_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllAuctionsUseCase {
  final IAuctionRepository _auctionRepository;

  GetAllAuctionsUseCase({required IAuctionRepository auctionRepository})
      : _auctionRepository = auctionRepository;

  Future<Either<Failure, PaginatedAuctionsEntity>> call({
    int page = 1,
    int limit = 8,
    String? searchQuery,
  }) async {
    return await _auctionRepository.getAllAuctions(
      page: page,
      limit: limit,
      searchQuery: searchQuery,
    );
  }
} 