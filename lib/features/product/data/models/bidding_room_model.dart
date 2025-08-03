
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';

class SellerModel extends SellerEntity {
  const SellerModel({
    required super.id,
    required super.firstName,
    required super.lastName,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}

// --- BidModel can now safely use SellerModel ---
class BidModel extends BidEntity {
  const BidModel({
    required super.bidder,
    required super.amount,
    required super.timestamp,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    final bidderData = json['bidder'];
    SellerModel bidder;

    if (bidderData is Map<String, dynamic>) {
      // Case 1: The bidder is fully populated (a JSON object).
      bidder = SellerModel.fromJson(bidderData);
    } else {
      // Case 2: The bidder is just a String ID.
      // Create a placeholder with the ID and placeholder names.
      bidder = SellerModel(
        id: bidderData.toString(),
        firstName: 'Unknown',
        lastName: 'Bidder',
      );
    }

    return BidModel(
      bidder: bidder,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

// --- BiddingRoomModel can now safely use SellerModel and BidModel ---
class BiddingRoomModel extends BiddingRoomEntity {
  const BiddingRoomModel({
    required super.id,
    required super.name,
    required super.description,
    required super.startingPrice,
    required super.currentPrice,
    required super.imageUrls,
    required super.endTime,
    required super.seller,
    required super.status,
    required super.bids,
  });

  factory BiddingRoomModel.fromJson(Map<String, dynamic> json) {
    var bidsList = <BidModel>[];
    if (json['bids'] != null) {
      for (var bidJson in (json['bids'] as List)) {
        bidsList.add(BidModel.fromJson(bidJson));
      }
    }

    var imageUrlsList = <String>[];
    if (json['imageUrls'] != null) {
      imageUrlsList = List<String>.from(json['imageUrls']);
    }

    final sellerData = json['seller'];
    SellerModel seller;

    if (sellerData is Map<String, dynamic>) {
      // Case 1: The seller is fully populated (a JSON object).
      seller = SellerModel.fromJson(sellerData);
    } else {
      // Case 2: The seller is just a String ID.
      // Create a placeholder SellerModel.
      seller = SellerModel(
        id: sellerData.toString(),
        firstName: 'Unknown',
        lastName: 'Seller',
      );
    }

    return BiddingRoomModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      startingPrice: (json['startingPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      imageUrls: imageUrlsList,
      endTime: DateTime.parse(json['endTime']),
      seller: seller, // Use the defensively-parsed seller object
      status: json['status'],
      bids: bidsList,
    );
  }
}