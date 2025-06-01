import 'dart:async';
import 'package:flutter/material.dart';

class AuctionItem {
  final String id;
  final String title;
  final String imageUrl;
  final double currentBid;
  final DateTime endTime;

  AuctionItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.currentBid,
    required this.endTime,
  });
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final List<AuctionItem> items = [
    AuctionItem(
      id: "1",
      title: "Antique Vase",
      imageUrl:
          "https://images.unsplash.com/photo-1695902047073-796e00ccd35f?q=80",
      currentBid: 120.0,
      endTime: DateTime.now().add(const Duration(minutes: 5)),
    ),
    AuctionItem(
      id: "2",
      title: "Vintage Camera",
      imageUrl:
          "https://images.unsplash.com/photo-1601854266103-c1dd42130633?q=80",
      currentBid: 80.0,
      endTime: DateTime.now().add(const Duration(minutes: 2, seconds: 30)),
    ),
    AuctionItem(
      id: "3",
      title: "Classic Watch",
      imageUrl:
          "https://images.unsplash.com/photo-1726760239464-711b7de51384?q=80",
      currentBid: 150.0,
      endTime: DateTime.now().add(const Duration(minutes: 10)),
    ),
    AuctionItem(
      id: "4",
      title: "Vintage Record Player",
      imageUrl:
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?q=80",
      currentBid: 200.0,
      endTime: DateTime.now().add(const Duration(minutes: 15)),
    ),
    AuctionItem(
      id: "5",
      title: "Classic Car Model",
      imageUrl:
          "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80",
      currentBid: 350.0,
      endTime: DateTime.now().add(const Duration(minutes: 8)),
    ),
    AuctionItem(
      id: "6",
      title: "Rare Book Collection",
      imageUrl:
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?q=80",
      currentBid: 75.0,
      endTime: DateTime.now().add(const Duration(minutes: 12)),
    ),
  ];

  final Set<String> favoriteIds = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    if (duration.inSeconds <= 0) return "Ended";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  void _showBidDialog(AuctionItem item) {
    final TextEditingController bidController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Bid on ${item.title}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Bid: \$${item.currentBid.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Your Bid Amount',
                  hintText: 'Enter amount greater than \$${item.currentBid.toStringAsFixed(2)}',
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your bid logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bid placed on ${item.title}!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB3F39),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Place Bid',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Removed Scaffold - this was hiding the bottom navigation bar
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[50]!,
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Auctions',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${items.length} items available for bidding',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Grid Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16), // Added bottom padding
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.74, // Increased to 0.74 to make cards shorter
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final timeLeft = item.endTime.difference(DateTime.now());
                    final isFav = favoriteIds.contains(item.id);
                    final isEnded = timeLeft.inSeconds <= 0;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black26,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Image Section
                          Expanded(
                            flex: 4,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Favorite Button
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        isFav ? Icons.favorite : Icons.favorite_border,
                                        color: isFav ? Colors.red : Colors.grey[600],
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isFav) {
                                            favoriteIds.remove(item.id);
                                          } else {
                                            favoriteIds.add(item.id);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // Status Badge
                                if (isEnded)
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'ENDED',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          // Content Section
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0), // Reduced from 10 to 8
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min, // Added this
                                children: [
                                  // Title
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13, // Reduced from 14 to 13
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1, // Reduced from 2 to 1
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3), // Reduced from 4 to 3
                                  
                                  // Current Bid
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6, // Reduced from 8 to 6
                                      vertical: 3, // Reduced from 4 to 3
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "\$${item.currentBid.toStringAsFixed(0)}", // Simplified text
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11, // Reduced from 12 to 11
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3), // Reduced from 4 to 3
                                  
                                  // Time Left
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        size: 14, // Reduced from 16 to 14
                                        color: isEnded ? Colors.red : Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        formatDuration(timeLeft),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isEnded ? Colors.red : Colors.orange[700],
                                          fontSize: 11, // Reduced from 12 to 11
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  
                                  // Bid Now Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 26, // Reduced from 28 to 26
                                    child: ElevatedButton(
                                      onPressed: isEnded ? null : () => _showBidDialog(item),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isEnded 
                                            ? Colors.grey[400] 
                                            : const Color(0xFFFB3F39),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: isEnded ? 0 : 2,
                                        padding: EdgeInsets.zero, // Added this
                                      ),
                                      child: Text(
                                        isEnded ? "Ended" : "Bid Now", // Shortened text
                                        style: const TextStyle(
                                          fontSize: 11, // Reduced from 12 to 11
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}