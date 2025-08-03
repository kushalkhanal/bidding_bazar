import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetAllBiddingRooms implements UseCase<PaginatedBiddingRooms, PageParams> {
  final ProductRepository repository;
  GetAllBiddingRooms(this.repository);

  @override
  Future<Either<Failure, PaginatedBiddingRooms>> call(PageParams params) async {
    return await repository.getAllBiddingRooms(page: params.page, searchQuery: params.searchQuery);
  }
}

class PageParams extends Equatable {
  final int page;
  final String? searchQuery;
  const PageParams({required this.page, this.searchQuery});

  @override
  List<Object?> get props => [page, searchQuery];
}