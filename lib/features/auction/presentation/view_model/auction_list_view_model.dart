import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/auction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuctionListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAuctions extends AuctionListEvent {
  final int page;
  final int limit;
  final String? searchQuery;

  LoadAuctions({this.page = 1, this.limit = 8, this.searchQuery});

  @override
  List<Object?> get props => [page, limit, searchQuery];
}

class LoadMoreAuctions extends AuctionListEvent {
  @override
  List<Object?> get props => [];
}

class SearchAuctions extends AuctionListEvent {
  final String query;

  SearchAuctions(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class AuctionListState extends Equatable {
  final List<AuctionEntity> auctions;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasMoreData;

  const AuctionListState({
    required this.auctions,
    required this.isLoading,
    this.errorMessage,
    required this.currentPage,
    required this.hasMoreData,
  });

  @override
  List<Object?> get props => [
    auctions,
    isLoading,
    errorMessage,
    currentPage,
    hasMoreData,
  ];
}

class AuctionListInitial extends AuctionListState {
  const AuctionListInitial()
    : super(
        auctions: const [],
        isLoading: false,
        currentPage: 1,
        hasMoreData: true,
      );
}

class AuctionListLoading extends AuctionListState {
  const AuctionListLoading({
    required super.auctions,
    required super.currentPage,
    required super.hasMoreData,
  }) : super(
         isLoading: true,
       );
}

class AuctionListLoaded extends AuctionListState {
  const AuctionListLoaded({
    required super.auctions,
    required super.currentPage,
    required super.hasMoreData,
  }) : super(
         isLoading: false,
       );
}

class AuctionListError extends AuctionListState {
  final String message;

  const AuctionListError({
    required this.message,
    required super.auctions,
    required super.currentPage,
    required super.hasMoreData,
  }) : super(
         isLoading: false,
         errorMessage: message,
       );

  @override
  List<Object?> get props => [message, ...super.props];
}

// ViewModel
class AuctionListViewModel extends Bloc<AuctionListEvent, AuctionListState> {
  final IAuctionRepository _auctionRepository;
  String? _currentSearchQuery;

  AuctionListViewModel({required IAuctionRepository auctionRepository})
    : _auctionRepository = auctionRepository,
      super(const AuctionListInitial()) {
    on<LoadAuctions>(_onLoadAuctions);
    on<LoadMoreAuctions>(_onLoadMoreAuctions);
    on<SearchAuctions>(_onSearchAuctions);
  }

  Future<void> _onLoadAuctions(
    LoadAuctions event,
    Emitter<AuctionListState> emit,
  ) async {
    try {
      emit(
        AuctionListLoading(
          auctions: const [],
          currentPage: 1,
          hasMoreData: true,
        ),
      );

      final result = await _auctionRepository.getAllAuctions(
        page: event.page,
        limit: event.limit,
        searchQuery: event.searchQuery,
      );

      result.fold(
        (failure) {
          print('Auction list error: ${failure.message}');
          emit(
            AuctionListError(
              message: failure.message,
              auctions: const [],
              currentPage: 1,
              hasMoreData: true,
            ),
          );
        },
        (paginatedAuctions) {
          print('Loaded ${paginatedAuctions.products.length} auctions');
          emit(
            AuctionListLoaded(
              auctions: paginatedAuctions.products,
              currentPage: event.page,
              hasMoreData: event.page < paginatedAuctions.totalPages,
            ),
          );
        },
      );
    } catch (e) {
      print('Auction list exception: $e');
      emit(
        AuctionListError(
          message: e.toString(),
          auctions: const [],
          currentPage: 1,
          hasMoreData: true,
        ),
      );
    }
  }

  Future<void> _onLoadMoreAuctions(
    LoadMoreAuctions event,
    Emitter<AuctionListState> emit,
  ) async {
    if (state.isLoading || !state.hasMoreData) return;

    try {
      emit(
        AuctionListLoading(
          auctions: state.auctions,
          currentPage: state.currentPage,
          hasMoreData: state.hasMoreData,
        ),
      );

      final nextPage = state.currentPage + 1;
      final result = await _auctionRepository.getAllAuctions(
        page: nextPage,
        limit: 8,
        searchQuery: _currentSearchQuery,
      );

      result.fold(
        (failure) {
          emit(
            AuctionListError(
              message: failure.message,
              auctions: state.auctions,
              currentPage: state.currentPage,
              hasMoreData: state.hasMoreData,
            ),
          );
        },
        (paginatedAuctions) {
          final updatedAuctions = [
            ...state.auctions,
            ...paginatedAuctions.products,
          ];
          emit(
            AuctionListLoaded(
              auctions: updatedAuctions,
              currentPage: nextPage,
              hasMoreData: nextPage < paginatedAuctions.totalPages,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        AuctionListError(
          message: e.toString(),
          auctions: state.auctions,
          currentPage: state.currentPage,
          hasMoreData: state.hasMoreData,
        ),
      );
    }
  }

  Future<void> _onSearchAuctions(
    SearchAuctions event,
    Emitter<AuctionListState> emit,
  ) async {
    _currentSearchQuery = event.query;

    // Reset to first page when searching
    add(
      LoadAuctions(
        page: 1,
        limit: 8,
        searchQuery: event.query.isEmpty ? null : event.query,
      ),
    );
  }

  void loadAuctions() {
    add(LoadAuctions());
  }

  void loadMoreAuctions() {
    add(LoadMoreAuctions());
  }

  void searchAuctions(String query) {
    add(SearchAuctions(query));
  }
}
