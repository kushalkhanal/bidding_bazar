import 'package:bidding_bazar/features/auction/data/model/auction_model.dart';
import 'package:bidding_bazar/features/auction/domain/entity/paginated_auctions_entity.dart';
import 'package:flutter/foundation.dart';

class PaginatedAuctionsModel extends PaginatedAuctionsEntity {
  const PaginatedAuctionsModel({
    required super.products,
    required super.page,
    required super.totalPages,
  });

  factory PaginatedAuctionsModel.fromJson(Map<String, dynamic> json) {
    print('=== Starting PaginatedAuctionsModel.fromJson ===');
    print('Full JSON: $json');

    try {
      final productsList = json['products'] as List?;
      print('Products list type: ${productsList.runtimeType}');
      print('Products list length: ${productsList?.length}');

      if (productsList != null) {
        for (int i = 0; i < productsList.length; i++) {
          print('Product $i type: ${productsList[i].runtimeType}');
          print('Product $i value: ${productsList[i]}');
        }
      }

      return PaginatedAuctionsModel(
        products:
            productsList
                ?.map((productJson) {
                  print('About to parse product: $productJson');
                  try {
                    if (productJson is Map<String, dynamic>) {
                      return AuctionModel.fromJson(productJson);
                    } else {
                      print(
                        'Product is not Map<String, dynamic>, type: ${productJson.runtimeType}',
                      );
                      // Try to convert to Map if possible
                      try {
                        if (productJson is String) {
                          // This shouldn't happen, but let's handle it
                          print('Product is a string, cannot parse');
                          return null;
                        }
                        // Try to convert to Map
                        Map<String, dynamic> convertedJson =
                            Map<String, dynamic>.from(productJson);
                        return AuctionModel.fromJson(convertedJson);
                      } catch (conversionError) {
                        print(
                          'Failed to convert product to Map: $conversionError',
                        );
                        return null;
                      }
                    }
                  } catch (e) {
                    print('Error parsing product: $e');
                    return null;
                  }
                })
                .where((product) => product != null)
                .cast<AuctionModel>()
                .toList() ??
            [],
        page: json['page'] ?? 1,
        totalPages: json['totalPages'] ?? 1,
      );
    } catch (e) {
      print('Error in PaginatedAuctionsModel.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Optimized parsing using compute for heavy operations
  static Future<PaginatedAuctionsModel> fromJsonAsync(
    Map<String, dynamic> json,
  ) async {
    return await compute(_parseAuctionsInIsolate, json);
  }

  static PaginatedAuctionsModel _parseAuctionsInIsolate(
    Map<String, dynamic> json,
  ) {
    print('=== Starting PaginatedAuctionsModel._parseAuctionsInIsolate ===');
    print('Full JSON: $json');

    try {
      final productsList = json['products'] as List?;
      print('Products list type: ${productsList.runtimeType}');
      print('Products list length: ${productsList?.length}');

      if (productsList != null) {
        for (int i = 0; i < productsList.length; i++) {
          print('Product $i type: ${productsList[i].runtimeType}');
          print('Product $i value: ${productsList[i]}');
        }
      }

      return PaginatedAuctionsModel(
        products:
            productsList
                ?.map((productJson) {
                  print('About to parse product: $productJson');
                  try {
                    if (productJson is Map<String, dynamic>) {
                      return AuctionModel.fromJson(productJson);
                    } else {
                      print(
                        'Product is not Map<String, dynamic>, type: ${productJson.runtimeType}',
                      );
                      // Try to convert to Map if possible
                      try {
                        if (productJson is String) {
                          // This shouldn't happen, but let's handle it
                          print('Product is a string, cannot parse');
                          return null;
                        }
                        // Try to convert to Map
                        Map<String, dynamic> convertedJson =
                            Map<String, dynamic>.from(productJson);
                        return AuctionModel.fromJson(convertedJson);
                      } catch (conversionError) {
                        print(
                          'Failed to convert product to Map: $conversionError',
                        );
                        return null;
                      }
                    }
                  } catch (e) {
                    print('Error parsing product: $e');
                    return null;
                  }
                })
                .where((product) => product != null)
                .cast<AuctionModel>()
                .toList() ??
            [],
        page: json['page'] ?? 1,
        totalPages: json['totalPages'] ?? 1,
      );
    } catch (e) {
      print('Error in PaginatedAuctionsModel._parseAuctionsInIsolate: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}
