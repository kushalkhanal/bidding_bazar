import 'package:equatable/equatable.dart';

class SellerEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;

  const SellerEntity({required this.id, required this.firstName, required this.lastName});

  @override
  List<Object?> get props => [id, firstName, lastName];

  String get fullName => '$firstName $lastName';
}

class BidEntity extends Equatable {
  final SellerEntity bidder;
  final double amount;
  final DateTime timestamp;

  const BidEntity({required this.bidder, required this.amount, required this.timestamp});
  
  @override
  List<Object?> get props => [bidder, amount, timestamp];
}

class BiddingRoomEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double startingPrice;
  final double currentPrice;
  final List<String> imageUrls;
  final DateTime endTime;
  final SellerEntity seller;
  final String status;
  final List<BidEntity> bids;

  const BiddingRoomEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.startingPrice,
    required this.currentPrice,
    required this.imageUrls,
    required this.endTime,
    required this.seller,
    required this.status,
    required this.bids,
  });
  
  BiddingRoomEntity copyWith({
    double? currentPrice,
    List<BidEntity>? bids,
  }) {
    return BiddingRoomEntity(
      id: id,
      name: name,
      description: description,
      startingPrice: startingPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      imageUrls: imageUrls,
      endTime: endTime,
      seller: seller,
      status: status,
      bids: bids ?? this.bids,
    );
  }

  @override
  List<Object?> get props => [id, name, description, startingPrice, currentPrice, imageUrls, endTime, seller, status, bids];
}