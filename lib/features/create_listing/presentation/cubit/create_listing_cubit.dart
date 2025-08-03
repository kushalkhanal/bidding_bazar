import 'package:bidding_bazar/features/create_listing/domain/usecases/create_bidding_room.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_listing_state.dart';

class CreateListingCubit extends Cubit<CreateListingState> {
  final CreateBiddingRoom createBiddingRoom;
  CreateListingCubit(this.createBiddingRoom) : super(CreateListingInitial());

  Future<void> createListing(CreateBiddingRoomParams params) async {
    emit(CreateListingLoading());
    final result = await createBiddingRoom(params);
    result.fold(
      (failure) => emit(CreateListingFailure(failure.message)),
      (_) => emit(CreateListingSuccess()),
    );
  }
}