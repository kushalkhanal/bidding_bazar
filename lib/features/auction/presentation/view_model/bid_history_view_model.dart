import 'package:bidding_bazar/features/auction/domain/entity/bid_history_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/bid_history_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class BidHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserBidHistory extends BidHistoryEvent {
  final int page;
  final int limit;

  LoadUserBidHistory({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class LoadAuctionBidHistory extends BidHistoryEvent {
  final String auctionId;
  final int page;
  final int limit;

  LoadAuctionBidHistory({
    required this.auctionId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [auctionId, page, limit];
}

class LoadMoreBidHistory extends BidHistoryEvent {
  @override
  List<Object?> get props => [];
}

// States
abstract class BidHistoryState extends Equatable {
  final List<BidHistoryEntity> bidHistory;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasMoreData;

  const BidHistoryState({
    required this.bidHistory,
    required this.isLoading,
    this.errorMessage,
    required this.currentPage,
    required this.hasMoreData,
  });

  @override
  List<Object?> get props => [
    bidHistory,
    isLoading,
    errorMessage,
    currentPage,
    hasMoreData,
  ];
}

class BidHistoryInitial extends BidHistoryState {
  const BidHistoryInitial()
    : super(
        bidHistory: const [],
        isLoading: false,
        currentPage: 1,
        hasMoreData: true,
      );
}

class BidHistoryLoading extends BidHistoryState {
  const BidHistoryLoading({
    required super.bidHistory,
    required super.currentPage,
    required super.hasMoreData,
  }) : super(
         isLoading: true,
       );
}

class BidHistoryLoaded extends BidHistoryState {
  const BidHistoryLoaded({
    required super.bidHistory,
    required super.currentPage,
    required super.hasMoreData,
  }) : super(
         isLoading: false,
       );
}

class BidHistoryError extends BidHistoryState {
  final String message;

  const BidHistoryError({
    required this.message,
    required super.bidHistory,
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
class BidHistoryViewModel extends Bloc<BidHistoryEvent, BidHistoryState> {
  final IBidHistoryRepository _bidHistoryRepository;
  String? _currentAuctionId;

  BidHistoryViewModel({required IBidHistoryRepository bidHistoryRepository})
    : _bidHistoryRepository = bidHistoryRepository,
      super(const BidHistoryInitial()) {
    on<LoadUserBidHistory>(_onLoadUserBidHistory);
    on<LoadAuctionBidHistory>(_onLoadAuctionBidHistory);
    on<LoadMoreBidHistory>(_onLoadMoreBidHistory);
  }

  Future<void> _onLoadUserBidHistory(
    LoadUserBidHistory event,
    Emitter<BidHistoryState> emit,
  ) async {
    try {
      emit(
        BidHistoryLoading(
          bidHistory: const [],
          currentPage: 1,
          hasMoreData: true,
        ),
      );

      final result = await _bidHistoryRepository.getUserBidHistory(
        page: event.page,
        limit: event.limit,
      );

      result.fold(
        (failure) {
          emit(
            BidHistoryError(
              message: failure.message,
              bidHistory: const [],
              currentPage: 1,
              hasMoreData: true,
            ),
          );
        },
        (paginatedBidHistory) {
          emit(
            BidHistoryLoaded(
              bidHistory: paginatedBidHistory.bidHistory,
              currentPage: event.page,
              hasMoreData: event.page < paginatedBidHistory.totalPages,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        BidHistoryError(
          message: e.toString(),
          bidHistory: const [],
          currentPage: 1,
          hasMoreData: true,
        ),
      );
    }
  }

  Future<void> _onLoadAuctionBidHistory(
    LoadAuctionBidHistory event,
    Emitter<BidHistoryState> emit,
  ) async {
    try {
      _currentAuctionId = event.auctionId;
      emit(
        BidHistoryLoading(
          bidHistory: const [],
          currentPage: 1,
          hasMoreData: true,
        ),
      );

      final result = await _bidHistoryRepository.getAuctionBidHistory(
        auctionId: event.auctionId,
        page: event.page,
        limit: event.limit,
      );

      result.fold(
        (failure) {
          emit(
            BidHistoryError(
              message: failure.message,
              bidHistory: const [],
              currentPage: 1,
              hasMoreData: true,
            ),
          );
        },
        (paginatedBidHistory) {
          emit(
            BidHistoryLoaded(
              bidHistory: paginatedBidHistory.bidHistory,
              currentPage: event.page,
              hasMoreData: event.page < paginatedBidHistory.totalPages,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        BidHistoryError(
          message: e.toString(),
          bidHistory: const [],
          currentPage: 1,
          hasMoreData: true,
        ),
      );
    }
  }

  Future<void> _onLoadMoreBidHistory(
    LoadMoreBidHistory event,
    Emitter<BidHistoryState> emit,
  ) async {
    if (state.isLoading || !state.hasMoreData) return;

    try {
      emit(
        BidHistoryLoading(
          bidHistory: state.bidHistory,
          currentPage: state.currentPage,
          hasMoreData: state.hasMoreData,
        ),
      );

      final nextPage = state.currentPage + 1;
      
      if (_currentAuctionId != null) {
        // Load more auction bid history
        final result = await _bidHistoryRepository.getAuctionBidHistory(
          auctionId: _currentAuctionId!,
          page: nextPage,
          limit: 10,
        );

        result.fold(
          (failure) {
            emit(
              BidHistoryError(
                message: failure.message,
                bidHistory: state.bidHistory,
                currentPage: state.currentPage,
                hasMoreData: state.hasMoreData,
              ),
            );
          },
          (paginatedBidHistory) {
            final updatedBidHistory = [
              ...state.bidHistory,
              ...paginatedBidHistory.bidHistory,
            ];
            emit(
              BidHistoryLoaded(
                bidHistory: updatedBidHistory,
                currentPage: nextPage,
                hasMoreData: nextPage < paginatedBidHistory.totalPages,
              ),
            );
          },
        );
      } else {
        // Load more user bid history
        final result = await _bidHistoryRepository.getUserBidHistory(
          page: nextPage,
          limit: 10,
        );

        result.fold(
          (failure) {
            emit(
              BidHistoryError(
                message: failure.message,
                bidHistory: state.bidHistory,
                currentPage: state.currentPage,
                hasMoreData: state.hasMoreData,
              ),
            );
          },
          (paginatedBidHistory) {
            final updatedBidHistory = [
              ...state.bidHistory,
              ...paginatedBidHistory.bidHistory,
            ];
            emit(
              BidHistoryLoaded(
                bidHistory: updatedBidHistory,
                currentPage: nextPage,
                hasMoreData: nextPage < paginatedBidHistory.totalPages,
              ),
            );
          },
        );
      }
    } catch (e) {
      emit(
        BidHistoryError(
          message: e.toString(),
          bidHistory: state.bidHistory,
          currentPage: state.currentPage,
          hasMoreData: state.hasMoreData,
        ),
      );
    }
  }

  void loadUserBidHistory({int page = 1, int limit = 10}) {
    add(LoadUserBidHistory(page: page, limit: limit));
  }

  void loadAuctionBidHistory({
    required String auctionId,
    int page = 1,
    int limit = 10,
  }) {
    add(LoadAuctionBidHistory(
      auctionId: auctionId,
      page: page,
      limit: limit,
    ));
  }

  void loadMoreBidHistory() {
    add(LoadMoreBidHistory());
  }
} 