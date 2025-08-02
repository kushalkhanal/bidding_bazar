import 'package:bidding_bazar/features/auction/domain/entity/auction_entity.dart';
import 'package:bidding_bazar/features/auction/presentation/view_model/auction_detail_view_model.dart';
import 'package:bidding_bazar/core/network/socket_service.dart';
import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/features/auction/presentation/view/bid_history_view.dart';
import 'package:bidding_bazar/features/auction/presentation/view_model/bid_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AuctionDetailView extends StatefulWidget {
  final String auctionId;

  const AuctionDetailView({super.key, required this.auctionId});

  @override
  State<AuctionDetailView> createState() => _AuctionDetailViewState();
}

class _AuctionDetailViewState extends State<AuctionDetailView> {
  final TextEditingController _bidController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<AuctionDetailViewModel>().loadAuction(widget.auctionId);

    // Connect to socket and join auction room
    SocketService.instance.connect();
    SocketService.instance.joinAuctionRoom(widget.auctionId);

    // Listen for real-time bid updates
    SocketService.instance.bidUpdates.listen((data) {
      // Refresh auction data when new bid is placed
      context.read<AuctionDetailViewModel>().loadAuction(widget.auctionId);
    });
  }

  @override
  void dispose() {
    _bidController.dispose();
    SocketService.instance.leaveAuctionRoom(widget.auctionId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: BlocBuilder<AuctionDetailViewModel, AuctionDetailState>(
        builder: (context, state) {
          if (state is AuctionDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuctionDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context
                            .read<AuctionDetailViewModel>()
                            .loadAuction(widget.auctionId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AuctionDetailLoaded) {
            return _buildAuctionDetail(state.auction!);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAuctionDetail(AuctionEntity auction) {
    final isEnded = DateTime.now().isAfter(auction.endTime);
    final timeLeft = auction.endTime.difference(DateTime.now());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageCarousel(auction.imageUrls),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAuctionHeader(auction, isEnded),
                const SizedBox(height: 16),
                _buildAuctionInfo(auction, isEnded, timeLeft),
                const SizedBox(height: 24),
                _buildBiddingSection(auction, isEnded),
                const SizedBox(height: 24),
                _buildBidsHistory(auction),
                const SizedBox(height: 16),
                _buildViewFullHistoryButton(auction.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> imageUrls) {
    if (imageUrls.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image, size: 64, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: imageUrls[index],
            fit: BoxFit.cover,
            memCacheWidth: 800,
            memCacheHeight: 450,
            placeholder:
                (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            errorWidget:
                (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
          );
        },
      ),
    );
  }

  Widget _buildAuctionHeader(AuctionEntity auction, bool isEnded) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                auction.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isEnded ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isEnded ? 'Ended' : 'Active',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          auction.description,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildAuctionInfo(
    AuctionEntity auction,
    bool isEnded,
    Duration timeLeft,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Price',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${auction.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isEnded ? 'Ended' : 'Time Left',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEnded ? 'Ended' : _formatTimeLeft(timeLeft),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isEnded ? Colors.red : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Text(
                  auction.seller.firstName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      '${auction.seller.firstName} ${auction.seller.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingSection(AuctionEntity auction, bool isEnded) {
    return BlocBuilder<AuctionDetailViewModel, AuctionDetailState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Place Your Bid',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (isEnded)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.red[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This auction has ended',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _bidController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Bid Amount (\$)',
                          hintText: 'Enter your bid amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a bid amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null) {
                            return 'Please enter a valid amount';
                          }
                          if (amount <= auction.currentPrice) {
                            return 'Bid must be higher than current price (\$${auction.currentPrice.toStringAsFixed(2)})';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              state is AuctionDetailLoading
                                  ? null
                                  : () {
                                    if (_formKey.currentState!.validate()) {
                                      final amount = double.parse(
                                        _bidController.text,
                                      );
                                      context
                                          .read<AuctionDetailViewModel>()
                                          .placeBid(
                                            auctionId: auction.id,
                                            amount: amount,
                                          );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              state is AuctionDetailLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Place Bid',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBidsHistory(AuctionEntity auction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bid History (${auction.bids.length} bids)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (auction.bids.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No bids yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: auction.bids.length,
              itemBuilder: (context, index) {
                final bid = auction.bids[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      bid.bidder.firstName[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    '${bid.bidder.firstName} ${bid.bidder.lastName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _formatBidTime(bid.timestamp),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  trailing: Text(
                    '\$${bid.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  String _formatTimeLeft(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  String _formatBidTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildViewFullHistoryButton(String auctionId) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create: (context) => serviceLocator<BidHistoryViewModel>(),
                    child: BidHistoryView(auctionId: auctionId),
                  ),
            ),
          );
        },
        icon: const Icon(Icons.history),
        label: const Text('View Full Bid History'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
