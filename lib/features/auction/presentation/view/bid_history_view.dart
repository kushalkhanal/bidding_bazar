import 'package:bidding_bazar/features/auction/domain/entity/bid_history_entity.dart';
import 'package:bidding_bazar/features/auction/presentation/view_model/bid_history_view_model.dart';
import 'package:bidding_bazar/features/auction/presentation/view/auction_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Optimized bid history card widget for better performance
class BidHistoryCardWidget extends StatelessWidget {
  final BidHistoryEntity bidHistory;
  final bool showSellerInfo;

  const BidHistoryCardWidget({
    super.key,
    required this.bidHistory,
    this.showSellerInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    final isEnded = DateTime.now().isAfter(bidHistory.auction.endTime);
    final timeLeft = bidHistory.auction.endTime.difference(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      AuctionDetailView(auctionId: bidHistory.auction.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bidHistory.auction.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bidHistory.auction.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          bidHistory.isWinningBid
                              ? Colors.green
                              : (isEnded ? Colors.red : Colors.orange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      bidHistory.isWinningBid
                          ? 'Winning'
                          : (isEnded ? 'Ended' : 'Active'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Bid',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$${bidHistory.bid.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                bidHistory.isWinningBid
                                    ? Colors.green
                                    : Colors.blue,
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
                          'Current Price',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$${bidHistory.auction.currentPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Bid placed ${_formatTimeAgo(bidHistory.bid.timestamp)}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const Spacer(),
                  if (!isEnded)
                    Text(
                      _formatTimeLeft(timeLeft),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                ],
              ),
              if (showSellerInfo) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        bidHistory.auction.seller.firstName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seller: ${bidHistory.auction.seller.firstName} ${bidHistory.auction.seller.lastName}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeLeft(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h left';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m left';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m left';
    } else {
      return '${duration.inSeconds}s left';
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class BidHistoryView extends StatefulWidget {
  final String?
  auctionId; // If null, shows user's bid history, otherwise shows auction bid history

  const BidHistoryView({super.key, this.auctionId});

  @override
  State<BidHistoryView> createState() => _BidHistoryViewState();
}

class _BidHistoryViewState extends State<BidHistoryView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadBidHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadBidHistory() {
    if (widget.auctionId != null) {
      context.read<BidHistoryViewModel>().loadAuctionBidHistory(
        auctionId: widget.auctionId!,
      );
    } else {
      context.read<BidHistoryViewModel>().loadUserBidHistory();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        setState(() => _isLoadingMore = true);
        context.read<BidHistoryViewModel>().loadMoreBidHistory();
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.auctionId != null ? 'Auction Bid History' : 'My Bid History',
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: BlocBuilder<BidHistoryViewModel, BidHistoryState>(
        builder: (context, state) {
          if (state is BidHistoryLoading && state.bidHistory.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading bid history...'),
                ],
              ),
            );
          }

          if (state is BidHistoryError && state.bidHistory.isEmpty) {
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
                    onPressed: _loadBidHistory,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.bidHistory.isEmpty && !state.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    widget.auctionId != null
                        ? 'No bids for this auction yet'
                        : 'No bid history found',
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.auctionId != null
                        ? 'Be the first to place a bid!'
                        : 'Start bidding on auctions to see your history here',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadBidHistory();
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.bidHistory.length +
                  (state.isLoading ? 1 : 0) +
                  (state.hasMoreData && !state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading indicator at the end
                if (index == state.bidHistory.length) {
                  if (state.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  // Load more indicator
                  if (state.hasMoreData && !_isLoadingMore) {
                    return const SizedBox.shrink();
                  }
                  if (_isLoadingMore) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }

                // Bid history item
                if (index < state.bidHistory.length) {
                  final bidHistory = state.bidHistory[index];
                  return BidHistoryCardWidget(
                    bidHistory: bidHistory,
                    showSellerInfo: widget.auctionId == null,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
