
import 'package:bidding_bazar/core/api/socket_client.dart';
import 'package:bidding_bazar/core/di/service_locator.dart';
import 'package:bidding_bazar/core/utils/constants.dart';
import 'package:bidding_bazar/features/product/data/models/bidding_room_model.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/presentation/bloc/product_bloc.dart';
import 'package:bidding_bazar/features/product/presentation/widgets/bid_history_tile.dart';
import 'package:bidding_bazar/features/product/presentation/widgets/countdown_timer_widget.dart';
import 'package:bidding_bazar/features/product/presentation/widgets/place_bid_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Get the singleton instance of our socket client
  final SocketClient _socketClient = sl<SocketClient>();

  @override
  void initState() {
    super.initState();
    // Connect to the socket server and join the room for this specific product
    _socketClient.connect();
    _socketClient.joinProductRoom(widget.productId);

    // Set up a listener for the 'bid_update' event from the server
    _socketClient.listenForBidUpdates((data) {
      // Ensure the widget is still in the tree before updating state
      if (mounted && data is Map<String, dynamic>) {
        // When an update is received, parse the new data into our model
        final updatedProduct = BiddingRoomModel.fromJson(data);
        // Add an event to our BLoC to update the UI with the new data
        context.read<ProductBloc>().add(UpdateProductDetailEvent(updatedProduct));
      }
    });
  }

  @override
  void dispose() {
    // It's crucial to leave the room and disconnect to avoid memory leaks
    // and unnecessary server load when the user leaves the screen.
    _socketClient.leaveProductRoom(widget.productId);
    _socketClient.disconnect();
    super.dispose();
  }

  /// A helper method to show the bidding dialog
  void _showPlaceBidDialog(BuildContext context, BiddingRoomEntity product) {
    showDialog(
      context: context,
      builder: (_) => PlaceBidDialog(
        currentPrice: product.currentPrice,
        onBidPlaced: (amount) {
          // When the user submits a bid, add the PlaceBidEvent to the BLoC
          context
              .read<ProductBloc>()
              .add(PlaceBidEvent(productId: product.id, amount: amount));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductBloc>()..add(FetchProductByIdEvent(widget.productId)),
      child: Scaffold(
        // Use BlocConsumer to both listen for state changes (for SnackBars)
        // and build the UI based on the state.
        body: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            // Show a SnackBar for success or failure of a bid
            if (state is BidSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text('Bid update successful!'),
                  backgroundColor: Colors.green,
                ));
            }
            if (state is BidFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('Bid Failed: ${state.message}'),
                  backgroundColor: Colors.red,
                ));
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            // All states like BidPlacing, BidSuccess, BidFailure extend ProductDetailLoaded,
            // so this single check works for all of them.
            if (state is ProductDetailLoaded) {
              return _buildProductBody(context, state.product);
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
        bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
           builder: (context, state) {
             if (state is ProductDetailLoaded) {
                return _buildBottomBar(context, state.product);
             }
             return const SizedBox.shrink();
           },
        ),
      ),
    );
  }

  // --- UI Build Methods ---

  Widget _buildProductBody(BuildContext context, BiddingRoomEntity product) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(product.name, style: const TextStyle(color: Colors.white, fontSize: 16.0)),
            background: _buildImageCarousel(product),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sold by: ${product.seller.fullName}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600)),
                const SizedBox(height: 16),
                _buildPriceInfo(context, product),
                const SizedBox(height: 24),
                const Text('Auction Ends In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                CountdownTimerWidget(endTime: product.endTime),
                const SizedBox(height: 24),
                const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(product.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 24),
                const Text('Bid History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                product.bids.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No bids yet. Be the first!'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: product.bids.length,
                        itemBuilder: (context, index) {
                          return BidHistoryTile(bid: product.bids[index]);
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, BiddingRoomEntity product) {
    // Check if the current state is BidPlacing to show a loading indicator
    final bool isBidding = context.watch<ProductBloc>().state is BidPlacing;
    final bool auctionEnded = DateTime.now().isAfter(product.endTime);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            // Disable the button if bidding is in progress or if the auction has ended
            onPressed: isBidding || auctionEnded ? null : () => _showPlaceBidDialog(context, product),
            icon: isBidding
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))
                : const Icon(Icons.gavel),
            label: Text(
              isBidding ? 'Placing Bid...' : (auctionEnded ? 'Auction Ended' : 'Place Bid')
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
              // Grey out the button if it's disabled
              backgroundColor: auctionEnded ? Colors.grey : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel(BiddingRoomEntity product) {
    final imageWidgets = product.imageUrls.map((url) {
      final fullUrl = '${AppConstants.baseUrl.replaceAll("/api", "")}$url';
      return Builder(
        builder: (BuildContext context) {
          return Image.network(fullUrl, fit: BoxFit.cover, width: MediaQuery.of(context).size.width);
        },
      );
    }).toList();

    return Hero(
      tag: 'product_image_${product.id}',
      child: CarouselSlider(
        options: CarouselOptions(
          height: 350,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          autoPlay: imageWidgets.length > 1,
        ),
        items: imageWidgets,
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context, BiddingRoomEntity product) {
     return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _priceColumn('Starting Price', product.startingPrice, context),
            _priceColumn('Current Bid', product.currentPrice, context, isCurrent: true),
          ],
        ),
      ),
    );
  }
  
  Widget _priceColumn(String label, double price, BuildContext context, {bool isCurrent = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          '\$${NumberFormat('#,##0.00').format(price)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isCurrent ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}