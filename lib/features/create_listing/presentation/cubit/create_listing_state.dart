part of 'create_listing_cubit.dart';

abstract class CreateListingState extends Equatable {
  const CreateListingState();

  @override
  List<Object> get props => [];
}

class CreateListingInitial extends CreateListingState {}

class CreateListingLoading extends CreateListingState {}

class CreateListingSuccess extends CreateListingState {}

class CreateListingFailure extends CreateListingState {
  final String message;
  const CreateListingFailure(this.message);

  @override
  List<Object> get props => [message];
}