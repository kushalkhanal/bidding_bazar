import 'package:bidding_bazar/features/auction/data/model/bid_model.dart';
import 'package:bidding_bazar/features/auction/data/model/partial_user_model.dart';
import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';

class AuctionModel extends AuctionEntity {
  const AuctionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.startingPrice,
    required super.currentPrice,
    required super.endTime,
    required super.seller,
    required super.imageUrls,
    required super.bids,
    required super.status,
  });

    factory AuctionModel.fromJson(Map<String, dynamic> json) {
    try {
      print('=== Starting AuctionModel.fromJson ===');
      print('Full JSON: $json');

      // Handle imageUrls parsing more robustly
      List<String> imageUrls = [];
      if (json['imageUrls'] != null) {
        print('imageUrls type: ${json['imageUrls'].runtimeType}');
        print('imageUrls value: ${json['imageUrls']}');

        if (json['imageUrls'] is List) {
          imageUrls = List<String>.from(json['imageUrls']);
        } else if (json['imageUrls'] is String) {
          // If it's a single string, try to parse it as a JSON array
          String imageUrlsStr = json['imageUrls'];
          if (imageUrlsStr.startsWith('[') && imageUrlsStr.endsWith(']')) {
            // Remove brackets and split by comma
            String content = imageUrlsStr.substring(1, imageUrlsStr.length - 1);
            if (content.isNotEmpty) {
              imageUrls = content.split(',').map((url) => url.trim()).toList();
            }
          } else {
            // If it's a single URL string
            imageUrls = [imageUrlsStr];
          }
        } else {
          // Handle other types (like when it comes as a string representation)
          print(
            'imageUrls is not List or String, type: ${json['imageUrls'].runtimeType}',
          );
          // Try to convert to string and parse
          try {
            String imageUrlsStr = json['imageUrls'].toString();
            if (imageUrlsStr.startsWith('[') && imageUrlsStr.endsWith(']')) {
              String content = imageUrlsStr.substring(1, imageUrlsStr.length - 1);
              if (content.isNotEmpty) {
                imageUrls = content.split(',').map((url) => url.trim()).toList();
              }
            } else {
              imageUrls = [imageUrlsStr];
            }
          } catch (e) {
            print('Failed to parse imageUrls: $e');
            imageUrls = [];
          }
        }
      }

      print('About to parse seller: ${json['seller']}');

      return AuctionModel(
        id: (json['_id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0.0,
        currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
        endTime: DateTime.parse(
          json['endTime'] ?? DateTime.now().toIso8601String(),
        ),
        seller: _parseSeller(json['seller']),
        imageUrls: imageUrls,
        bids: _parseBids(json['bids']),
        status: (json['status'] ?? 'active').toString(),
      );
    } catch (e) {
      print('Error parsing auction JSON: $e');
      print('JSON data: $json');
      // Instead of rethrowing, return a default auction to prevent crashes
      return AuctionModel(
        id: (json['_id'] ?? '').toString(),
        name: (json['name'] ?? 'Unknown Auction').toString(),
        description: (json['description'] ?? '').toString(),
        startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0.0,
        currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
        endTime: DateTime.now(),
        seller: PartialUserModel(id: '', firstName: 'Unknown', lastName: 'User'),
        imageUrls: [],
        bids: [],
        status: 'active',
      );
    }
  }

  static PartialUserModel _parseSeller(dynamic sellerData) {
    try {
      print('Seller data type: ${sellerData.runtimeType}');
      print('Seller data value: $sellerData');

      if (sellerData is Map<String, dynamic>) {
        print('Parsing seller as Map');
        return PartialUserModel.fromJson(sellerData);
      } else if (sellerData is String) {
        print('Parsing seller as String');
        
        // Handle the format: {_id: 688cf4ae2759821ddabf27b2, firstName: ram, lastName: khanal}
        if (sellerData.startsWith('{') && sellerData.endsWith('}')) {
          try {
            String cleanData = sellerData
                .replaceAll('{', '')
                .replaceAll('}', '');
            Map<String, String> parsedData = {};

            // Split by comma and parse key-value pairs
            List<String> pairs = cleanData.split(',');
            for (String pair in pairs) {
              List<String> keyValue = pair.split(':');
              if (keyValue.length == 2) {
                String key = keyValue[0].trim();
                String value = keyValue[1].trim();
                // Remove quotes if present
                if (value.startsWith('"') && value.endsWith('"')) {
                  value = value.substring(1, value.length - 1);
                }
                parsedData[key] = value;
              }
            }

            print('Parsed seller data: $parsedData');
            return PartialUserModel(
              id: parsedData['_id'] ?? parsedData['id'] ?? '',
              firstName: parsedData['firstName'] ?? 'User',
              lastName: parsedData['lastName'] ?? '',
            );
          } catch (e) {
            print('Failed to parse seller string as JSON: $e');
            return PartialUserModel(
              id: sellerData,
              firstName: 'User',
              lastName: '',
            );
          }
        } else {
          // If seller is a string (user ID), create a minimal user model
          return PartialUserModel(
            id: sellerData,
            firstName: 'User',
            lastName: '',
          );
        }
      } else {
        print('Parsing seller as fallback');
        // Default fallback
        return PartialUserModel(id: '', firstName: 'Unknown', lastName: 'User');
      }
    } catch (e) {
      print('Error parsing seller data: $e');
      print('Seller data: $sellerData');
      return PartialUserModel(id: '', firstName: 'Unknown', lastName: 'User');
    }
  }

  static List<BidModel> _parseBids(dynamic bidsData) {
    try {
      if (bidsData is List) {
        return bidsData
            .map((bidJson) {
              if (bidJson is Map<String, dynamic>) {
                return BidModel.fromJson(bidJson);
              } else {
                print('Invalid bid data: $bidJson');
                return null;
              }
            })
            .where((bid) => bid != null)
            .cast<BidModel>()
            .toList();
      }
      return [];
    } catch (e) {
      print('Error parsing bids: $e');
      return [];
    }
  }
}
