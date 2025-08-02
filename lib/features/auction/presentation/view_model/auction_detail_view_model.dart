import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/auction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuctionDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAuction extends AuctionDetailEvent {
  final String auctionId;

  LoadAuction(this.auctionId);

  @override
  List<Object?> get props => [auctionId];
}

class PlaceBid extends AuctionDetailEvent {
  final String auctionId;
  final double amount;

  PlaceBid({required this.auctionId, required this.amount});

  @override
  List<Object?> get props => [auctionId, amount];
}

// States
abstract class AuctionDetailState extends Equatable {
  final AuctionEntity? auction;
  final bool isLoading;
  final String? errorMessage;

  const AuctionDetailState({
    this.auction,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [auction, isLoading, errorMessage];
}

class AuctionDetailInitial extends AuctionDetailState {
  const AuctionDetailInitial()
      : super(
          auction: null,
          isLoading: false,
        );
}

class AuctionDetailLoading extends AuctionDetailState {
  const AuctionDetailLoading({super.auction})
      : super(
          isLoading: true,
        );
}

class AuctionDetailLoaded extends AuctionDetailState {
  const AuctionDetailLoaded({required AuctionEntity auction})
      : super(
          auction: auction,
          isLoading: false,
        );
}

class AuctionDetailError extends AuctionDetailState {
  final String message;

  const AuctionDetailError({
    required this.message,
    super.auction,
  }) : super(
          isLoading: false,
          errorMessage: message,
        );

  @override
  List<Object?> get props => [message, ...super.props];
}

// ViewModel
class AuctionDetailViewModel extends Bloc<AuctionDetailEvent, AuctionDetailState> {
  final IAuctionRepository _auctionRepository;

  AuctionDetailViewModel({required IAuctionRepository auctionRepository})
      : _auctionRepository = auctionRepository,
        super(const AuctionDetailInitial()) {
    on<LoadAuction>(_onLoadAuction);
    on<PlaceBid>(_onPlaceBid);
  }

  Future<void> _onLoadAuction(
    LoadAuction event,
    Emitter<AuctionDetailState> emit,
  ) async {
    try {
      emit(AuctionDetailLoading(auction: state.auction));

      final result = await _auctionRepository.getAuctionById(event.auctionId);

      result.fold(
        (failure) {
          emit(AuctionDetailError(
            message: failure.message,
            auction: state.auction,
          ));
        },
        (auction) {
          emit(AuctionDetailLoaded(auction: auction));
        },
      );
    } catch (e) {
      emit(AuctionDetailError(
        message: e.toString(),
        auction: state.auction,
      ));
    }
  }

  Future<void> _onPlaceBid(
    PlaceBid event,
    Emitter<AuctionDetailState> emit,
  ) async {
    try {
      emit(AuctionDetailLoading(auction: state.auction));

      final result = await _auctionRepository.placeBid(
        auctionId: event.auctionId,
        amount: event.amount,
      );

      result.fold(
        (failure) {
          emit(AuctionDetailError(
            message: failure.message,
            auction: state.auction,
          ));
        },
        (updatedAuction) {
          emit(AuctionDetailLoaded(auction: updatedAuction));
        },
      );
    } catch (e) {
      emit(AuctionDetailError(
        message: e.toString(),
        auction: state.auction,
      ));
    }
  }

  void loadAuction(String auctionId) {
    add(LoadAuction(auctionId));
  }

  void placeBid({required String auctionId, required double amount}) {
    add(PlaceBid(auctionId: auctionId, amount: amount));
  }
} 