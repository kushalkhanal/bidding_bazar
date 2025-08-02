import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:bidding_bazar/features/home/presentation/view/bottom_views/auction_view.dart';
import 'package:bidding_bazar/features/home/presentation/view/bottom_views/history_view.dart';
import 'package:bidding_bazar/features/home/presentation/view/bottom_views/more_view.dart';
import 'package:bidding_bazar/features/home/presentation/view_model/home_state.dart';
import 'package:bidding_bazar/features/home/presentation/view_model/home_view_model.dart';
import 'package:bidding_bazar/features/auction/presentation/view/create_auction_view.dart';
import 'package:bidding_bazar/features/auction/presentation/view_model/create_auction_view_model.dart';
import 'package:bidding_bazar/core/common/notification_service.dart';
import 'package:bidding_bazar/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  final UserEntity user;
  const HomeView({super.key, required this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Initialize notification service
    NotificationService.instance.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    // List of pages to be displayed in the body
    final List<Widget> pages = [
      DashboardView(),
      const AuctionView(),
      const SizedBox.shrink(),
      const HistoryView(),
      const MoreView(),
    ];

    return BlocProvider(
      create: (context) => serviceLocator<HomeViewModel>(),
      child: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context, widget.user),
            body: pages[state.selectedIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider(
                          create:
                              (context) =>
                                  serviceLocator<CreateAuctionViewModel>(),
                          child: const CreateAuctionView(),
                        ),
                  ),
                );
              },
              shape: const CircleBorder(),
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: _buildBottomAppBar(
              context,
              state.selectedIndex,
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, UserEntity user) {
    return AppBar(
      automaticallyImplyLeading: false, // Removes the back button
      backgroundColor: Colors.white,
      elevation: 1,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${user.firstName}',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Welcome to Bidding Bazar',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Navigate to Notifications Screen
          },
          icon: const Icon(Icons.notifications_none, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildBottomAppBar(BuildContext context, int currentIndex) {
    final viewModel = context.read<HomeViewModel>();

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      // The child of BottomAppBar now uses a Row directly
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            Icons.home,
            'Home',
            0,
            currentIndex,
            viewModel.onTabTapped,
          ),
          _buildNavItem(
            Icons.gavel,
            'Auction',
            1,
            currentIndex,
            viewModel.onTabTapped,
          ),
          // Use an Expanded SizedBox for the notch to ensure proper spacing
          const Expanded(child: SizedBox(width: 40)),
          _buildNavItem(
            Icons.history,
            'History',
            3,
            currentIndex,
            viewModel.onTabTapped,
          ),
          _buildNavItem(
            Icons.more_horiz,
            'More',
            4,
            currentIndex,
            viewModel.onTabTapped,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    int currentIndex,
    Function(int) onTap,
  ) {
    final color = currentIndex == index ? Colors.green : Colors.grey;

    return Expanded(
      // 1. Wrap with Expanded to ensure items share space evenly
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          // 2. Reduce vertical padding to make it more compact
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 22,
              ), // 3. Slightly reduce icon size
              // 4. Removed the SizedBox(height: 4) which was taking up extra space
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11, // 5. Slightly reduce font size
                  fontWeight:
                      currentIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
