part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductDetailLoaded extends ProductState {
  final BiddingRoomEntity product;
  const ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}


class BidPlacing extends ProductDetailLoaded {
  const BidPlacing(super.product);
}

class BidSuccess extends ProductDetailLoaded {
  const BidSuccess(super.product);
}

class BidFailure extends ProductDetailLoaded {
  final String message;
  const BidFailure(super.product, this.message);

  @override
  List<Object> get props => [product, message];
}