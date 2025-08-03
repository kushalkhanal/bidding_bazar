import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/domain/usecases/get_all_bidding_rooms.dart';
import 'package:bidding_bazar/features/product/domain/usecases/get_bidding_room_by_id.dart';
import 'package:bidding_bazar/features/product/domain/usecases/place_bid.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllBiddingRooms getAllBiddingRooms;
  final GetBiddingRoomById getBiddingRoomById;

    final PlaceBid placeBid; // --- ADDED ---


  ProductBloc({
    required this.getAllBiddingRooms,
    required this.getBiddingRoomById,
        required this.placeBid, // --- ADDED ---

  }) : super(ProductInitial()) {
    on<FetchProductByIdEvent>(_onFetchProductById);
    on<UpdateProductDetailEvent>((event, emit) {
      if (state is ProductDetailLoaded) {
        emit(ProductDetailLoaded(event.product));
      }
    }, transformer: sequential());

        on<PlaceBidEvent>(_onPlaceBid); // --- ADDED ---

  }
  
  void _onFetchProductById(FetchProductByIdEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProduct = await getBiddingRoomById(IdParams(id: event.id));
    emit(failureOrProduct.fold(
      (failure) => ProductError(failure.message),
      (product) => ProductDetailLoaded(product),
    ));
  }

    void _onPlaceBid(PlaceBidEvent event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductDetailLoaded) {
      emit(BidPlacing(currentState.product));

      final failureOrSuccess = await placeBid(
          PlaceBidParams(productId: event.productId, amount: event.amount));

      emit(failureOrSuccess.fold(
        (failure) => BidFailure(currentState.product, failure.message),
        (updatedProduct) => BidSuccess(updatedProduct),
      ));
    }
  }
}