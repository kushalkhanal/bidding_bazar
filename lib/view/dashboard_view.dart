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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              final timeLeft = item.endTime.difference(DateTime.now());
              final isFav = favoriteIds.contains(item.id);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            item.imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                height: 120,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.broken_image),
                                  ),
                                ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Bid: \$${item.currentBid.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ends in: ${formatDuration(timeLeft)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  timeLeft.inSeconds <= 0
                                      ? Colors.red
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
