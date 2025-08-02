import 'dart:io';
import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/domain/repository/auction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CreateAuctionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateAuction extends CreateAuctionEvent {
  final String name;
  final String description;
  final double startingPrice;
  final DateTime endTime;
  final List<File> images;

  CreateAuction({
    required this.name,
    required this.description,
    required this.startingPrice,
    required this.endTime,
    required this.images,
  });

  @override
  List<Object?> get props => [
    name,
    description,
    startingPrice,
    endTime,
    images,
  ];
}

// States
abstract class CreateAuctionState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final AuctionEntity? createdAuction;

  const CreateAuctionState({
    required this.isLoading,
    this.errorMessage,
    this.createdAuction,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage, createdAuction];
}

class CreateAuctionInitial extends CreateAuctionState {
  const CreateAuctionInitial() : super(isLoading: false);
}

class CreateAuctionLoading extends CreateAuctionState {
  const CreateAuctionLoading() : super(isLoading: true);
}

class CreateAuctionSuccess extends CreateAuctionState {
  const CreateAuctionSuccess({required AuctionEntity auction})
    : super(isLoading: false, createdAuction: auction);
}

class CreateAuctionError extends CreateAuctionState {
  final String message;

  const CreateAuctionError({required this.message})
    : super(isLoading: false, errorMessage: message);

  @override
  List<Object?> get props => [message, ...super.props];
}

// ViewModel
class CreateAuctionViewModel
    extends Bloc<CreateAuctionEvent, CreateAuctionState> {
  final IAuctionRepository _auctionRepository;

  CreateAuctionViewModel({required IAuctionRepository auctionRepository})
    : _auctionRepository = auctionRepository,
      super(const CreateAuctionInitial()) {
    on<CreateAuction>(_onCreateAuction);
  }

  Future<void> _onCreateAuction(
    CreateAuction event,
    Emitter<CreateAuctionState> emit,
  ) async {
    try {
      emit(const CreateAuctionLoading());

      print('Creating auction: ${event.name}');
      final result = await _auctionRepository.createAuction(
        name: event.name,
        description: event.description,
        startingPrice: event.startingPrice,
        endTime: event.endTime,
        images: event.images,
      );

      result.fold(
        (failure) {
          print('Create auction error: ${failure.message}');
          emit(CreateAuctionError(message: failure.message));
        },
        (auction) {
          print('Auction created successfully: ${auction.id}');
          emit(CreateAuctionSuccess(auction: auction));
        },
      );
    } catch (e) {
      print('Create auction exception: $e');
      emit(CreateAuctionError(message: e.toString()));
    }
  }

  void createAuction({
    required String name,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required List<File> images,
  }) {
    add(
      CreateAuction(
        name: name,
        description: description,
        startingPrice: startingPrice,
        endTime: endTime,
        images: images,
      ),
    );
  }
}
