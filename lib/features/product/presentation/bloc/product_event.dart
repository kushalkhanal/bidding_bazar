part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductByIdEvent extends ProductEvent {
  final String id;
  const FetchProductByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateProductDetailEvent extends ProductEvent {
  final BiddingRoomEntity product;
  const UpdateProductDetailEvent(this.product);

  @override
  List<Object> get props => [product];
}

class PlaceBidEvent extends ProductEvent {
  final String productId;
  final double amount;

  const PlaceBidEvent({required this.productId, required this.amount});

  @override
  List<Object> get props => [productId, amount];
}