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
          "https://images.unsplash.com/photo-1695902047073-796e00ccd35f?q=80&w=1969&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D/150",
      currentBid: 120.0,
      endTime: DateTime.now().add(const Duration(minutes: 5)),
    ),
    AuctionItem(
      id: "2",
      title: "Vintage Camera",
      imageUrl:
          "https://images.unsplash.com/photo-1601854266103-c1dd42130633?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D/150",
      currentBid: 80.0,
      endTime: DateTime.now().add(const Duration(minutes: 2, seconds: 30)),
    ),
    AuctionItem(
      id: "3",
      title: "Classic Watch",
      imageUrl:
          "https://images.unsplash.com/photo-1726760239464-711b7de51384?q=80&w=1756&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D/150",
      currentBid: 150.0,
      endTime: DateTime.now().add(const Duration(minutes: 10)),
    ),
  ];

  final Set<String> favoriteIds = {};
  Timer? _timer;
  int _selectedIndex = 0;

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bidding Bazar")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
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
                          style: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
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
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedIconTheme: const IconThemeData(
          color: Colors.amberAccent,
          size: 30,
        ),
        selectedLabelStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
