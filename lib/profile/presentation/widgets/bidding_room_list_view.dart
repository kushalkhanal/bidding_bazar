import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';

class BiddingRoomListView extends StatelessWidget {
  final List<BiddingRoomEntity> rooms;
  final String emptyListMessage;

  const BiddingRoomListView({
    super.key,
    required this.rooms,
    this.emptyListMessage = "Nothing to show here.",
  });

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return Center(child: Text(emptyListMessage));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return ProductCard(product: rooms[index]);
      },
    );
  }
}