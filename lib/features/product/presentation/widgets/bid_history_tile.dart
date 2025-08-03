import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BidHistoryTile extends StatelessWidget {
  final BidEntity bid;
  const BidHistoryTile({super.key, required this.bid});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(bid.bidder.firstName.isNotEmpty ? bid.bidder.firstName[0] : 'U'),
        ),
        title: Text(
          bid.bidder.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat.yMMMd().add_jm().format(bid.timestamp)),
        trailing: Text(
          '\$${NumberFormat('#,##0.00').format(bid.amount)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}