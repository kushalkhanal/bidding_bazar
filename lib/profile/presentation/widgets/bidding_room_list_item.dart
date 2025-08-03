import 'package:bidding_bazar/core/utils/constants.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/presentation/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BiddingRoomListItem extends StatelessWidget {
  final BiddingRoomEntity room;
  const BiddingRoomListItem({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final imageUrl = room.imageUrls.isNotEmpty
        ? '${AppConstants.baseUrl.replaceAll("/api", "")}${room.imageUrls.first}'
        : 'https://via.placeholder.com/150';

    final bool isAuctionOver = DateTime.now().isAfter(room.endTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: room.id),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 40),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Current Bid: \$${NumberFormat('#,##0.00').format(room.currentPrice)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAuctionOver ? 'Auction Ended' : 'Ends: ${DateFormat.yMd().add_jm().format(room.endTime.toLocal())}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isAuctionOver ? Colors.red : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}