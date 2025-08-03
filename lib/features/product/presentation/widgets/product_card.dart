import 'package:bidding_bazar/core/utils/constants.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/presentation/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final BiddingRoomEntity product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrls.isNotEmpty
        ? '${AppConstants.baseUrl.replaceAll("/api", "")}${product.imageUrls.first}'
        : 'https://via.placeholder.com/150';

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product_image_${product.id}',
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Current Bid: \$${NumberFormat('#,##0.00').format(product.currentPrice)}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}