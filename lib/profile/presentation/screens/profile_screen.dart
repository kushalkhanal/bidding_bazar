
import 'package:bidding_bazar/core/di/service_locator.dart';
import 'package:bidding_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/profile/domain/entities/profile_data_entity.dart';
import 'package:bidding_bazar/profile/presentation/bloc/profile_bloc.dart';
import 'package:bidding_bazar/profile/presentation/widgets/bidding_room_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(FetchProfileDataEvent()),
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is ProfileLoaded) {
              return _buildProfileBody(context, state.profileData);
            }
            return const SizedBox.shrink(); // Should not be reached
          },
        ),
      ),
    );
  }

  /// Builds the main body with a collapsing SliverAppBar.
  Widget _buildProfileBody(BuildContext context, ProfileDataEntity profileData) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              // This makes the app bar float as you scroll down.
              floating: true,
              // This makes the app bar snap into view when you scroll up slightly.
              snap: true,
              // This keeps the TabBar visible at the top.
              pinned: true,
              // Remove the back button if it appears
              automaticallyImplyLeading: false, 
              // The flexible space holds the profile header.
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(context, profileData.profile),
              ),
              // Set the height of the header section.
              expandedHeight: 140, 
              // The bottom of the SliverAppBar holds the TabBar.
              bottom: TabBar(
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.list_alt_rounded),
                        SizedBox(width: 8),
                        Text('My Listings'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.gavel_rounded),
                        SizedBox(width: 8),
                        Text('My Bids'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            _buildListingsView(profileData.listedItems),
            _buildBidsView(profileData.bidHistory),
          ],
        ),
      ),
    );
  }

  /// Builds the header section displaying user info and wallet balance.
  Widget _buildProfileHeader(BuildContext context, UserEntity profile) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 60.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                profile.firstName.isNotEmpty ? profile.firstName[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${profile.firstName} ${profile.lastName}',
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Wallet', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  NumberFormat.currency(symbol: '\$').format(profile.wallet),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Builds the content for the "My Listings" tab.
  Widget _buildListingsView(List<BiddingRoomEntity> rooms) {
    if (rooms.isEmpty) {
      return const Center(child: Text("You haven't listed any items yet."));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return BiddingRoomListItem(room: rooms[index]);
      },
    );
  }

  /// Builds the content for the "My Bids" tab.
  Widget _buildBidsView(BidHistoryEntity bidHistory) {
    if (bidHistory.winning.isEmpty && bidHistory.activeOrOutbid.isEmpty) {
      return const Center(child: Text("You haven't placed any bids yet."));
    }
    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: [
        if (bidHistory.winning.isNotEmpty)
          _buildBidSection(
            title: 'Winning Bids',
            rooms: bidHistory.winning,
          ),
        
        if (bidHistory.activeOrOutbid.isNotEmpty)
          _buildBidSection(
            title: 'Active / Outbid',
            rooms: bidHistory.activeOrOutbid,
          ),
      ],
    );
  }

  /// Helper widget to create a section with a title and a list of bid items.
  Widget _buildBidSection({required String title, required List<BiddingRoomEntity> rooms}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            return BiddingRoomListItem(room: rooms[index]);
          },
        ),
      ],
    );
  }
}