import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:equatable/equatable.dart';

class PaginatedAuctionsEntity extends Equatable {
  final List<AuctionEntity> products;
  final int page;
  final int totalPages;

  const PaginatedAuctionsEntity({
    required this.products,
    required this.page,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [products, page, totalPages];
}